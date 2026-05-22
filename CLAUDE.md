# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**focus-group-skill** is a collection of seven Claude Code / Cursor skills designed for Salesforce sales teams (Account Executives, Solution Engineers, Industry Specialists, Architects, Business Value Consultants, and Lead Engagement roles).

**Core concept:** Multi-persona review panels and supporting tools that ground feedback in real customer context, product knowledge, and industry expertise.

**Key values:** Privacy-first (data stays local), no telemetry, no external dependencies beyond what the user explicitly approves.

## Architecture

### Skill organization
```
.claude/skills/
├── focus-group/          # Main skill: multi-persona review panel (177 personas, 13 product packs, 19 industry packs)
├── download/            # Doc harvester: runtime-adaptive to local tools (Playwright/Puppeteer→curl fallback)
├── cross-ai-review/     # Multi-model auditor: detects claude/codex/gemini/opencode CLIs
├── anonymize/           # Bidirectional scrubber: placeholders stay local in map.json
├── slackbot/            # Slack-sourced context: queries Slack MCP, routes through /anonymize
├── how-can-this-be-improved/  # Local-only improvement coach
└── make-this-mine/      # Guided personalization interview — tunes focus-group to user's role/deals/noise prefs
```

Each skill is **self-contained**:
- `SKILL.md` — complete spec (modes, switches, pipeline steps, outputs)
- `references/` — lookup tables, schemas, rubrics, usage walkthroughs
- `personas/` — persona files (focus-group only; 177 across `generic/`, `industries/`, and Salesforce variants)
- `evals/` — test suites (evals.json: test spec + expected outcomes)
- `scripts/` — runtime scripts (e.g., scrub patterns for anonymize, CLI probes for cross-ai-review)

### Persona file structure (focus-group)
- **Generic personas** (`.claude/skills/focus-group/personas/generic/`) — 5 role families split by seniority/function: `customer/`, `executives/`, `investor/`, `stakeholder/`, `technical/`
- **Industry-specific personas** (`.claude/skills/focus-group/personas/industries/<industry>/`) — 19 industries; each industry folder contains 5–13 role files (e.g., `healthcare-life-sciences/` has HIPAA Privacy Officer, CMO, IT Director, etc.)
- **Salesforce role overlays** (`.claude/skills/focus-group/personas/salesforce-*`) — three Salesforce context variants: `salesforce-customer/`, `salesforce-partner/`, `salesforce-sales/`
- **Persona file format** — markdown header (`# Title`) + 3 bold metadata lines (`**Family:**`, `**Default mode:**`, `**One-liner:**`) + markdown body sections (Sub-profiles, Deliberative profile, Generic lens, optional Pack lenses, optional Sales-specific lens). All 187 personas follow this schema.

### Config and caching
- `.claude/skills/focus-group/config.json` — persists user role, default product/industry pack, and model channel defaults
- `.claude/skills/focus-group/.focus-group-cache.json` — 24-hour cache of CLI availability (Claude, Codex, Gemini, opencode)
- `.claude/skills/focus-group/.org-profile.json` — persists org size, Salesforce maturity, regulatory context per workspace (git-ignored)
- All local maps and profiles are git-ignored

## Common Development Tasks

### Understanding a skill's flow
1. Read the skill's `SKILL.md` — each file has a top-level YAML description (triggers, intent, outputs) and then a numbered pipeline
2. Check `references/` for lookup tables (e.g., `references/usage.md` for user-facing walkthrough, `references/cli-matrix.md` for model routing)
3. For focus-group: check `personas/` folders and `references/persona-roster.md` to understand the panel recommendation engine

### Testing a skill
- Test specs live in `evals/evals.json` — JSON format with `id`, `input`, `expected_outcome`, `rubric`
- **Run tests in Claude Code/Cursor:** paste the test spec and the skill `.md` file, ask Claude to execute the flow
- **Validate outputs:** check that recommendations exist, citations are present, persona breakdown is clear, accuracy scores are in range [0–100]
- **Edge cases to test:**
  - `/focus-group --generic` (no product/industry grounding)
  - `/focus-group --single-ai` (run on Claude alone, no external CLI dispatch)
  - `/focus-group config` (settings persistence)
  - `/anonymize` with org profile containing customer names/ARR
  - `/download` with URLs that aren't Salesforce docs (fallback chain: Python Playwright → curl)

### Adding a new persona
1. Check `persona-roster.md` to find existing persona count and naming conventions
2. Create a `.md` file in the appropriate persona folder (e.g., `.claude/skills/focus-group/personas/industries/healthcare-life-sciences/chief-medical-officer.md`)
3. Use the template from an existing persona — the file must have: `# Title` header, then `**Family:**`, `**Default mode:**`, `**One-liner:**` metadata lines, then `## Sub-profiles`, `## Deliberative profile`, `## Generic lens` sections at minimum
4. Add the new persona to the roster table in `references/persona-roster.md`
5. If adding to a new industry: create the industry folder, add 5–8 core personas covering the load-bearing seats

