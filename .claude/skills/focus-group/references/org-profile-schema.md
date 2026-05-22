# Org Profile Schema — Customer-Grounding Gate, Wizard, and Internal-Data Consent

The customer profile is the **single biggest lever** for making panel
feedback land. A `/focus-group` review of "should I lead with Service Cloud or
Agentforce?" produces wildly different — and much better — output when the
panel knows whether the customer is a 10-person nonprofit or Bank of
America. This file specifies the gate, the wizard, the internal-data
consent flow, and the JSON file that persists the result per workspace.

## Step 0 — Customer-grounding gate

The gate runs at `/focus-group` Step 3 — **before topic research, before
persona composition**. The skill scans the user's prompt for:

- a **named** customer organization (e.g., "Providence Health", "Acme Credit Union"), OR
- explicit **cultural / scale signals** ("our 20-person nonprofit", "this Fortune 500 bank's risk-averse culture").

If **neither** is present and no `.org-profile.json` is on file (or it is
> 14 days old), stop and ask. Two questions back-to-back.

### Q1 — How to profile

```
Before I research and convene the panel — who's the org we're talking
about? Even a rough profile makes the feedback land much better.

1. Profile by name — I'll name the actual org.
2. Profile by culture & size — I'd rather describe the org in general terms.
3. Skip — generic feedback is fine.
```

### Q2 — Relationship (asked only if Q1 = 1 or 2)

```
And — is this a current Salesforce customer of yours, or a prospect / lead?
This changes what tools I can use to research them.

1. Current customer — I'll check whether you have sf, Salesforce MCP, or
   Slack connected, and offer to pull live account data with your OK.
2. Prospect / lead — I'll stick to public sources (website, press,
   LinkedIn, Crunchbase via /download).
3. Not sure / mixed — I'll start with public sources; we can layer in
   internal data later if you confirm they're a customer.
```

### Non-skippable by default

