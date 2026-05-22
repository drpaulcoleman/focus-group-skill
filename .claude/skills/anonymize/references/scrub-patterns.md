# Scrub Patterns — What the Detector Catches

Canonical reference for the `/anonymize` skill's detection rules. The
posture is **aggressive — when in doubt, scrub.** The cost of a missed
scrub (real customer data reaching an external LLM) is far higher than the
cost of an over-scrub (an extra placeholder in the prompt).

## Layer 1 — Caller-supplied entities (always wins)

When a calling skill knows what to scrub, it passes the values via
`--scrub <value>` (repeatable on the CLI; or `known_entities=[...]` as a
library argument). These are scrubbed first, regardless of pattern. Use
this for known customer org names, named champions, sandbox org aliases,
etc. that the caller learned from `sf` or Slack.

## Layer 2 — Regex pattern matching

### Email addresses

```
\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b
```

Placeholder: `{{EMAIL_N}}`.

### Phone numbers

International formats:
```
\+\d{1,3}[\s.-]?\(?\d{1,4}\)?[\s.-]?\d{1,4}[\s.-]?\d{1,9}
```

North American 10-digit:
```
\(?\b\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\b
```

Placeholder: `{{PHONE_N}}`.

### Salesforce org IDs (15- and 18-character)

```
\b00[A-Za-z0-9]{13}([A-Za-z]{3})?\b
```

(Starts with `00`; 15 alphanumeric or 18 with a 3-char checksum suffix.)
Placeholder: `{{ORG_ID_N}}`.

### LinkedIn URLs

```
https?://(?:www\.)?linkedin\.com/(?:in|company|pub)/[A-Za-z0-9_\-/]+
```