### Adding a new product or industry pack
1. **Product pack:** create `.claude/skills/focus-group/references/product-packs/<slug>.md` (e.g., `healthcare-cloud.md`)
   - Copy the structure from an existing product pack (field mapping, feature overview, bias for recommendation engine)
   - Add the slug to the table in `references/usage.md`
   - If the pack needs industry-specific depth: add industry-pack overlays
2. **Industry pack:** create `.claude/skills/focus-group/references/industry-packs/<slug>.md`
   - Include regulatory context, decision-making culture, org size, typical Salesforce maturity
   - Create a corresponding `personas/industries/<slug>/` folder with 5–13 key roles for that industry

### Sharpening accuracy in a skill
- **focus-group:** accuracy score logic is in the 12-step pipeline (Step 9–11); adjust per `references/accuracy-rubric.md`
- **cross-ai-review:** accuracy aggregates cross-model consensus; see `references/cli-matrix.md`
- **anonymize:** review `references/scrub-patterns.md` to add new PII patterns (email, SSN, etc.)
- **download:** runtime chain priority in `scripts/` controls fallback order; test that curl still works when Playwright is unavailable

### Harvesting URLs — always defer to /download

When any task in this repo needs to fetch web content (a URL, a doc, a PDF,
search results, citations for a `/focus-group` panel), **invoke `/download`
as the first line of attack**. Do not reimplement harvest logic in ad-hoc
subagent prompts and do not call `WebFetch` directly on Salesforce help
pages, Trailhead, or other JS-rendered sites — they return empty SPA shells
under static fetch and Akamai/Cloudflare bot-block headless Chromium.

`/download` has cross-OS runtime detection that prioritizes **real
Chrome** (then real Edge, then Playwright, then curl). Real browsers dodge
most bot-detection that blocks Playwright's bundled Chromium. The
priority order, scripts, and install walkthroughs all live under
`.claude/skills/download/` — extending or fixing harvest behavior
belongs there, not in the calling skill.

This applies to subagents too: when spawning an `Explore` or `general-purpose`
agent that needs web content, instruct it to call `/download` (or run
`scripts/harvest-chrome.sh` / `scripts/harvest-chrome.ps1` directly)
rather than rolling its own fetch.

## Key Files to Know

| File | Purpose |
|------|---------|
| `README.md` | Public-facing intro; install paths; 30-second pitch |
| `llms.txt` | Machine-readable repo summary (llmstxt convention) |
| `.claude/skills/<skill>/SKILL.md` | Complete skill spec (7–15 pages): modes, switches, 12-step pipeline, outputs, edge cases |
| `.claude/skills/focus-group/references/usage.md` | User-facing walkthrough printed by `/focus-group help` |
| `.claude/skills/focus-group/references/persona-roster.md` | Master list of all 177 personas + counts |
| `.claude/skills/focus-group/references/org-profile-schema.md` | Org profile structure (size, Salesforce maturity, regulatory, culture) |
| `.claude/skills/focus-group/evals/evals.json` | Test spec for focus-group flow |
| `.cursor/commands/<skill>.md` | Cursor command shim (maps `/skill-name` in Cursor to the Claude Code skill) |

## Privacy & Data Handling

This is load-bearing: every skill routes through these gates:

1. **Local-only data:** org profiles (`.org-profile.json`), anonymization maps (`map.json`), and cached profiles are git-ignored and never uploaded
2. **Consent gates:** before any Slack query or `sf` extraction, the skill explicitly asks for user approval
3. **Anonymization:** `/anonymize` scrubs data *before* it reaches any external LLM; the reverse map stays local
4. **No telemetry:** skills do not phone home in any form
5. **Citations:** `/focus-group` attaches `/download` sources to every factual claim; strict mode (`--require-citations`) caps accuracy at 70% until claims are sourced

## Voice & Writing

- **Plain, professional, neutral.** No slang, no labels for the reader ("noob," "newbie," "non-technical"), no jokes at the reader's expense.
- **Persona files:** each persona should sound like that role would actually talk — specific jargon, pressure points, and decision drivers for their seat
- **Reference docs:** step-by-step clarity; assume the reader is under time pressure and may not have deep Salesforce expertise

## Contributing

- **Pull requests welcome.** Keep voice consistent across personas and packs.
- **Adding a product pack?** Use the template shape from `references/product-packs/salesforce-crm-agentforce.md`.
- **Adding industry personas?** Make sure the 5–8 personas cover the load-bearing decision seats (e.g., for non-profit: Executive Director, Development Director, Board Treasurer, IT Director, Program Manager).
- **Sharpening an existing industry?** Personas can have sub-profiles for sub-archetypes (e.g., `automotive/dealer-network-director` has separate profiles for `domestic-oem-mass`, `domestic-oem-luxury`, `import`). The maintainer note at the bottom of each file invites adding further splits.

## License

Mozilla Public License 2.0 (see `LICENSE`).
