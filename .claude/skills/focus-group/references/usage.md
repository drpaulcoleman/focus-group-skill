# How to use `/focus-group`

This is the user-facing walkthrough the skill prints when the user runs
`/focus-group help` (or `--help`, `-h`, `?`) or asks how the skill works.

## What `/focus-group` is

`/focus-group` convenes a **panel of simulated-persona reviewers** — distinct
human viewpoints — that each react to your content from their own
perspective, then synthesizes their feedback into final recommendations,
action items, an estimated **accuracy score**, and a citations block.

It is built for Salesforce sales teams (AEs, SEs, Industry Specialists,
Architects, Business Value, Lead Engagement). Out of the box it grounds
every panel in **Salesforce CRM + Agentforce**; switch to any of 13
product packs or layer in any of 19 industry packs, or run `--generic`
for non-Salesforce work.

It is **explicit-trigger** — it runs only when you invoke it.

## How to invoke it

| You type | What happens |
|----------|--------------|
| `/focus-group <file-or-paste-or-url>` | Reviews that content. Asks who the customer is (by name or by culture & size) before researching the topic. Recommends a panel and asks you to confirm. |
| `/focus-group <content> with the <name> panel` | Uses a named quick-pick panel (see below). |
| `/focus-group <content> — <persona>, <persona>, ...` | Uses exactly the personas you name. |
| `/focus-group help` | Shows this guide. |
| `/focus-group config` | Views or sets defaults (channel models, install-prompts toggle, org-profile). |

## Quick-pick panels

When you don't name personas, the skill recommends 5 based on the active
product/industry pack and your org profile. You can also explicitly pick
one of these panels:

- **Buyer** — Economic Buyer · Champion · InfoSec / Privacy · Procurement · Champion's manager
- **Tech** — Solution Engineer · Enterprise Architect · Technical Architect · Security Reviewer · QA / Test Engineer
- **Discovery** — Industry Specialist · Champion · Economic Buyer · Solution Engineer · Business Value Consultant
- **Demo Readiness** — Solution Engineer · Technical Architect · Beta Tester · Accessibility-Dependent User · Business Value Consultant
- **Architecture Review** — Enterprise Architect · Technical Architect · Security Reviewer · Schema/DB Reviewer · DevOps/SRE
- **Industry Deep-Dive** — five personas drawn from the active industry pack (e.g., for healthcare: CMO, HIPAA Privacy Officer, Patient Experience Director, IT Director, Champion)
- **Everyone** — all available personas for the active pack(s); slower, broader-but-shallower synthesis. Warn the user.

## Switches (combine as you like)

| Switch | Effect |
|--------|--------|
| `--product <slug>` | Salesforce CRM + Agentforce is the default. Other packs: see [product-packs/](product-packs/). |
| `--industry <slug>` | Layer an industry pack on top of the product pack. 19 industries: see [industry-packs/](industry-packs/). |
| `--generic` | No product/industry grounding — describe context yourself in prose. |
| `--single-ai` | Run the whole panel on the host Claude alone (no external CLI dispatch). For speed, privacy, or no external token spend. |
| `--claude-model <m>` · `--codex-model <m>` · `--gemini-model <m>` · `--opencode-model <m>` | Override that channel's model for this run only. |
| `--personas "<NL>"` | Bias the recommendation: *"weight technical and InfoSec"*, *"must include a champion and an economic buyer"*, *"skip the investor family"*, *"keep it to 4"*, *"everyone"*. Shapes the recommendation — does not bypass the confirm gate. |
| `--everyone` | Run with every available persona for the active pack(s). |
| `--org-profile` | Re-run the Org Profile wizard explicitly. |
| `--no-org-profile` | Skip the org-profile gate for one-off generic prompts. |
| `--org-profile-file <path>` | Load org profile from a hand-edited JSON. |
| `--require-citations` | Strict — any factual claim without a `/download` source goes to "Needs verification"; accuracy score capped at 70 until the gap is closed. |
| `--no-citations` | Skip citation enforcement and auto-research. `/download` does not auto-run at Step 7; accuracy not capped; un-cited claims stay in main report. For speed or offline use. |
| `--quick` · `--fast` | Fast mode: 3 personas (AE, SE, Economic Buyer), local Claude only, no citations, no Stage B/C, <60 seconds. |
| `--stage <stage>` | Set deal stage: `discovery`, `demo`, `negotiation`, `post-sale`. Shapes persona output calibration. |
| `--role <slug>` | Override saved role for this run. Slugs: `ae`, `se`, `industry-specialist`, `enterprise-architect`, `technical-architect`, `bvc`, `lead-engagement`, `csm`, `partner-am`, `other`. |
| `--probe` | Force fresh CLI/MCP detection, bypassing the 24-hour cache. |
| `--attendees <path>` | Folder of attendee profiles to ground the panel in real people on the call. |

