---
name: anonymize
description: >-
  Scrub customer names, PII, financial figures, and other identifying data
  out of text before it reaches an external LLM, using bidirectional
  placeholders ({{COMPANY_1}}, {{PERSON_2_ROLE=CISO}}, {{ARR_USD_3}}) so the
  LLM can still reason precisely without ever seeing the real values. On the
  way back, restore the placeholders to the real values so the user sees a
  normal-reading report. Use whenever the user is preparing a prompt for
  /cross-ai-review, /focus-group, or any external LLM call AND the prompt
  contains customer-identifying data, personnel profiles, sf / Slack data,
  financial figures, or anything that could become legally toxic if leaked.
  Designed as a library that other skills call automatically — also usable
  standalone via /anonymize <paste> to sanitize ad-hoc text before pasting it
  somewhere else. Aggressive-by-default: when in doubt, scrub. The local map
  never leaves the laptop.
---

# /anonymize — Bidirectional placeholder anonymization

`/anonymize` makes it safe to send customer-grounded prompts to external
LLMs without leaking identifying data, while keeping the prompt **precise**
enough that the LLM can reason coherently and the user can still read the
final report in normal language.

## The trick: bidirectional placeholders

Instead of redacting `Providence Health` to `[REDACTED]`, the skill
substitutes a **typed, indexed placeholder**: `{{COMPANY_1}}`. The LLM sees
the placeholder, can reason about it ("the {{COMPANY_1}} would push back
on..."), and never sees the real name. After the LLM responds, the skill
substitutes the real names back in. The user reads a normal report; the
LLM never saw identifiable data.

```
raw text → scrub → anonymized text + map.json (local) → LLM
                                                            ↓
final report (real names) ← restore ← LLM response with placeholders
```

The map.json is git-ignored, lives at `.anonymize/map.json` in the workspace,
and **never leaves the laptop**.

## When to invoke it

- **As a library, called by other skills automatically.** `/focus-group`,
  `/slackbot`, and `/cross-ai-review` import `anonymize.py` and call it on
  every outbound prompt that contains customer-grounded data. The user
  doesn't have to think about it.
- **As a standalone slash command.** `/anonymize <paste-or-file>` returns
  the sanitized text on stdout and updates the local map. Useful for
  ad-hoc work: sanitize a paragraph before pasting it into a chat with a
  third-party model, or before sharing a snippet with someone over Slack.
- **Restore mode.** `/anonymize restore <text>` substitutes placeholders
  back to real values using the local map.

## Three modes the skill answers in

### Help mode
If the user invokes `/anonymize help` / `--help` / `-h` / `?`, do NOT scrub
anything — print this walkthrough and stop.

### Scrub mode (default)
`/anonymize <paste-or-file-or-stdin>` → sanitized text on stdout.
- Same entity gets the same placeholder across the session (consistency).
- New entities get the next index of their type.
- Mapping appended to `.anonymize/map.json`.

### Restore mode
`/anonymize restore <text-or-file>` → de-anonymized text on stdout.
- Unknown placeholders (which a model may have invented) are left as-is and
  flagged in stderr.

## What gets scrubbed

The default posture is **aggressive — when in doubt, scrub.** The
[`references/scrub-patterns.md`](references/scrub-patterns.md) document is the
canonical reference. Headline coverage:

| Category | Examples | Placeholder type |
|----------|----------|------------------|
| **Person names** | `Sarah Chen`, `Dr. Patel` | `{{PERSON_N}}` or `{{PERSON_N_ROLE=CISO}}` when role is known |
| **Email addresses** | `s.chen@acmebank.com` | `{{EMAIL_N}}` |
| **Phone numbers** | `+1 555-555-1234`, `(555) 555-1234`, `+44 20 7946 0958` | `{{PHONE_N}}` |
| **Physical addresses** | `1700 Owens St, San Francisco, CA 94158` | `{{ADDRESS_N}}` |
| **Company names** | `Providence Health`, `Acme Credit Union` | `{{COMPANY_N}}` |
| **Product codenames** | `Project Helios`, `Falcon-2 release` | `{{CODENAME_N}}` |
| **Salesforce org IDs / sandbox aliases** | `00D5g0000XYZAbc`, `acme-uat-sb` | `{{ORG_ID_N}}` / `{{ORG_ALIAS_N}}` |
| **Slack channel names with custom prefix** | `#acme-deal-room`, `#providence-cs` | `{{SLACK_CHANNEL_N}}` |
| **Internal URLs** | `acme.atlassian.net/wiki/...`, `acme-sales.slack.com/...` | `{{URL_N}}` |
| **LinkedIn URLs** | `linkedin.com/in/sarah-chen-12345` | `{{LINKEDIN_N}}` |
| **Stock tickers** | `CRM`, `MSFT`, `$ACME` | `{{TICKER_N}}` |
| **Money amounts (≥ 4 digits)** | `$4,200,000`, `4.2M ARR`, `$1.5B TCV` | `{{MONEY_USD_N}}` with magnitude hint |
| **ARR/MRR/TCV phrasing with amounts** | `ARR of $X`, `$X MRR` | `{{ARR_USD_N}}`, `{{MRR_USD_N}}`, `{{TCV_USD_N}}` |
| **Precise employee counts** | `4,237 employees` | `{{HEADCOUNT_N}}` (round-bucket ranges like `2,500-25,000` are NOT scrubbed) |
| **Specific dates ≤ 5 years old** | `2024-03-15`, `March 15, 2024` | `{{DATE_N}}` (year-only like `since 2022` NOT scrubbed) |
| **Regulatory case numbers** | `OCC EA-2024-018`, `FTC C-4762` | `{{CASE_ID_N}}` |
| **Government / national IDs** | `SSN`, `SIN`, `NHS number`, `EIN`, `Aadhaar`, etc. | `{{ID_N}}` |
| **Coordinates** | GPS lat/long, what3words | `{{COORDS_N}}` |

**Not scrubbed** (intentional, per the "precise grounding" goal):
- Industry name and Salesforce Industry Cloud names (too generic to be identifying; load-bearing for grounding).
- Round-bucket size ranges (`2,500–25,000 employees` is preserved; `4,237` is not).
- Year-only references (`since 2022`).
- Salesforce product names and standard cloud names.
- Generic geography (`Pacific Northwest`, `EMEA`).
- Standard role titles without person attached (`a CIO`, `the Champion`).

## Detection layers (in order of reliability)

1. **Caller-supplied list (most reliable).** When a calling skill knows
   what to scrub (it just queried `sf` for the Account record, etc.), it
   passes those entities as `--scrub <value>` (repeatable). They always get
   scrubbed, regardless of what regex would have said.
2. **Pattern matching.** Regex covers emails, phones, URLs, money amounts,
   stock tickers, ID formats, dates. See
   [`references/scrub-patterns.md`](references/scrub-patterns.md).
3. **Heuristic proper-noun detection.** Capitalized multi-word tokens not in
   the whitelist (Salesforce product names, generic role titles, country
   names, common Cloud / Service / Marketing words) — flagged as possible
   company / person / codename and scrubbed by default.

The skill prints a one-line summary of what it scrubbed (counts by type)
so the caller knows what happened.

## CLI shape (for callers and standalone use)

```sh
# Scrub a file in place (output to stdout)
python <skill>/scripts/anonymize.py scrub --input plan.md > plan.scrubbed.md

# Scrub stdin
echo "Sarah Chen at Providence Health asked about $4.2M ARR" \
  | python <skill>/scripts/anonymize.py scrub

# Scrub with caller-supplied known entities (always wins)
python <skill>/scripts/anonymize.py scrub --input prompt.md \
  --scrub "Providence Health" --scrub "Sarah Chen" --scrub "00D5g0000XYZAbc"

# Restore an LLM response
python <skill>/scripts/anonymize.py restore --input llm-response.md

# Show what's in the local map
python <skill>/scripts/anonymize.py inspect

# Clear the local map (start fresh for a new customer)
python <skill>/scripts/anonymize.py reset
```

Default map path: `.anonymize/map.json` in the working directory.
Override with `--map <path>`. The map file is JSON; safe to read or back up.

## Library use (for other skills)

```python
from anonymize import scrub, restore, load_map

text, mapping = scrub(text="...", known_entities=["Providence Health"])
# text now contains {{COMPANY_1}} etc.; mapping is the new entries added.
# The map is also persisted to .anonymize/map.json.

# Send `text` to the LLM. When the response comes back:
final = restore(response_text)
```

The library is **pure-Python, no external dependencies**.

## Runtime chain — works on Windows, macOS, and Linux

The skill ships with **four runtime ports** so it works wherever the user
is. The detection scripts (`scripts/detect-runtime.sh` for POSIX,
`scripts/detect-runtime.ps1` for Windows native) pick the best available
path automatically.

| Runtime | Script | Feature set | Typical hosts |
|---------|--------|-------------|---------------|
| **Python 3** (preferred) | `scripts/anonymize.py` | Full — L1 + L2 regex + L3 heuristic proper-noun detection | macOS / Linux (usually pre-installed); Windows when installed |
| **Node.js** | `scripts/anonymize.mjs` | Full — feature parity with the Python version | Any host with `node` on PATH (often already there for Claude Code users) |
| **Windows PowerShell** | `scripts/anonymize.ps1` | **DEGRADED** — L1 + L2 regex only (no L3) | Windows 11 native (PowerShell pre-installed) |
| **POSIX shell** (`sh` + `sed` + `awk`) | `scripts/anonymize.sh` | **DEGRADED** — L1 + L2 regex only (no L3); placeholders not per-entity-indexed | macOS / Linux locked-down corporate laptops; Windows via Git Bash / WSL |

**Why two of them are DEGRADED:** the Layer 3 heuristic proper-noun
detector (the part that catches `Sarah Chen` without you having to name
her in `--scrub`) needs real regex back-references and a whitelist
lookup. Doable in PowerShell but ~350 lines; not realistic in pure
sed/awk. In DEGRADED mode the skill still catches regex-detectable PII
(emails, phones, URLs, money, SSNs, etc.) and explicit caller-supplied
entities — but **the caller must pass `--scrub <name>` for every person
or org name** that isn't caught by regex. The skill's caller (typically
`/focus-group` or `/slackbot`) does this when it has the names from
`sf` or Slack data; for ad-hoc standalone use, the user has to pass them.

**Cross-runtime compatibility:** the `map.json` format is identical
across Python, Node, and PowerShell. If a user starts on the
PowerShell path and later installs Python, their existing map keeps
working — restore from Python reads PowerShell scrubs cleanly.

### When NO runtime is available

If `detect-runtime.sh` / `detect-runtime.ps1` returns `none`, the skill
**must not silently proceed**. The calling skill (`/focus-group`,
`/slackbot`, etc.) MUST surface the universal install offer:

> *I can't anonymize without one of: Python 3, Node.js, or PowerShell
> (Windows). Without anonymization, I won't send identifiable customer
> data to external LLMs. Want to install Python (about 3 minutes)? Walk
> me through it. Else, skip the customer-grounded portion and run a
> generic panel.*

The four-option menu pattern from
[`../focus-group/references/usage.md`](../focus-group/references/usage.md)
§8 applies:
- (a) walk me through installing Python now
- (b) walk me through Node.js
- (c) skip the grounded panel; run generic instead
- (d) don't ask me about this again (and turn off install-prompts)

### Picking the runtime in calling code

```sh
# POSIX path (macOS / Linux / Git Bash / WSL)
RUNTIME=$(sh .claude/skills/anonymize/scripts/detect-runtime.sh)
case "$RUNTIME" in
  python)     python .claude/skills/anonymize/scripts/anonymize.py "$@" ;;
  node)       node   .claude/skills/anonymize/scripts/anonymize.mjs "$@" ;;
  shell)      sh     .claude/skills/anonymize/scripts/anonymize.sh "$@" ;;
  none)       echo "no runtime — install offer goes here"; exit 1 ;;
esac
```

```powershell
# Windows native
$runtime = & .claude/skills/anonymize/scripts/detect-runtime.ps1
switch ($runtime) {
  'python'     { python .claude/skills/anonymize/scripts/anonymize.py @args }
  'node'       { node   .claude/skills/anonymize/scripts/anonymize.mjs @args }
  'powershell' { & .claude/skills/anonymize/scripts/anonymize.ps1 @args }
  'shell'      { sh .claude/skills/anonymize/scripts/anonymize.sh @args }
  'none'       { Write-Error "no runtime — install offer goes here" }
}
```

## Safety rules

1. **The map never leaves the laptop.** It is git-ignored. The skill never
   POSTs it anywhere. Backups, if any, are the user's responsibility.
2. **Restore is local-only.** Restoration runs on the LLM's response *after*
   it returns to the user's machine. The LLM only ever sees placeholders.
3. **If `--no-anonymize` is passed by a caller**, the skill MUST surface a
   one-line warning to the user (*"You're about to send identifiable
   customer data to N external LLMs"*) and proceed only if the caller
   confirms in the user-visible flow.
4. **No telemetry.** The skill does not phone home in any form.

## Errors

Apply the err-doctrine in
[`../focus-group/references/err-doctrine.md`](../focus-group/references/err-doctrine.md):
one plain-English cause sentence, what was done without the failing piece,
one or two next steps, then *"If you'd like, paste the screen you see and
I'll translate it."*

## References

- [`references/scrub-patterns.md`](references/scrub-patterns.md) — the full
  detection-pattern catalogue (regexes, heuristics, whitelist).