`--no-org-profile` suppresses the gate for one-off prompts (e.g., "what's
the difference between Service Cloud and Service Cloud Voice?"). Default
behavior is to ask — the skill never silently produces a generic answer to
a question that obviously concerns a real org.

## Step 0a — Profile by name (Q1 = 1)

The skill says plainly: *"I won't guess facts about [Org Name] from
memory — let's ground this."*

**If Q2 = Prospect/lead (or Not sure):**

1. Offer `/download` against a small public seed-list:
   - The org's `/about`, `/investors`, `/newsroom` (or `/press`) pages.
   - A search like `"<Org Name>" salesforce site:linkedin.com OR site:salesforce.com OR site:crunchbase.com`.
2. Propose a profile draft from the harvested artifacts.
3. Save with `source: "public-web:<org>"` plus the source URLs.

**If Q2 = Current customer:** branch to Step 0c below.

**Privacy guardrail:** the skill warns once that public sources may be out
of date and that nothing the user adds gets sent anywhere except the AI
CLIs they have already authenticated. `.org-profile.json` is local-only;
recommend adding `.claude/skills/*/.org-profile*` to the user's
`.gitignore` if the workspace is shared via git.

## Step 0b — Profile by culture & size (Q1 = 2)

A 6-field wizard. Presented as `AskUserQuestion` when the harness supports
it (Claude Code); a numbered prompt otherwise (Cursor IDE shim).

| # | Field | Options (concrete reference examples) |
|---|-------|----------------------------------------|
| 1 | **Org size** | (a) 1–25 (e.g., a small nonprofit, a boutique agency) · (b) 25–250 (e.g., a regional credit union, a mid-size charter network) · (c) 250–2,500 (e.g., a mid-market retailer, a state university system) · (d) 2,500–25,000 (e.g., a regional hospital network, a Fortune 1000 retailer) · (e) 25,000+ (e.g., Dell, NVIDIA, Bank of America) |
| 2 | **Salesforce maturity** | (a) Greenfield — no Salesforce yet · (b) Recent — < 2 years, one cloud · (c) Established — 2–5 years, 2+ clouds, some automation · (d) Mature — 5+ years, multi-cloud, Apex/LWC, integrations · (e) Heavily customized platform — significant technical debt, may resist OOTB |
| 3 | **Tech adoption posture** | (a) Innovator / first-mover · (b) Fast-follower · (c) Pragmatic majority · (d) Risk-averse / late · (e) Mandated-to-modernize |
| 4 | **Regulatory / data sensitivity** | (a) Low · (b) Moderate (SOC 2, GDPR baseline) · (c) High (HIPAA / PCI / FINRA / FedRAMP / GxP / FERPA) · (d) Highest — multiple of the above plus data residency |
| 5 | **Decision-making structure** | (a) Founder/CEO-decides · (b) Department head decides · (c) IT-gated committee · (d) Procurement-led RFP · (e) Multi-stakeholder consensus |
| 6 | **Culture (optional multi-select)** | Mission-driven · Customer-obsessed · Engineering-led · Compliance-first · Founder/owner-operator · Consensus-and-process · Cost-conscious · Growth-at-all-costs · Risk-averse / change-fatigued · Innovation-mandated |

**Optional fields (skipped by default; offered if the user picks "more detail"):**
- Industry sub-segment (e.g., Financial Services → Retail / Wealth / Insurance / Cap Markets)
- Geography (NA / EMEA / APAC / LATAM / Global)
- Named competitive landscape (Microsoft Dynamics, HubSpot, ServiceNow, in-house)
- Deal stage (Discovery / Demo / Eval / Proposal / Negotiation / Late-stage)

Save with `source: "self-described"`.

## Step 0c — Current customer (high-value internal grounding)

The highest-leverage proactive install moment in the skill.

**Detection — runs in parallel, reports back together:**

| Tool | What we look for | What it can contribute |
|------|------------------|------------------------|
| **Salesforce CLI (`sf`)** | `sf` on PATH; `sf org list` returns ≥ 1 authorized org | Account record (industry, size, AnnualRevenue, billing geo), recent Opportunities + stages, install base (active products/licenses), Support/Service tickets, last 12 months Activity history, key Contacts. |
| **Salesforce MCP** | Any MCP server with `salesforce` in name or known IDs | Same surface as `sf` via MCP — preferred if available. |
| **Slack MCP** | Slack MCP server in config | Recent channel mentions of the org (deal channels, Slack Connect channels), who's talked about them. |
| **Other CRM exports** | A `references/<org>.csv` or `references/<org>.json` the user dropped in | Use as-is. |

### If none of the above are present

Present the ranked install menu — see [usage.md](usage.md) §8. Four-option pattern:
- (a) Walk me through the top one (`sf`) now (~3 min)
- (b) Walk me through all three (~8 min)
- (c) Skip for this run; ask me again next time I name a customer
- (d) Skip and don't ask again

### Per-tool, per-data consent — never silently pulls

```
I can pull these from your <org-alias> org (sandbox or prod — you pick).
Each one is optional; check the boxes you're OK with. None of it leaves
your laptop except a short summary I'll show you and ask you to approve
before any persona sees it:

  ☐ Account record (industry, size, geo, AnnualRevenue)
  ☐ Active products / licenses (install base)
  ☐ Open opportunities (stage, amount, close date)
  ☐ Recent Cases (last 90 days, severity, status)
  ☐ Activity timeline (last 12 months)
  ☐ Key contacts and their roles
  ☐ Slack channel mentions (last 30 days)

Which sandbox/org should I use?  [picker of orgs from `sf org list`]
```

### Two-stage redaction before any model sees customer data

1. **Raw extraction.** `sf` / MCP / Slack queries run locally; results land
   in `.claude/skills/focus-group/.org-profile-raw/<org-slug>/` (git-ignored,
   never sent anywhere automatically).
2. **User-approved summary.** The skill drafts a structured summary ("3 open
   Sev-2 cases on EHR integration; Health Cloud Phase 2 stalled at UAT for
   90 days; champion: Director of Patient Access; economic buyer: CIO; ARR:
   $X; last QBR: 2026-02-12") and **shows it to the user for approval**
   before any persona prompt is built. The user can redact lines, add
   notes, or reject the summary entirely. **Nothing from the raw extraction
   reaches a model without this approval step.**
3. The approved summary lands in `.org-profile.json` with `source:
   "internal:sf+slack:<org>"`, the org alias, and an extraction timestamp.

### Sandbox vs production warning

When the chosen org is a production org, append to the summary:
> *"You're reading from a production org — be careful about pasting this
> report into a Slack channel that includes the customer."*

Sandbox orgs get no warning beyond the usual.

### Refresh cadence

On subsequent `/focus-group` runs, if the profile is > 14 days old, the skill
asks if the user wants a refresh (one-click re-run of the same approved
data list).

## The injected block

Every persona's grounding prompt receives this block **before** its
product-focus lens fires:

```
## Customer org profile (apply this to every reaction)
- Customer: <Name (named) | not named — culture/size profile only>
  [if named, append:]
  - Sources: providence.org/about (2026-05-15), crunchbase.com/... (2026-05-15)
- Size: 2,500–25,000 employees (regional hospital network)
- Salesforce maturity: Established — Service Cloud + Health Cloud, 3 years in
- Tech adoption: Pragmatic majority
- Regulatory: High — HIPAA + state privacy laws
- Decision-making: Multi-stakeholder consensus — CIO + CMIO + Privacy Officer + Procurement
- Culture: Mission-driven · Compliance-first · Consensus-and-process · Risk-averse (post-2024 EHR rollout fatigue)
- [if internal sources used:] Internal data on file: account record, install base,
  3 open Sev-2 cases, last QBR 2026-02-12 (user-approved summary)
```

## The JSON file on disk

`.claude/skills/focus-group/.org-profile.json` per workspace:

```json
{
  "version": 1,
  "saved_at": "2026-05-20T15:42:00Z",
  "source": "internal:sf+slack:providence-health",
  "customer_name": "Providence Health",
  "source_urls": [
    {"url": "https://www.providence.org/about", "retrieved": "2026-05-15"},
    {"url": "https://www.crunchbase.com/organization/providence-health", "retrieved": "2026-05-15"}
  ],
  "size_bucket": "d",
  "size_label": "2,500–25,000 employees (regional hospital network)",
  "salesforce_maturity": "c",
  "salesforce_maturity_label": "Established — Service Cloud + Health Cloud, 3 years in",
  "tech_adoption": "c",
  "regulatory": "c",
  "decision_making": "e",
  "culture_tags": ["mission-driven", "compliance-first", "consensus-and-process", "risk-averse"],
  "internal_data": {
    "extracted_at": "2026-05-20T15:38:00Z",
    "org_alias": "providence-sandbox",
    "approved_summary": "3 open Sev-2 cases on EHR integration; Health Cloud Phase 2 stalled at UAT for 90 days; champion: Director of Patient Access; economic buyer: CIO; ARR: $X; last QBR: 2026-02-12",
    "data_types_approved": ["account", "install_base", "open_opps", "cases_90d", "activity_12mo", "contacts", "slack_mentions"],
    "is_production": false
  }
}
```

Always git-ignore this file (the README recommends adding
`.claude/skills/*/.org-profile*` to the user's `.gitignore` if the
workspace is shared via git).

## Path validation for `--org-profile-file`

The `--org-profile-file <path>` switch reads JSON from an arbitrary
filesystem path. Without bounds checking, a typo (or a malicious arg
in a copy-pasted command) could point the skill at `/etc/passwd`,
`~/.ssh/id_rsa`, or another file the skill has no business reading —
and on parse failure, the error path could leak filesystem structure
to the model.

Before opening the file, the orchestrator must enforce these rules:

1. **Resolve the path.** Expand `~`, then call the host's "real path"
   resolver (`os.path.realpath` on Python, `fs.realpathSync` on Node)
   to follow symlinks. The check runs against the *resolved* path,
   not the literal argument — a symlink inside the workspace that
   points to `/etc/passwd` is rejected on the resolved target.

2. **Allowed roots (the resolved path must be inside one of these):**
   - The current workspace root (the directory `/focus-group` was
     invoked from, or its nearest ancestor containing `.git` /
     `.claude/`).
   - The user's home directory (`$HOME` / `%USERPROFILE%`).
   - An explicit `profiles/` subdirectory of either of the above.

3. **Disallowed even if technically inside an allowed root:**
   - Any path under `.git/`, `.ssh/`, `.aws/`, `.config/gh/`,
     `.netrc`, `.npmrc`, `.pypirc`, or any file matching
     `*credential*` / `*secret*` / `*.pem` / `*.key`.
   - Any path that the OS reports as not a regular file (devices,
     FIFOs, sockets, directories).

4. **Size cap.** Reject files larger than **256 KB**. A legitimate
   org profile is < 4 KB; anything larger is either wrong or hostile.

5. **Rejection message** (per the err-doctrine in
   [err-doctrine.md](err-doctrine.md) — name the cause, say what's
   safe, offer a next step):

   > *I can't load that profile file — it resolves to `<resolved-path>`,
   > which is outside the allowed roots (workspace + home directory).*
   >
   > *Move the file inside this workspace (or your home directory) and
   > re-run, or paste the JSON inline and I'll save it as a new
   > `.org-profile.json` after you confirm.*

6. **On parse failure** (file is inside the allowed root but the JSON
   is malformed), surface the line/column from the parser but **never**
   print the file's full path or any of its contents to the model
   context — print only the bare filename + the parse error. This
   prevents an out-of-bounds file (that somehow passed validation)
   from leaking its contents through error text.

The same validation rules apply to any future switch that takes a
filesystem path argument (e.g., a hypothetical `--persona-file`
override).
