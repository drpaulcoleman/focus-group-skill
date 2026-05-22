# Claude AI Skills: a Virtual Focus Group

> **📖 Full documentation, prompt examples, install paths:** <https://drpaulcoleman.github.io/focus-group-skill/>

**Seven Claude Code / Cursor skills that put your toughest reviewers in the room with you before the customer is.** Solution Engineer. CIO. Champion. InfoSec officer. Industry Specialist. They pressure-test your draft — grounded in your real Salesforce docs and account data — before it ever leaves your laptop.

## In 30 seconds

Type this in Claude Code, in the folder where the skills live:

    /focus-group review my QBR for Pacific Grants Alliance

A panel sized to the customer reads the draft from each of their seats — Executive Director, Director of Development, Board Treasurer, IT Director, Program Manager. A second AI model cross-checks every factual claim. The skill hands you a sharpened version with citations, an accuracy score, and a ranked action list. Typically under ten minutes. Customer names never leave your laptop.

## The seven skills

Each one earns its keep on its own. Together they take you from cold prospect research to a draft your customer's InfoSec officer can't pick apart.

- **`/focus-group`** — Pressure-test your draft against five tough reviewers, sized to your customer. Hands back a ranked action list with citations and an accuracy score.
- **`/download`** — Stop guessing what the docs actually say. Pulls in real Salesforce Help, Trailhead, Architect, and developer.salesforce.com pages so the panel can cite them.
- **`/cross-ai-review`** — Two or three AI models read your draft side-by-side. What they all flag is probably real; what only one flags is where the deal-killers usually hide.
- **`/anonymize`** — Talk to AI about your real customers without the legal blast radius. Names, ARR, account IDs become typed placeholders before any model sees them — and get restored on the way back. Token map stays on your laptop.
- **`/slackbot`** — Pull the freshest team intel before a status call. Surfaces recent mentions of the account in channels you're already in; never DMs, never channels you aren't in.
- **`/how-can-this-be-improved`** — Catches the hedges, the buried bottom line, the audience the panel didn't cover — before they reach a customer.
- **`/make-this-mine`** — Two-minute guided interview that personalizes `/focus-group` to your role, deal types, industry, and noise preferences. Run once; the skill remembers.

## Built for

Account Executives · Solution Engineers · Industry Specialists · Enterprise / Technical Architects · Business Value Consultants · Lead Engagement / SDR coaches — working with Salesforce CRM + Agentforce and the broader Salesforce + Slack product family.

## What it costs

Free. MPL-2.0. No telemetry, no account beyond your existing Claude Code or Cursor subscription. Not a CRM plugin, not a Salesforce add-on, not a vendor service — seven skill files you drop into a folder.

## Getting started — three install paths

This repo is a **GitHub template**. Pick the path that fits how you work:

| Path | Best when… | What to do |
|------|-----------|-------|
| **🆕 Use this template** *(recommended)* | You want your own repo to evolve | [Click "Use this template"](https://github.com/drpaulcoleman/focus-group-skill/generate) → name it → clone → open in Claude Code or Cursor. |
| **📦 Download ZIP** *(no `git` required)* | You're just trying it out | [Download the ZIP](https://github.com/drpaulcoleman/focus-group-skill/archive/refs/heads/main.zip) → unzip → open in Claude Code or Cursor. |
| **🔧 `git clone`** | You're comfortable on the command line | `git clone https://github.com/drpaulcoleman/focus-group-skill.git && cd focus-group-skill` |

Then type `/focus-group help` in Claude Code (or Cursor) and you're off.

**OS-specific global install** (after you decide you like it): see the
[full install walkthrough](https://drpaulcoleman.github.io/focus-group-skill/#install) on the docs site.

## Salesforce & Slack integrations

The skills are at their best when they can talk to your real working environment — your `sf` org (or Salesforce MCP), your Slack workspace, and the public Salesforce documentation. Each integration is optional and only ever used with your explicit per-data approval; nothing reaches an AI model without an approval step. See [Privacy & data handling](#privacy--data-handling).

## Why you'd use it

**Discovery prep for a prospect.** Profile a new lead by name; the skill
pulls public web sources, then runs your discovery questions past a virtual
Solution Engineer, Industry Specialist, Champion, and Economic Buyer
*before* the call.

**Account review for a current customer.** Point the skill at your `sf`
sandbox; pull the Account, open Cases, active opportunities; then review
your QBR draft with a panel that sees the actual gaps and risks. The
report cites every source it used.

**Demo readiness.** Have a virtual Solution Engineer pressure-test your
demo flow for governor limits, OOTB gaps, and customization risk —
informed by what the customer actually owns, not what you assume.

**Art-of-the-possible / spec-driven build.** Sketch a Salesforce demo
build spec with an Enterprise Architect, AE, and customer Champion all
weighing in — grounded in the customer's industry, size, and culture.

**Cross-AI fact-check before sending.** Run a draft email, proposal
section, or QBR talking point through `/cross-ai-review` and catch
confident-but-wrong claims before a customer does.

## What you need first

- The **Claude Code CLI** or **Cursor** (one is enough).

That's it for the basics. The skills will proactively offer optional
upgrades — `sf`, Salesforce MCP, Slack, a second AI model, a headless
browser for `/download` — at the moments they'd help. You're never
required to accept; the skills work in a reduced-capability mode without
them and tell you what you're missing in plain language.

## Where the full walkthroughs live

Per-skill specs (switches, edge cases, full pipelines) live in each skill's `SKILL.md`:

| Skill | Spec |
|-------|------|
| `/focus-group` | [`.claude/skills/focus-group/SKILL.md`](.claude/skills/focus-group/SKILL.md) · [usage walkthrough](.claude/skills/focus-group/references/usage.md) |
| `/download` | [`.claude/skills/download/SKILL.md`](.claude/skills/download/SKILL.md) |
| `/cross-ai-review` | [`.claude/skills/cross-ai-review/SKILL.md`](.claude/skills/cross-ai-review/SKILL.md) |
| `/anonymize` | [`.claude/skills/anonymize/SKILL.md`](.claude/skills/anonymize/SKILL.md) |
| `/slackbot` | [`.claude/skills/slackbot/SKILL.md`](.claude/skills/slackbot/SKILL.md) |
| `/how-can-this-be-improved` | [`.claude/skills/how-can-this-be-improved/SKILL.md`](.claude/skills/how-can-this-be-improved/SKILL.md) |
| `/make-this-mine` | [`.claude/skills/make-this-mine/SKILL.md`](.claude/skills/make-this-mine/SKILL.md) |

Or open the [docs site](https://drpaulcoleman.github.io/focus-group-skill/) for the brochure version with prompt examples.

## Privacy & data handling

- **Downloads** land locally in `references/<slug>/`. Never uploaded
  anywhere.
- **`sf` / Salesforce MCP / Slack queries** run locally; raw extraction
  lands in `.claude/skills/focus-group/.org-profile-raw/` (git-ignored).
  **Nothing reaches an AI model without an explicit user-approved
  summary step.**
- **CLI calls** (`claude`, `codex`, `gemini`, `opencode`) go to whichever
  AI vendor you've configured and authenticated. The skill doesn't add
  anything beyond what you would have sent typing the prompt yourself.
- **The customer profile** is saved to `.claude/skills/focus-group/.org-profile.json`
  (git-ignored). If you share the workspace via git, add
  `.claude/skills/*/.org-profile*` to your `.gitignore`.
- **No telemetry.** The skills do not phone home in any form.

## Troubleshooting

If something fails, the skill responds in four lines:

1. **The cause**, in one plain-English sentence.
2. **What it did** without the failing piece.
3. **One or two concrete next steps** you can take.
4. *"If you'd like, paste the screen you see and I'll translate it."*

That last line matters. Pasting raw error text at the AI is the right
thing to do — that's what the skill is set up to translate. See the err
doctrine at
[`.claude/skills/focus-group/references/err-doctrine.md`](.claude/skills/focus-group/references/err-doctrine.md).

If you hit something the skill can't translate, open an issue on the
GitHub repo — include the version of Claude Code or Cursor you're on,
your OS, and the screen the skill showed you.

## Contributing

The repo is structured so each part can be sharpened independently:

- **Add a product pack** → write
  `.claude/skills/focus-group/references/product-packs/<slug>.md` following
  the same shape as `salesforce-crm-agentforce.md` and add the slug to
  the table in
  [`references/usage.md`](.claude/skills/focus-group/references/usage.md).
- **Add an industry pack** → write
  `.claude/skills/focus-group/references/industry-packs/<slug>.md` and add 3–8
  industry-specific personas at
  `.claude/skills/focus-group/personas/industries/<slug>/<role>.md`
  (depending on how many sub-verticals the pack needs to serve).
- **Add a persona** → write the file following the schema in
  [`persona-roster.md`](.claude/skills/focus-group/references/persona-roster.md)
  and add it to the roster table.
- **Sharpen an existing industry persona** → personas ship with
  sub-profiles for the most-common sub-archetypes the seat serves
  (e.g., `dealer-network-director` has separate sub-profiles for
  domestic-OEM-mass, domestic-OEM-luxury, and import dealers). The
  maintainer note at the bottom of each file invites adding further
  sub-profile splits as real conversations reveal which dimensions
  matter most.

Pull requests welcome. Keep the voice rule in mind: plain, professional,
neutral. No slang, no labels for the reader (`noob`, `newbie`,
`non-technical`), no jokes at the reader's expense.

## License

See [LICENSE](LICENSE).