Placeholder: `{{LINKEDIN_N}}`. The detection also triggers the LinkedIn
workaround prompt in `/focus-group` ("LinkedIn aggressively blocks
scrapers — instead, prepare a local folder of profile files…").

### Slack channel names with custom (non-default) prefixes

Default Slack channels (`#general`, `#random`, `#announcements`) are NOT
scrubbed. Custom-prefixed channels are:

```
#(?!general|random|announcements|help)[a-z0-9][a-z0-9_-]{2,}
```

Placeholder: `{{SLACK_CHANNEL_N}}`.

### Slack workspace URLs

```
https?://[a-z0-9-]+\.slack\.com(?:/[^\s]*)?
```

Placeholder: `{{URL_N}}`.

### Internal URLs (Atlassian, Notion, Coda, custom domains)

A URL whose host is not in the public-info whitelist
(`salesforce.com`, `trailhead.salesforce.com`, `help.salesforce.com`,
`architect.salesforce.com`, `developer.salesforce.com`,
`google.com`, `bing.com`, `duckduckgo.com`, `scholar.google.com`,
`crunchbase.com`, `linkedin.com`, `github.com`, `wikipedia.org`,
plus the user's optionally-configured whitelist) → scrubbed as
`{{URL_N}}`.

### Money amounts (≥ 4 digits)

USD-style with comma thousands separators:
```
\$[\d,]{4,}(?:\.\d+)?(?:\s?[KMB])?
```

USD/EUR/GBP with magnitude suffix:
```
\$\d+(?:\.\d+)?\s?[KMB](?:i?l)?(?:lion)?\b
```

Bare-magnitude phrases tied to revenue keywords:
```
\b\d+(?:\.\d+)?\s?[KMB]\s?(?:ARR|MRR|TCV|ACV|GMV|revenue|in revenue)\b
```

Placeholder: `{{MONEY_USD_N}}` (with magnitude hint when known, e.g.,
`{{MONEY_USD_3_MIL}}`, `{{MONEY_USD_4_BIL}}`). When the surrounding text
is clearly ARR/MRR/TCV phrasing, the placeholder uses that prefix:
`{{ARR_USD_N}}`, `{{MRR_USD_N}}`, `{{TCV_USD_N}}`, `{{ACV_USD_N}}`.

### Stock tickers

```
\b\$?[A-Z]{1,5}\b
```

This pattern over-matches by design. The detector consults a whitelist of
~5,000 known public tickers (NYSE + NASDAQ + LSE + TSX) and only scrubs a
match if it's a known ticker. The list ships as a small JSON file in
`scripts/tickers.json`.

Placeholder: `{{TICKER_N}}`.

### Government / national ID numbers

US SSN: `\b\d{3}-\d{2}-\d{4}\b`
Canadian SIN: `\b\d{3}[\s-]?\d{3}[\s-]?\d{3}\b`
UK NI / National Insurance: `\b[A-Z]{2}\d{6}[A-Z]\b`
US EIN: `\b\d{2}-\d{7}\b`
NHS number: `\b\d{3}\s?\d{3}\s?\d{4}\b`
Aadhaar (India): `\b\d{4}\s?\d{4}\s?\d{4}\b`

Placeholder: `{{ID_N}}`. The phone-number pattern overlaps some of these;
ID patterns win when contextual keywords (`SSN`, `SIN`, `NHS`, `EIN`,
etc.) appear within 30 characters.

### Regulatory case numbers

Generic format:
```
\b(?:OCC|FTC|SEC|EEOC|DOL|HHS|CFPB|FDIC|CMS)\s?(?:[A-Z]+-)?\d{2,4}-\d+\b
```

Placeholder: `{{CASE_ID_N}}`.

### Specific dates within the last 5 years

```
\b(?:19|20)\d{2}-(?:0\d|1[012])-(?:0\d|[12]\d|3[01])\b      # 2024-03-15
\b(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s\d{1,2},?\s(?:19|20)\d{2}\b  # March 15, 2024
\b\d{1,2}/\d{1,2}/(?:19|20)\d{2}\b                          # 3/15/2024
```

Filter: only scrub if the year falls within the last 5 calendar years.
Placeholder: `{{DATE_N}}`.

Year-only references (`since 2022`, `the 2024 release`) are NOT scrubbed.

### Precise employee counts

```
\b\d{3,}(?:,\d{3})*\s?(?:employees|FTEs|staff)\b
```

Filter: scrub only if the number has ≥ 3 digits AND is not a clean
round-bucket like `2,500`, `10,000`, `25,000`. A range like `2,500-25,000`
is NOT scrubbed (it's the wizard's standard bucket format).

Placeholder: `{{HEADCOUNT_N}}`.

### Coordinates and addresses

GPS lat/long: `\b-?\d{1,3}\.\d{4,},\s*-?\d{1,3}\.\d{4,}\b`
what3words: `\b///[a-z]+\.[a-z]+\.[a-z]+\b`
US/CA street address (heuristic): a number + words + a state abbreviation
+ ZIP/postal code, all within 60 chars. Less reliable; rely on caller
list for known addresses.

Placeholders: `{{COORDS_N}}`, `{{ADDRESS_N}}`.

## Layer 3 — Heuristic proper-noun detection

For tokens that aren't caught by Layer 1 or 2, the detector applies
heuristics. **All heuristic matches default to scrub**, per the
"in-doubt-scrub" posture.

### Capitalized multi-word proper-noun phrases

A run of 2–5 consecutive capitalized words (allowing internal
lowercase function words like `of`, `the`, `and`) that:
- starts with a capital letter,
- is not in the whitelist (see below),
- is not at sentence start being scrubbed (sentence-start capitalization
  is filtered out by checking if the same phrase appears in lowercase
  later in the text).

Placeholder: `{{COMPANY_N}}` if the surrounding context suggests an
organization (`Inc`, `LLC`, `Ltd`, `Corp`, `Hospital`, `Bank`, `Health`,
`Systems`, `Group`, `University`, `College`, `Foundation`, `Authority`,
`District`); otherwise `{{ENTITY_N}}`.

### Person-name heuristic

A capitalized word followed by another capitalized word, preceded by
a title (`Mr.`, `Ms.`, `Mrs.`, `Dr.`, `Prof.`, `Sen.`, `Rep.`) OR
followed by a comma + role phrase (`, CEO`, `, the head of`, `, our
champion`, etc.):

Placeholder: `{{PERSON_N}}` (with `_ROLE=<role>` hint when the role is
detected: `{{PERSON_N_ROLE=CISO}}`).

### Product / project codenames

Single capitalized word adjacent to project-marker words (`Project`,
`Initiative`, `Program`, `Phase`, `Codename`, `Release`):

```
\b(?:Project|Initiative|Program|Phase|Codename|Release)\s+[A-Z][A-Za-z0-9-]+\b
```

Placeholder: `{{CODENAME_N}}`.

### Sandbox / org aliases

Hyphenated lowercase identifiers tied to org keywords (`org`,
`sandbox`, `scratch`, `dev hub`):

```
\b[a-z][a-z0-9-]{3,}\s?(?:org|sandbox|sb|scratch|dev[\s-]?hub)\b
```

Placeholder: `{{ORG_ALIAS_N}}`.

## Whitelist (NOT scrubbed)

The detector consults a whitelist before scrubbing heuristically. The
whitelist ships in `scripts/whitelist.json` and includes:

- **Salesforce product names:** Salesforce, Sales Cloud, Service Cloud,
  Marketing Cloud, Commerce Cloud, Data Cloud, Experience Cloud, Field
  Service, Revenue Cloud, Agentforce, Einstein, Trust Layer, Hyperforce,
  Atlas, Tableau, MuleSoft, Slack, Anypoint Platform, Heroku, Apex, LWC,
  Lightning, Flow, Visualforce, Pardot, Tableau Pulse, Trailhead.
- **Salesforce Industry Clouds:** Automotive Cloud, Communications Cloud,
  Consumer Goods Cloud, Education Cloud, Energy & Utilities Cloud,
  Financial Services Cloud, Health Cloud, Life Sciences Cloud,
  Manufacturing Cloud, Media Cloud, Nonprofit Cloud, Public Sector
  Solutions.
- **Generic role titles:** CEO, COO, CFO, CIO, CTO, CMO, CRO, CISO,
  Champion, Economic Buyer, Solution Engineer, Account Executive, etc.
- **Common public companies in the Salesforce ecosystem** (named in
  illustrative examples in the persona files): Microsoft, Dynamics,
  HubSpot, ServiceNow, AWS, GCP, Azure, Oracle, SAP, Workday.
- **Major cloud regions:** AWS regions, GCP regions, Azure regions.
- **Industry-vertical vocabulary that isn't customer-identifying** (e.g.,
  `Epic`, `Cerner`, `MyChart`, `EHR`, `EMR` — generic-vocabulary in
  healthcare).
- **Country and major-city names.**

The user can extend the whitelist by editing `scripts/whitelist.json` —
useful when working with a specific public-ecosystem company that the
default list missed.

## What the scrubber emits

After a scrub call, the script writes:

- **Modified text** to stdout (or the path given to `--output`).
- **A one-line summary to stderr**:
  `anonymize: scrubbed 14 entities — 3 COMPANY, 2 PERSON, 4 MONEY, 2 EMAIL,
  1 PHONE, 1 LINKEDIN, 1 SLACK_CHANNEL`
- **The updated map** to `.anonymize/map.json` (or `--map` path), with the
  full reverse map for restore.

## Failure modes and how the scrubber handles them

- **A scrubbed value reappears in different forms** (`Providence Health` vs
  `Providence`). The scrubber treats them as separate entities (different
  placeholder indices); the maintainer can collapse them later by editing
  the map and re-scrubbing.
- **A placeholder collides with real text in the input** (someone wrote
  literal `{{COMPANY_1}}` in their notes). The scrubber detects the
  collision and prefixes the conflict with `_RAW_` to disambiguate.
- **Restore sees a placeholder not in the map** (LLM invented one). Restore
  leaves it as-is and prints a stderr note.
