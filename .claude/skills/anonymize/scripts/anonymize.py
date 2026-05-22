#!/usr/bin/env python3
# =============================================================================
# anonymize.py -- bidirectional placeholder anonymization for LLM-bound text
# =============================================================================
# Part of the `anonymize` Claude skill.
#
# Two operations:
#   scrub:   text -> anonymized text + map (persisted to disk)
#   restore: text -> de-anonymized text (using the map)
#
# Plus inspect/reset for managing the local map.
#
# Pure Python (stdlib only). Works on any host with `python` on PATH.
# CLI usage and library API documented in ../SKILL.md.
# =============================================================================

import argparse
import json
import os
import re
import sys
from pathlib import Path

# -----------------------------------------------------------------------------
# Defaults
# -----------------------------------------------------------------------------
DEFAULT_MAP_DIR = ".anonymize"
DEFAULT_MAP_FILE = "map.json"

SCRIPT_DIR = Path(__file__).resolve().parent
WHITELIST_PATH = SCRIPT_DIR / "whitelist.json"
TICKERS_PATH = SCRIPT_DIR / "tickers.json"


def _load_json(path, default):
    try:
        return json.loads(Path(path).read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return default


def _save_json(path, data):
    p = Path(path)
    p.parent.mkdir(parents=True, exist_ok=True)
    tmp = p.with_suffix(p.suffix + ".tmp")
    tmp.write_text(json.dumps(data, indent=2, ensure_ascii=False),
                   encoding="utf-8")
    os.replace(tmp, p)


# -----------------------------------------------------------------------------
# Map structure
# -----------------------------------------------------------------------------
# {
#   "version": 1,
#   "next_index": {"COMPANY": 3, "PERSON": 5, ...},
#   "entries": {
#     "Providence Health":      {"placeholder": "{{COMPANY_1}}", "type": "COMPANY"},
#     "Sarah Chen":             {"placeholder": "{{PERSON_2}}",  "type": "PERSON"},
#     ...
#   }
# }
def _new_map():
    return {"version": 1, "next_index": {}, "entries": {}}


def load_map(map_path):
    return _load_json(map_path, _new_map())


def save_map(map_path, m):
    _save_json(map_path, m)


def _allocate(m, kind, hint=None):
    """Allocate a new placeholder of the given kind. Returns the placeholder."""
    n = m["next_index"].get(kind, 0) + 1
    m["next_index"][kind] = n
    if hint:
        return f"{{{{{kind}_{n}_{hint}}}}}"
    return f"{{{{{kind}_{n}}}}}"


def _get_or_create(m, real, kind, hint=None):
    """Idempotent: same real value -> same placeholder."""
    if real in m["entries"]:
        return m["entries"][real]["placeholder"]
    ph = _allocate(m, kind, hint)
    m["entries"][real] = {"placeholder": ph, "type": kind, **({"hint": hint} if hint else {})}
    return ph


# -----------------------------------------------------------------------------
# Patterns (Layer 2)
# -----------------------------------------------------------------------------
# Each pattern is (compiled_regex, kind, optional hint-extractor).
# Order matters: more-specific patterns must precede more-general ones, since
# the scrubber applies them in declared order and any match removes the span
# from later consideration.

# Email
_RE_EMAIL = re.compile(r"\b[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}\b")

# International phone (loose) -- must precede national-ID regexes that overlap
_RE_PHONE_INTL = re.compile(
    r"\+\d{1,3}[\s.\-]?\(?\d{1,4}\)?[\s.\-]?\d{1,4}[\s.\-]?\d{1,9}"
)
_RE_PHONE_NA = re.compile(
    r"\(?\b\d{3}\)?[\s.\-]\d{3}[\s.\-]\d{4}\b"
)

# Salesforce 15/18-char org id (starts with 00)
_RE_SF_ORG_ID = re.compile(r"\b00[A-Za-z0-9]{13}(?:[A-Za-z]{3})?\b")

# LinkedIn URL (protocol optional; bare linkedin.com/in/... is common)
_RE_LINKEDIN = re.compile(
    r"(?:https?://)?(?:www\.)?linkedin\.com/(?:in|company|pub)/[A-Za-z0-9_\-/]+",
    re.IGNORECASE,
)

# Slack workspace URL
_RE_SLACK_URL = re.compile(
    r"https?://[a-z0-9\-]+\.slack\.com(?:/[^\s)]*)?", re.IGNORECASE
)

# Slack channel with custom prefix (not default channel names)
_DEFAULT_CHANNELS = {"general", "random", "announcements", "help", "introductions"}
_RE_SLACK_CHAN = re.compile(r"#([a-z0-9][a-z0-9_\-]{2,})")

# Generic URL (non-whitelisted host)
_RE_URL = re.compile(r"https?://[^\s)>\]]+", re.IGNORECASE)

# Money: USD with comma thousands (>= 4 digits)
_RE_MONEY_COMMA = re.compile(r"\$[\d,]{4,}(?:\.\d+)?(?:\s?[KMBkmb])?")

# Money: USD with magnitude suffix ($1.5M, $4.2B)
_RE_MONEY_SUFFIX = re.compile(
    r"\$\d+(?:\.\d+)?\s?[KMBkmb](?:i?l)?(?:lion)?\b"
)

# ARR/MRR/TCV/ACV phrasing with amount. Leading `$` is optional and
# consumed when present so the placeholder doesn't leak a stray `$` glyph
# (`$850M ARR` -> `{{REVENUE_1_ARR}}` instead of `${{REVENUE_1_ARR}}`).
_RE_REVENUE_PHRASE = re.compile(
    r"\$?\b\d+(?:\.\d+)?\s?[KMBkmb]?\s?(?:ARR|MRR|TCV|ACV|GMV)\b",
    re.IGNORECASE,
)

# Bare domain (no scheme): example.com, acme-credit-union.com. Whitelisted
# hosts pass through unchanged; everything else gets scrubbed. The TLD list
# below is intentionally narrow -- broad TLD matching false-positives on
# things like "Cloud.run" or file extensions in prose.
_RE_BARE_DOMAIN = re.compile(
    r"(?<![A-Za-z0-9._/-])"        # don't match inside another URL/path
    r"(?:[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+"  # subdomain.host.
    r"(?:com|org|net|io|co|gov|edu|ai|app|dev|cloud|tech|info|biz|us|uk|ca|au|de|fr|jp|nz)"
    r"\b(?!/)"                      # bare domain only -- no path follows
)

# US SSN
_RE_SSN = re.compile(r"\b\d{3}-\d{2}-\d{4}\b")
# Canadian SIN
_RE_SIN = re.compile(r"\b\d{3}[\s\-]?\d{3}[\s\-]?\d{3}\b")
# UK NI
_RE_UK_NI = re.compile(r"\b[A-Z]{2}\d{6}[A-Z]\b")
# US EIN
_RE_EIN = re.compile(r"\b\d{2}-\d{7}\b")
# Aadhaar (India)
_RE_AADHAAR = re.compile(r"\b\d{4}\s?\d{4}\s?\d{4}\b")

# Regulatory case number
_RE_CASE_ID = re.compile(
    r"\b(?:OCC|FTC|SEC|EEOC|DOL|HHS|CFPB|FDIC|CMS)\s?(?:[A-Z]+\-)?\d{2,4}\-\d+\b"
)

# Specific dates (calendar)
_RE_DATE_ISO = re.compile(r"\b(?:19|20)\d{2}-(?:0\d|1[012])-(?:0\d|[12]\d|3[01])\b")
_RE_DATE_WORD = re.compile(
    r"\b(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s\d{1,2},?\s(?:19|20)\d{2}\b"
)
_RE_DATE_SLASH = re.compile(r"\b\d{1,2}/\d{1,2}/(?:19|20)\d{2}\b")

# Precise employee count (singular or plural; the noun comes after a number)
_RE_HEADCOUNT = re.compile(
    r"\b(\d{1,3}(?:,\d{3})*)\s?(?:employees?|FTEs?|staff)\b", re.IGNORECASE
)

# Coordinates (lat/long)
_RE_COORDS = re.compile(r"\b-?\d{1,3}\.\d{4,},\s*-?\d{1,3}\.\d{4,}\b")

# Stock ticker (over-matches by design; filtered against tickers.json)
_RE_TICKER = re.compile(r"\$?\b[A-Z]{2,5}\b")

# Heuristic: capitalized multi-word proper-noun phrase (2-5 words)
_RE_PROPER_NOUN = re.compile(
    r"\b([A-Z][a-zA-Z]+(?:\s+(?:of|the|and|for|de|du|la|le)\s+|\s+)?){1,4}"
    r"[A-Z][a-zA-Z&]+\b"
)

# Company-marker words (Layer 3 type hint)
_COMPANY_MARKERS = {
    "Inc", "Inc.", "LLC", "L.L.C.", "Ltd", "Ltd.", "Limited", "Corp", "Corp.",
    "Corporation", "Company", "Co.", "Hospital", "Health", "Bank", "Credit Union",
    "Systems", "Group", "University", "College", "Foundation", "Authority",
    "District", "Trust", "Society", "Association", "Holdings",
}

# Title prefixes (Layer 3 person detection)
_PERSON_TITLES = {"Mr.", "Mrs.", "Ms.", "Mx.", "Dr.", "Prof.", "Sen.", "Rep.",
                  "Sir", "Lady", "Lord"}

# Role suffixes (Layer 3 person detection)
_PERSON_ROLE_HINTS = re.compile(
    r",?\s+(?:the\s+|our\s+|their\s+)?(?:CEO|COO|CFO|CIO|CTO|CMO|CRO|CISO|CCO|CDO|"
    r"VP|SVP|EVP|Director|Manager|Lead|Head|Chief|President|Officer|"
    r"Champion|Buyer|Architect|Engineer|Administrator|Specialist)\b",
    re.IGNORECASE,
)

# Whitelist (loaded lazily; falls back to a small built-in if file missing)
_BUILTIN_WHITELIST = {
    # Salesforce product names
    "Salesforce", "Sales Cloud", "Service Cloud", "Marketing Cloud",
    "Commerce Cloud", "Data Cloud", "Experience Cloud", "Field Service",
    "Revenue Cloud", "Agentforce", "Einstein", "Trust Layer", "Hyperforce",
    "Atlas", "Tableau", "Tableau Pulse", "MuleSoft", "Anypoint", "Slack",
    "Heroku", "Apex", "Lightning", "Flow", "Visualforce", "Pardot",
    "Trailhead", "LWC", "Trailblazer", "AppExchange", "Health Cloud",
    "Life Sciences Cloud", "Manufacturing Cloud", "Automotive Cloud",
    "Communications Cloud", "Consumer Goods Cloud", "Education Cloud",
    "Energy & Utilities Cloud", "Financial Services Cloud", "Media Cloud",
    "Nonprofit Cloud", "Public Sector Solutions", "Government Cloud",
    "Government Cloud Plus",
    # Cloud vendors
    "Microsoft", "Microsoft Dynamics", "Dynamics 365", "HubSpot", "ServiceNow",
    "AWS", "Amazon Web Services", "Google Cloud", "GCP", "Azure",
    "Oracle", "SAP", "Workday", "Zendesk", "Stripe", "Twilio", "Okta",
    # Major countries / regions
    "United States", "United Kingdom", "European Union", "EMEA", "APAC",
    "LATAM", "North America", "South America", "Asia", "Europe", "Africa",
    # Healthcare / industry vocab
    "Epic", "Cerner", "MyChart", "EHR", "EMR", "FHIR",
}

# Generic role titles (NOT scrubbed even if capitalized)
_GENERIC_TITLES = {
    "CEO", "COO", "CFO", "CIO", "CTO", "CMO", "CRO", "CISO", "CCO", "CDO",
    "VP", "SVP", "EVP", "Director", "Manager", "Lead", "Head", "Chief",
    "President", "Officer", "Champion", "Buyer", "Architect", "Engineer",
    "Administrator", "Specialist", "Solution Engineer", "Account Executive",
    "Industry Specialist", "Enterprise Architect", "Technical Architect",
    "Business Value Consultant", "Customer Success Manager",
}


def _load_whitelist():
    user_whitelist = _load_json(WHITELIST_PATH, [])
    if isinstance(user_whitelist, list):
        return _BUILTIN_WHITELIST | set(user_whitelist)
    return _BUILTIN_WHITELIST


def _load_tickers():
    data = _load_json(TICKERS_PATH, [])
    if isinstance(data, list):
        return set(data)
    return set()


# -----------------------------------------------------------------------------
# Scrub engine
# -----------------------------------------------------------------------------
def _apply_pattern(text, pattern, mapping, kind, hint_fn=None):
    """Replace every regex match with a placeholder. Idempotent via mapping."""
    def repl(match):
        real = match.group(0)
        hint = hint_fn(real, match) if hint_fn else None
        return _get_or_create(mapping, real, kind, hint)
    return pattern.sub(repl, text)


def _magnitude_hint(real, match):
    # Detect magnitude suffix to produce {{MONEY_USD_N_MIL}} etc.
    s = real.upper()
    if "B" in s:
        return "BIL"
    if "M" in s:
        return "MIL"
    if "K" in s:
        return "K"
    return None


def _revenue_hint(real, match):
    s = real.upper()
    for token in ("ARR", "MRR", "TCV", "ACV", "GMV"):
        if token in s:
            return token
    return None


def _phone_hint(real, match):
    if real.lstrip().startswith("+"):
        return None  # explicit country code; preserve as-is
    return "NA"


def _person_role_hint(text_around):
    m = _PERSON_ROLE_HINTS.search(text_around)
    return f"ROLE={m.group(0).split()[-1].upper()}" if m else None


def _is_known_ticker(token, tickers):
    return token.lstrip("$").upper() in tickers


def scrub(text, known_entities=None, map_path=None):
    """Anonymize text. Returns (anonymized_text, mapping_dict).

    Same entity gets the same placeholder across calls that share map_path.
    If map_path is None, the map is in-memory only and lost after this call.
    """
    if map_path is None:
        map_path = Path(DEFAULT_MAP_DIR) / DEFAULT_MAP_FILE
    map_path = Path(map_path)
    m = load_map(map_path)

    # Layer 0: _RAW_ collision sentinel -- swap pre-existing {{...}} tokens
    # already in the input for [[RAW_N]] sentinels so they survive restore()
    # without being rewritten into real entities. Without this, a user who
    # writes a literal {{COMPANY_1}} in their notes would have it silently
    # replaced with whatever COMPANY_1 maps to after a round-trip.
    raw_tokens = list(dict.fromkeys(re.findall(r"\{\{[A-Z][A-Z0-9_=]*\}\}", text)))
    for raw_tok in raw_tokens:
        if raw_tok in m["entries"]:
            sentinel = m["entries"][raw_tok]["placeholder"]
        else:
            n = m["next_index"].get("RAW", 0) + 1
            m["next_index"]["RAW"] = n
            sentinel = f"[[RAW_{n}]]"
            m["entries"][raw_tok] = {"placeholder": sentinel, "type": "RAW"}
        text = text.replace(raw_tok, sentinel)

    # Layer 1: caller-supplied entities (always wins)
    for ent in (known_entities or []):
        if not ent:
            continue
        # Kind detection -- check COMPANY markers FIRST; only fall through to
        # PERSON if no company marker is present.
        if any(marker in ent.split() for marker in _COMPANY_MARKERS):
            kind = "COMPANY"
        elif re.match(r"^[A-Z][a-z]+\s+[A-Z][a-z]+(?:\s+[A-Z][a-z]+)?$", ent):
            # First Last (Middle) -> probably a person
            kind = "PERSON"
        else:
            kind = "ENTITY"
        ph = _get_or_create(m, ent, kind)
        text = text.replace(ent, ph)

    # Layer 2: regex patterns -- order matters
    text = _apply_pattern(text, _RE_EMAIL, m, "EMAIL")
    text = _apply_pattern(text, _RE_LINKEDIN, m, "LINKEDIN")
    text = _apply_pattern(text, _RE_SLACK_URL, m, "URL")
    text = _apply_pattern(text, _RE_SF_ORG_ID, m, "ORG_ID")
    # Phones come before national IDs to avoid eating them, but the regex
    # patterns are tight enough that overlap is rare.
    text = _apply_pattern(text, _RE_PHONE_INTL, m, "PHONE")
    text = _apply_pattern(text, _RE_PHONE_NA, m, "PHONE", _phone_hint)
    text = _apply_pattern(text, _RE_SSN, m, "ID")
    text = _apply_pattern(text, _RE_EIN, m, "ID")
    text = _apply_pattern(text, _RE_AADHAAR, m, "ID")
    text = _apply_pattern(text, _RE_UK_NI, m, "ID")
    text = _apply_pattern(text, _RE_SIN, m, "ID")
    text = _apply_pattern(text, _RE_REVENUE_PHRASE, m, "REVENUE", _revenue_hint)
    text = _apply_pattern(text, _RE_MONEY_SUFFIX, m, "MONEY_USD", _magnitude_hint)
    text = _apply_pattern(text, _RE_MONEY_COMMA, m, "MONEY_USD", _magnitude_hint)
    text = _apply_pattern(text, _RE_CASE_ID, m, "CASE_ID")
    text = _apply_pattern(text, _RE_DATE_ISO, m, "DATE")
    text = _apply_pattern(text, _RE_DATE_WORD, m, "DATE")
    text = _apply_pattern(text, _RE_DATE_SLASH, m, "DATE")
    text = _apply_pattern(text, _RE_COORDS, m, "COORDS")

    # Headcount: only scrub if not a clean round-bucket; preserve the trailing
    # noun (employees / FTE / staff) so the placeholder reads naturally.
    def _headcount_repl(match):
        n_str = match.group(1)
        n = int(n_str.replace(",", ""))
        if n in (1, 25, 100, 250, 500, 1000, 2500, 5000, 10000, 25000, 50000, 100000):
            return match.group(0)
        # Determine the trailing noun used in the source
        full = match.group(0)
        noun = full[len(n_str):].lstrip()  # "employees" / "FTE" / etc.
        return _get_or_create(m, n_str, "HEADCOUNT") + " " + noun
    text = _RE_HEADCOUNT.sub(_headcount_repl, text)

    # Slack channels (custom prefix only)
    def _slack_chan_repl(match):
        name = match.group(1)
        if name.lower() in _DEFAULT_CHANNELS:
            return match.group(0)
        return _get_or_create(m, match.group(0), "SLACK_CHANNEL")
    text = _RE_SLACK_CHAN.sub(_slack_chan_repl, text)

    # Generic URL: scrub if host not whitelisted
    PUBLIC_HOSTS = {
        "salesforce.com", "trailhead.salesforce.com", "help.salesforce.com",
        "architect.salesforce.com", "developer.salesforce.com",
        "salesforce.stackexchange.com", "google.com", "bing.com",
        "duckduckgo.com", "scholar.google.com", "crunchbase.com",
        "linkedin.com", "github.com", "wikipedia.org", "youtube.com",
    }
    def _url_repl(match):
        url = match.group(0)
        host_match = re.match(r"https?://([^/\s)]+)", url, re.IGNORECASE)
        host = host_match.group(1).lower() if host_match else ""
        # Strip www. for comparison
        host = host[4:] if host.startswith("www.") else host
        # Allow if host (or any parent domain) is in PUBLIC_HOSTS
        for ph in PUBLIC_HOSTS:
            if host == ph or host.endswith("." + ph):
                return url
        return _get_or_create(m, url, "URL")
    text = _RE_URL.sub(_url_repl, text)

    # Bare domain (no scheme): aggressive-by-default doctrine -- a bare
    # acme-credit-union.com is exactly the kind of identifier the URL
    # regex misses but a leak doctrine still wants scrubbed.
    def _bare_domain_repl(match):
        host = match.group(0).lower()
        host_no_www = host[4:] if host.startswith("www.") else host
        for ph in PUBLIC_HOSTS:
            if host_no_www == ph or host_no_www.endswith("." + ph):
                return match.group(0)
        return _get_or_create(m, match.group(0), "DOMAIN")
    text = _RE_BARE_DOMAIN.sub(_bare_domain_repl, text)

    # Stock tickers (filtered by tickers.json)
    tickers = _load_tickers()
    def _ticker_repl(match):
        tok = match.group(0)
        if _is_known_ticker(tok, tickers):
            return _get_or_create(m, tok, "TICKER")
        return tok
    text = _RE_TICKER.sub(_ticker_repl, text)

    # Layer 3: heuristic proper-noun detection (capitalized multi-word phrases)
    whitelist = _load_whitelist()
    # Determiners / pronouns that frequently sit at sentence start before a
    # real entity. They look capitalized to the regex but are not part of
    # the entity itself ("Their CISO Jane Roe" -> entity is "Jane Roe").
    _LEADING_DETERMINERS = {
        "The", "Their", "Our", "His", "Her", "Its", "My", "Your", "A", "An",
        "This", "That", "These", "Those",
    }
    # Common two-word "Type Identifier" phrases that capitalize but aren't
    # entities ("Account ID", "Case Number", "Order Reference"...).
    _GENERIC_TWO_WORD = {
        "Account ID", "Account Number", "Account Name", "Account Owner",
        "Case ID", "Case Number", "Order ID", "Order Number",
        "Opportunity ID", "Opportunity Name", "Record ID", "Object Name",
        "Profile Name", "Role Name", "Field Name", "Tab Name",
        "User ID", "User Name", "Group Name",
    }

    def _proper_noun_repl(match):
        phrase = match.group(0)
        # Skip if already scrubbed (it'd contain {{ or [[ )
        if "{{" in phrase or "}}" in phrase or "[[" in phrase:
            return phrase
        # Skip whitelist + generic titles + generic two-word phrases.
        if phrase in whitelist or phrase in _GENERIC_TITLES or phrase in _GENERIC_TWO_WORD:
            return phrase
        words = phrase.split()

        # Strip a leading determiner ("Their CISO Jane Roe" -> "CISO Jane Roe").
        leading = ""
        if words and words[0] in _LEADING_DETERMINERS:
            leading = words[0] + " "
            words = words[1:]
        if not words:
            return phrase

        # Role-hint extraction: if a generic title sits at words[0] and is
        # followed by 1-2 First[ Last] tokens, scrub ONLY the person name
        # with a ROLE= hint and return the title + leading determiner verbatim.
        if (words[0] in _GENERIC_TITLES and len(words) >= 2 and
                all(re.match(r"^[A-Z][a-z]+$", w) for w in words[1:3])):
            person_words = words[1:3] if len(words) >= 3 and re.match(r"^[A-Z][a-z]+$", words[2]) else words[1:2]
            if len(person_words) >= 1:
                person_phrase = " ".join(person_words)
                # Skip if a single common name -- avoid scrubbing greetings
                if len(person_phrase.split()) == 1 and person_phrase in _GENERIC_TITLES:
                    return phrase
                ph = _get_or_create(m, person_phrase, "PERSON", f"ROLE={words[0].upper()}")
                tail = " ".join(words[1 + len(person_words):])
                return f"{leading}{words[0]} {ph}{(' ' + tail) if tail else ''}"

        cap_words = [w for w in words if w and w[0].isupper()]
        if len(cap_words) < 2:
            return phrase
        # Determine kind. _COMPANY_MARKERS contains both single tokens ("Inc")
        # and multi-word markers ("Credit Union"), so substring-match the
        # joined phrase rather than per-word membership.
        joined = " ".join(words)
        kind = "ENTITY"
        if any(marker in joined for marker in _COMPANY_MARKERS):
            kind = "COMPANY"
        # Person heuristic: First Last with optional title
        if (words[0] in _PERSON_TITLES or
            (len(words) == 2 and all(re.match(r"^[A-Z][a-z]+$", w) for w in words))):
            kind = "PERSON"
        return f"{leading}{_get_or_create(m, joined, kind)}"
    text = _RE_PROPER_NOUN.sub(_proper_noun_repl, text)

    save_map(map_path, m)
    new_entries = {k: v for k, v in m["entries"].items() if v}
    return text, new_entries


# -----------------------------------------------------------------------------
# Restore engine
# -----------------------------------------------------------------------------
def restore(text, map_path=None):
    """Restore placeholders to real values. Returns (restored_text, unknown_placeholders).

    Unknown placeholders (e.g. ones the LLM invented) are left as-is.
    """
    if map_path is None:
        map_path = Path(DEFAULT_MAP_DIR) / DEFAULT_MAP_FILE
    m = load_map(map_path)
    reverse = {v["placeholder"]: k for k, v in m["entries"].items()}

    # Find every {{...}} in the text
    found = set(re.findall(r"\{\{[A-Z][A-Z0-9_=]*\}\}", text))
    # RAW sentinels use [[RAW_N]] -- exclude them from the unknown check,
    # since they don't have {{...}} shape.
    normal = {ph: real for ph, real in reverse.items() if not ph.startswith("[[")}
    raw = {ph: real for ph, real in reverse.items() if ph.startswith("[[")}
    unknown = found - set(normal.keys())

    # Substitute normal placeholders first, longest-first so {{COMPANY_10}}
    # isn't shadowed by {{COMPANY_1}}.
    for ph in sorted(normal.keys(), key=len, reverse=True):
        text = text.replace(ph, normal[ph])
    # RAW sentinels restore LAST so the literal {{X}} they produce doesn't
    # re-trigger a normal placeholder substitution above.
    for ph in sorted(raw.keys(), key=len, reverse=True):
        text = text.replace(ph, raw[ph])

    return text, sorted(unknown)


# -----------------------------------------------------------------------------
# CLI
# -----------------------------------------------------------------------------
def _read_input(args):
    if args.input == "-" or (not args.input and not sys.stdin.isatty()):
        return sys.stdin.read()
    if args.input:
        return Path(args.input).read_text(encoding="utf-8")
    return None


def _summarize(mapping):
    """One-line stderr summary by type."""
    counts = {}
    for _, info in mapping.items():
        counts[info["type"]] = counts.get(info["type"], 0) + 1
    if not counts:
        return "anonymize: scrubbed 0 entities"
    parts = ", ".join(f"{n} {k}" for k, n in sorted(counts.items(), key=lambda x: -x[1]))
    total = sum(counts.values())
    return f"anonymize: scrubbed {total} entities -- {parts}"


def cmd_scrub(args):
    text = _read_input(args)
    if text is None:
        sys.exit("error: no input. Pass --input <file>, '-' for stdin, or pipe.")
    map_path = Path(args.map) if args.map else (Path(DEFAULT_MAP_DIR) / DEFAULT_MAP_FILE)
    known = list(args.scrub or [])
    scrubbed, mapping = scrub(text, known_entities=known, map_path=map_path)
    if args.output:
        Path(args.output).write_text(scrubbed, encoding="utf-8")
    else:
        sys.stdout.write(scrubbed)
    sys.stderr.write(_summarize(mapping) + "\n")
    return 0


def cmd_restore(args):
    text = _read_input(args)
    if text is None:
        sys.exit("error: no input. Pass --input <file>, '-' for stdin, or pipe.")
    map_path = Path(args.map) if args.map else (Path(DEFAULT_MAP_DIR) / DEFAULT_MAP_FILE)
    restored, unknown = restore(text, map_path=map_path)
    if args.output:
        Path(args.output).write_text(restored, encoding="utf-8")
    else:
        sys.stdout.write(restored)
    if unknown:
        sys.stderr.write(
            f"anonymize: {len(unknown)} unknown placeholder(s) left in place "
            f"(LLM may have invented them): {', '.join(unknown[:10])}"
            f"{'...' if len(unknown) > 10 else ''}\n"
        )
    return 0


def cmd_inspect(args):
    map_path = Path(args.map) if args.map else (Path(DEFAULT_MAP_DIR) / DEFAULT_MAP_FILE)
    if not map_path.exists():
        print(f"No map at {map_path} -- nothing scrubbed yet in this workspace.")
        return 0
    m = load_map(map_path)
    print(f"Map: {map_path}")
    print(f"Entries: {len(m['entries'])}")
    print()
    print(f"{'Placeholder':<35} {'Type':<14} Real value")
    print("-" * 80)
    for real, info in sorted(m["entries"].items(), key=lambda x: x[1]["placeholder"]):
        display = real if len(real) <= 30 else real[:27] + "..."
        print(f"{info['placeholder']:<35} {info['type']:<14} {display}")
    return 0


def cmd_reset(args):
    map_path = Path(args.map) if args.map else (Path(DEFAULT_MAP_DIR) / DEFAULT_MAP_FILE)
    if map_path.exists():
        map_path.unlink()
        print(f"Removed {map_path}")
    else:
        print(f"No map at {map_path} -- already clean.")
    return 0


def main(argv=None):
    ap = argparse.ArgumentParser(
        prog="anonymize.py",
        description="Bidirectional placeholder anonymization for LLM-bound text.",
    )
    sub = ap.add_subparsers(dest="cmd", required=True)

    p_scrub = sub.add_parser("scrub", help="Scrub text -> anonymized text + map")
    p_scrub.add_argument("--input", help="Input file ('-' for stdin)")
    p_scrub.add_argument("--output", help="Output file (default: stdout)")
    p_scrub.add_argument("--map", help="Map path (default: .anonymize/map.json)")
    p_scrub.add_argument("--scrub", action="append",
                         help="Known entity to scrub (repeatable; always wins)")
    p_scrub.set_defaults(func=cmd_scrub)

    p_restore = sub.add_parser("restore", help="Restore placeholders -> real values")
    p_restore.add_argument("--input", help="Input file ('-' for stdin)")
    p_restore.add_argument("--output", help="Output file (default: stdout)")
    p_restore.add_argument("--map", help="Map path (default: .anonymize/map.json)")
    p_restore.set_defaults(func=cmd_restore)

    p_inspect = sub.add_parser("inspect", help="Show entries in the local map")
    p_inspect.add_argument("--map", help="Map path (default: .anonymize/map.json)")
    p_inspect.set_defaults(func=cmd_inspect)

    p_reset = sub.add_parser("reset", help="Delete the local map (start fresh)")
    p_reset.add_argument("--map", help="Map path (default: .anonymize/map.json)")
    p_reset.set_defaults(func=cmd_reset)

    args = ap.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(130)