## What the skill asks you up-front

Most of the time, **two short questions** before any research starts:

### Q1 — How to profile the customer

1. **Profile by name** — name the actual org (e.g., "Providence Health").
2. **Profile by culture & size** — a 30-second wizard.
3. **Skip** — generic feedback is fine.

### Q2 — Relationship

1. **Current customer** — the skill checks for `sf`, Salesforce MCP, Slack
   and offers to pull live account data with your OK on each piece.
2. **Prospect / lead** — public sources only (website, press, LinkedIn,
   Crunchbase via `/download`).
3. **Not sure / mixed** — public sources first; layer in internal data if
   confirmed.

The profile is saved per workspace and persists across `/focus-group` runs.
Re-run the wizard any time with `--org-profile`.

## §8 — Proactive install offers

The skill never auto-installs anything. It **asks you, once per workspace
per tool, at the moment of concrete value** — and remembers your answer.

| When | Tool offered | Why this is the right moment |
|------|--------------|------------------------------|
| You identified a current customer and `sf`/Salesforce MCP/Slack is missing | (⭐⭐⭐) `sf` (~3 min) · (⭐⭐) Salesforce MCP · (⭐) Slack MCP | Turns generic feedback into account-specific feedback. |
| `/download` returned an empty page (JS-rendered site, no headless runtime) | (⭐⭐⭐) Python+Playwright · (⭐⭐) Node+Playwright · (⭐) Microsoft Edge on Windows 11 | The empty result is visible; the symptom is concrete. |
| `/cross-ai-review` ran with only `claude` and the multi-Claude fallback engaged | (⭐⭐⭐) gemini · (⭐⭐) codex · (⭐) opencode | A second vendor model meaningfully sharpens the audit. |
| Active product pack is `slack` and no Slack MCP detected | (⭐) Slack MCP | The pack implies you work with Slack content. |
| Active pack is `data-cloud` / `commerce-cloud` and `sf` is missing | (⭐) `sf` with relevant plugins | Data-grounded packs benefit most from live `sf` access. |
| Workspace has no `.git/` and you've edited files | (⭐) `git` (soft, at session end) | Time-machine framing — recoverability matters when AI is editing files. |

**Every offer uses the same four-option menu:**

- (a) Walk me through the top one now
- (b) Walk me through all of them
- (c) Skip for this run; ask me again next time this comes up
- (d) Skip and don't ask again

Your answer (and the reason it was triggered) is saved to
`.claude/skills/<skill>/.install-asked.json`. The skill won't pester. You
can re-enable prompts any time with:
```
/focus-group config set install-prompts on
```

## Examples

```
# A typical AE/SE flow: prep a discovery call for a prospect
/focus-group discovery-questions-draft.md
  → asks who the customer is → "profile by name → Acme Credit Union"
  → asks "current customer or prospect?" → "prospect"
  → offers /download against acme.com/about, IR page, LinkedIn — accept
  → proposes a panel: SE, Industry Specialist (FinServ), Champion (VP Member
     Experience), CIO Economic Buyer, Business Value Consultant — accept
  → runs panel, reports back with citations and an accuracy score.

# Review an existing customer's QBR draft with live sf grounding
/focus-group qbr-draft.md
  → asks who the customer → "profile by name → Providence Health"
  → "current customer" → walks through sf consent (account, opps, cases) → approve
  → loads industry pack: healthcare-life-sciences
  → proposes a panel including HIPAA Privacy Officer and Patient Experience Director
  → runs panel; report includes "3 open Sev-2 cases on EHR integration" in context.

# Strict citation mode for a written proposal
/focus-group proposal-section-3.md --require-citations
  → enforces sources for every factual claim, caps accuracy at 70 until
     the gaps are closed, offers /download seeds to fill them.

# Generic, non-Salesforce
/focus-group my-readme.md --generic
  → no product/industry grounding; uses general lenses only.
```

## Where the report lands

`.scratch/focus-group/<YYYY-MM-DD>-<short-slug>.md`. Open it, share it, or feed
it into your next prep. Re-run the panel any time with the footer's
suggested commands.

## Privacy

- Downloads land in `references/` (git-ignored) on your machine.
- `sf` / Slack / Salesforce MCP queries run locally; raw extraction lands
  in `.org-profile-raw/` (git-ignored). **Nothing reaches an AI model
  without an explicit user-approved summary step.**
- CLI calls (`claude`, `codex`, `gemini`, `opencode`) go to whichever AI
  vendor you've configured and authenticated. The skill doesn't add
  anything beyond what you would have sent typing the prompt yourself.
- **No telemetry.** The skills don't phone home in any form.

## If something goes sideways

Apply the err-doctrine: paste the screen you see, and ask the AI to
translate. See [err-doctrine.md](err-doctrine.md).
