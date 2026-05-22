---
name: focus-group
description: >-
  Multi-persona, multi-model review panel for Salesforce sales conversations
  — invoked explicitly by the user via `/focus-group` (or `/focus-group help` for a
  usage walkthrough, `/focus-group config` to set default models, `/focus-group
  --product <pack>` to switch the product/industry pack). Default pack:
  Salesforce CRM + Agentforce. Convenes simulated personas — Salesforce
  sales-team reviewers (AE, SE, Industry Specialist, Architect, Business
  Value), buyer-side personas (Economic Buyer, Champion, InfoSec, Procurement),
  technical experts, customers, and industry-specific roles — and optionally
  distributes them across the Claude, Codex, Gemini, and opencode CLIs. Each
  persona reacts to your content from their viewpoint; the skill then
  cross-consolidates the feedback, scores cross-model accuracy, and attaches
  citations from `/download`. Proactively asks who the customer is (by name or
  by culture & size) before researching the topic, so feedback grounds in real
  context instead of guesses. Explicit-trigger only: invoke only when the user
  explicitly runs `/focus-group`, `/focus-group help`, `/focus-group config`, or asks for
  a discuss / persona / review panel — do NOT auto-activate from adjacent
  conversation about reviews, feedback, decks, or personas. Distinct from
  `/cross-ai-review` (one prompt, many models, one viewpoint) and `/review`
  (GitHub PR review).
---

# /focus-group — Multi-Persona, Multi-Model Sales Review Panel

`/focus-group` convenes a **panel of simulated-persona reviewers** — distinct human
viewpoints — that each react to your content from their own perspective, then
synthesizes their feedback into final recommendations, action items, and an
estimated accuracy score with citations. It catches reception blind spots that
a single-model review misses: *"a CIO at this scale wouldn't approve that,"*
*"the InfoSec officer at a HIPAA-regulated customer would block this claim,"*
*"a Solution Engineer would call out the governor-limit risk."*

It is built for Salesforce sales teams (AEs, SEs, Industry Specialists,
Enterprise/Technical Architects, Business Value, Lead Engagement) and grounds
every panel in:

- the **product pack** under discussion (default: Salesforce CRM + Agentforce; 13 product packs + a `--generic` bypass — see [references/product-packs/](references/product-packs/));
- optionally an **industry pack** (19 industry packs — see [references/industry-packs/](references/industry-packs/));
- a short **org profile** (size, Salesforce maturity, regulatory environment, decision-making style, culture) collected up-front and persisted per workspace — see [references/org-profile-schema.md](references/org-profile-schema.md);
- and (optionally, for current customers) **live grounding** from `sf` / Salesforce MCP / Slack — see Step 4c below.

## Three modes the skill answers in

### Help mode
If the user invokes `/focus-group help` / `--help` / `-h` / `?`, or asks *how to
use* the skill rather than for a review, do NOT run a panel — read
[references/usage.md](references/usage.md) and give a concise usage walkthrough
(what it does, how to invoke, switches, panels, examples). Then stop.

### Config mode
If the user invokes `/focus-group config` (or asks to view/change defaults), do NOT
run a panel — read/write `config.json` in the skill root:

| Subcommand | Effect |
|------------|--------|
| `/focus-group config` | Show the current `config.json`. |
| `/focus-group config set <channel>-model <value>` | Set that channel's default model (e.g. `claude-model claude-opus-4-7`). |
| `/focus-group config set install-prompts on\|off` | Enable/disable proactive install offers. |
| `/focus-group config set user-role <slug>` | Save the user's role (slugs: `ae`, `se`, `industry-specialist`, `enterprise-architect`, `technical-architect`, `bvc`, `lead-engagement`, `csm`, `partner-am`, `other`). |
| `/focus-group config set product <slug>` | Save the default product pack (overrides the `last_product_pack` cache). |
| `/focus-group config set industry <slug>` | Save the default industry pack. |
| `/focus-group config clear org-profile` | Drop the saved org profile for this workspace. |
| `/focus-group config clear user-role` | Forget the saved role; Step 1 will re-ask next run. |
| `/focus-group config clear last-product-pack` | Forget the cached product pack so Step 3 asks again. |
| `/focus-group config clear last-industry-pack` | Forget the cached industry pack. |
| `/focus-group config set role-elaboration "<text>"` | Save a freeform role description (≤200 chars) from `/make-this-mine`. |
| `/focus-group config set deal-types <slug>,<slug>,...` | Save preferred deal types (from `/make-this-mine`). |
| `/focus-group config set excluded-noise <slug>,<slug>,...` | Save noise categories to demote in Stage A.5. |
| `/focus-group config set panel-size <n>` | Override default panel cap (3, 5, 7, or null). |
| `/focus-group config set default-stage <slug>` | Tiebreaker when content-type inference is ambiguous. |
| `/focus-group config clear personalization` | Drop all `/make-this-mine` keys (role-elaboration, deal-types, excluded-noise, panel-size, default-stage). |

Then stop. `config.json` is plain JSON — may also be hand-edited.

### Panel mode (the main flow)
All other invocations. Run the 12-step pipeline below.

## Switches (per-invocation, combinable)

| Switch | Effect |
|--------|--------|
| `--product <slug>` | Load a specific product pack (default `salesforce-crm-agentforce`). Slugs: see [references/product-packs/](references/product-packs/). |
| `--industry <slug>` | Load an industry pack on top of the product pack. Slugs: see [references/industry-packs/](references/industry-packs/). |
| `--generic` | Bypass all product/industry grounding — panel uses only the persona `## Generic lens`; user describes context in prose. |
| `--single-ai` | Run the whole panel on the host Claude alone — skip Step 0 CLI probe, run every persona as a local subagent, skip Stage B/C. Stage A is the final report. For speed, privacy, or no external token spend. |
| `--claude-model <m>` · `--codex-model <m>` · `--gemini-model <m>` · `--opencode-model <m>` | Override that channel's model for this run only. |
| `--personas "<NL bias>"` | Bias the panel recommendation (Step 5a) with qualifying natural language: emphasis (`"weight technical and InfoSec"`), inclusions (`"must include a champion and an economic buyer"`), exclusions (`"skip the investor family"`), size (`"keep it to 4"`, `"everyone"`), or explicit persona names. Shapes the recommendation — does not bypass the Step 5c approval gate. |
| `--everyone` | Run with every available persona for the active pack(s); warn it is slow and synthesis is broader-but-shallower. |
| `--org-profile` | Re-run the Org Profile wizard explicitly, even if a profile is on file. |
| `--no-org-profile` | Skip the Org Profile gate for one-off generic prompts (skill notes feedback may miss specifics). |
| `--org-profile-file <path>` | Load org profile from a hand-edited JSON. |
| `--require-citations` | Strict mode — accuracy score capped at 70 when the workspace has zero `references/<slug>/meta.json` files; the orchestrator audits the report and moves un-cited claims to a "Needs verification" section. Skill offers to run `/download` against the active pack's seed list first to close the gap. |
| `--role <slug>` | Override the saved role for this run only (does not persist). Slugs: `ae`, `se`, `industry-specialist`, `enterprise-architect`, `technical-architect`, `bvc`, `lead-engagement`, `csm`, `partner-am`, `other`. |
| `--probe` | Force a fresh tooling preflight (CLI + MCP detection), bypassing the 24-hour `.focus-group-cache.json`. Useful right after installing a new CLI or MCP server. |
| `--attendees <path>` | Folder of attendee profile files (one per stakeholder) the skill reads to ground the panel in real people on the call. See [references/usage.md](references/usage.md). |
| `--stage <stage>` | Set the deal stage for persona output calibration. Values: `discovery`, `demo`, `negotiation`, `post-sale`. When omitted, the skill infers stage from content type (pitch deck → demo; contract redline → negotiation; QBR materials → post-sale; discovery questions → discovery). Shapes every persona's output via the deal-stage adaptation in [references/persona-output-template.md](references/persona-output-template.md). |
| `--quick` · `--fast` | Fast mode for time-pressed AEs. Runs 3 personas only (AE, SE, Economic Buyer) on local Claude. Skips Steps 0, 4c, 7, 8, 10. Output: role-framed instrument only (Meeting Prep or Demo Prep) — no analytical sections, no citations block, no devil's advocate. Target: <60 seconds, fits one screen. |
| `--no-citations` | Skip citation enforcement and auto-research. Step 7 does not auto-run `/download`; accuracy score is not capped; un-cited claims stay in the main report. For speed or when working offline. Inverse of `--require-citations`. |

## What actually gets asked (the speed-up rules)

The first naked `/focus-group` invocation in a fresh workspace asks 4
short questions (Steps 1, 2, 3-as-needed, 4-as-needed). After that,
**every step except Step 2 (subject) is skipped when its answer is
already cached.** Concretely:

| Step | First run | Second run+ |
|------|-----------|-------------|
| 0 — Tooling probe | runs (1–3 s) | **skipped** (cached for 24 h) |
| 1 — Your role | asked | **skipped** (if you saved it) |
| 2 — Subject (what to review) | asked | asked (different content each time) |
| 3 — Product/industry packs | asked if no default | **skipped** (uses last pick or `--product` switch) |
| 4 — Customer-grounding gate | asked | **skipped** (if profile is on file and < 14 days old) |
| 5 — Panel approval | asked | asked (but the suggestion benefits from the cached context) |

A second invocation usually shows just **2 questions** (subject +
panel approval), and the first invocation never runs Step 0 again that
day. Detection cache invalidates immediately on any failed CLI/MCP call,
so removing a tool is picked up the next time the skill tries to use it.

Under `--quick`: only Steps 1 (if unsaved), 2, and 5 run. Steps 0, 3, 4c, 7, 8, 10 are skipped. Step 9 runs with 3 personas only. Step 9.5 is the primary output gate. Step 12 presents the role-framed instrument only.

## The 12-step pipeline

### Step 0 — Tooling preflight (cached)
Skip under `--single-ai`. Probe which CLIs and integrations are available:
`claude`, `codex`, `gemini`, `opencode`, `sf` (Salesforce CLI), Salesforce MCP,
Slack MCP, and the **`/anonymize` runtime** (Python 3 / Node.js / PowerShell —
any one is sufficient; see [`/anonymize`](../anonymize/SKILL.md) for the
four-runtime chain). Record findings; do **not** prompt for installs here —
install offers fire at the moment of concrete value (Step 4c, §8 of
[references/usage.md](references/usage.md), or — for the anonymize runtime —
the Step 8 pre-dispatch gate). Details: [references/tooling-preflight.md](references/tooling-preflight.md).

**Detection cache (load-bearing for speed).** Probing CLIs and MCP
servers can take 1–3 seconds; doing it on every invocation makes the
naked `/focus-group` feel slow after the first one. Cache the result:

- **Cache file:** `.focus-group-cache.json` (next to `config.json` in
  the skill folder). JSON shape:
  ```json
  {
    "version": 1,
    "detected_at": "2026-05-21T14:32:11Z",
    "clis": {
      "claude":   { "available": true,  "path": "C:\\nvm4w\\nodejs\\claude.cmd" },
      "codex":    { "available": true,  "path": "C:\\nvm4w\\nodejs\\codex.cmd" },
      "gemini":   { "available": true,  "path": "C:\\nvm4w\\nodejs\\gemini.cmd" },
      "opencode": { "available": false, "path": null }
    },
    "integrations": {
      "sf":             { "available": true,  "orgs_connected": 2 },
      "salesforce_mcp": { "available": false, "server_name": null },
      "slack_mcp":      { "available": true,  "server_name": "slack" }
    },
    "anonymize_runtime": {
      "available": true,
      "preferred":  "python",
      "candidates": ["python", "node", "powershell", "shell"],
      "degraded":   false
    }
  }
  ```

The `anonymize_runtime` block records the result of running
`detect-runtime.sh` / `detect-runtime.ps1` from the `/anonymize` skill.
`preferred` is the chosen runtime; `degraded: true` means only `powershell`
or `shell` are available (regex-only mode, no L3 heuristic — callers
must pass `--scrub <name>` for every entity name not caught by regex).
The Step 8 pre-dispatch gate reads this entry directly.
- **Read on every run.** If the cache exists and `detected_at` is less
  than **24 hours old**, skip the actual probe entirely and use the
  cached availability map. The 24-hour window catches new installs
  reasonably quickly without re-probing every minute.
- **Invalidate on failure (load-bearing).** When the skill (or any
  sibling skill) actually *invokes* a cached-available CLI/MCP and it
  fails with "not found" / "command not found" / equivalent, mark that
  entry `available: false` in the cache immediately and update
  `detected_at`. The next run still trusts the rest of the cache but
  knows the dead tool is gone — no full re-probe needed.
- **Force re-probe** with `/focus-group config probe` or
  `/focus-group --probe`. Useful right after the user installs a new
  CLI and wants it picked up immediately.

If **no CLI other than `claude`** is found (per cache or fresh probe),
the skill silently configures the multi-Claude fallback (Opus + Sonnet)
via `cross_ai.py` so the panel still gets cross-model diversity.

### Step 1 — Your role (asked once, saved with consent)
**Always ask this first** when invoked with no parameters in a
fresh workspace — before content, before product/industry, before
customer profile. Your role shapes how every persona's feedback gets
framed in the final report:

- Account Executive (AE) → emphasis on deal cycle, MEDDPICC framing, talk tracks
- Solution Engineer (SE) → emphasis on demo-ability, feasibility, governor-limit risk
- Industry Specialist → emphasis on vertical fit and regulatory landscape
- Enterprise / Technical Architect → emphasis on multi-cloud sequencing, integration patterns
- Business Value Consultant (BVC) → emphasis on ROI, TCO, business-case narrative
- Lead Engagement / SDR coach → emphasis on discovery rigor, objection handling
- Customer Success Manager → emphasis on adoption, value realization, renewal risk
- Partner Account Manager → emphasis on co-sell, partner economics, channel fit
- Other → ask the user to describe their role in one sentence

**Use a two-tab `AskUserQuestion` flow:**

- **Tab 1 — "Your role":** the 9 role options above.
- **Tab 2 — "Save for next time?":** ask whether to persist the role
  to `config.json` so future invocations skip this step entirely.
  Options:
  - **Yes, remember for future runs** (default; writes
    `user_role: "<slug>"` to `config.json`)
  - **Just for this run** (uses the role for this invocation only;
    nothing written to disk)

Once saved, subsequent runs skip Step 1 entirely. Clear with
`/focus-group config clear user-role` (re-runs Step 1 next invocation).
Override per run with `--role <slug>` regardless of what's saved.

**Why ask before saving:** the user owns what gets persisted to their
config. Some users want a quick one-off without a sticky default
(maybe they're helping a colleague on a different role's deal).
Asking the consent question takes one second and respects that.

The skill uses this for two things:
1. **Final report framing** — the synthesis is written in the language
   the user actually uses on the job (an AE gets "talk tracks"; an SE
   gets "demo-flow gotchas"; an Architect gets "estate impact").
2. **Persona-recommendation bias** — the recommender weights toward
   the personas most useful to this role (an AE benefits more from the
   Champion + Economic Buyer + Industry Specialist; an SE benefits more
   from the Technical Architect + Security Reviewer + Beta Tester).

### Step 2 — Identify content under review
The content can be a file path, a paste, a URL, or a description ("our pitch
for Acme"). If a URL, note it for Step 7.

**LinkedIn URL detection (special case, fires before Step 6 routing).**
If the prompt or any referenced URL matches
`(https?://)?(www\.)?linkedin\.com/(in|company|pub)/...`, do NOT route it
to `/download` and do NOT attempt to scrape it. LinkedIn aggressively
blocks automated scrapers — the page will come back as an empty shell or
a sign-in wall, which produces persona feedback that is *worse* than
having no data at all (the panel will hallucinate to fill the void).
Instead, surface this workaround in one user-facing block:

> *That URL is a LinkedIn profile. LinkedIn blocks scrapers, so fetching
> it would return an empty page and the panel would invent facts to fill
> the gap.*
>
> *A reliable workaround takes about 2 minutes per profile:*
>
> 1. *Open the LinkedIn profile in your browser.*
> 2. *Either copy the visible text (Cmd-A / Ctrl-A, then Cmd-C / Ctrl-C)
>    and paste it into a local file, OR use LinkedIn's "Save to PDF"
>    option from the More menu.*
> 3. *Save it to a local folder you'll point me at — e.g.,
>    `attendees/<role-or-initials>.md` or `attendees/<role>.pdf`.*
>
> *Repeat for each attendee you want represented. Then re-run
> `/focus-group <topic> --attendees attendees/` and I'll read the local
> files, build personas grounded in real attendees, and run everything
> through `/anonymize` before any LLM sees a name.*

After surfacing the workaround, ask the user: do they want to (a) pause
here while they prepare the files, (b) continue without
LinkedIn-derived grounding, or (c) abort.

**Same rule applies to any URL `/download` would clearly fail to render
meaningfully** — sign-in walls (Salesforce internal CRM URLs that
require auth, Box / SharePoint links, paywall domains). Surface a
similar "save it locally and point me at it" workaround rather than
producing an empty-shell artifact.

**Other attendee-grounding sources to suggest** (any combination):
- `attendees/` folder with one `.md` or `.pdf` per person (per above).
- A single notes file with attendee sections (headings = names) — the
  skill will parse out attendee blocks.
- Exported VCF / vCard files.
- Pasted text in the prompt (e.g., "here's the LinkedIn for Sarah:
  <paste>").

All of these go through `/anonymize` (per its 4-runtime chain) before
any persona prompt is built.

**Deal-stage inference (when `--stage` is not set):**
Infer the deal stage from the content type to calibrate persona output:
- **Discovery:** content is discovery questions, call prep, qualification notes, or meeting agenda for a first/second call → `--stage discovery`
- **Demo:** content is a pitch deck, demo script, POV plan, solution overview, or architecture spec for customer presentation → `--stage demo`
- **Negotiation:** content is a proposal, SOW, contract redline, pricing sheet, or procurement response → `--stage negotiation`
- **Post-sale:** content is QBR materials, adoption report, renewal prep, or escalation brief → `--stage post-sale`
- **Ambiguous:** if the content doesn't clearly match a stage, default to `demo` (the most common use case) and note the assumption in the report header.

The inferred or explicit stage is passed to every persona via the deal-stage calibration block in [references/persona-output-template.md](references/persona-output-template.md).

### Step 3 — Resolve product/industry packs (mostly cached)
- If `--product` is set, use it. Else use the value cached in
  `config.json` → `last_product_pack` (defaults to
  `salesforce-crm-agentforce` on first run). On a fresh workspace
  ASK the user which pack to use, then cache their choice.
- If `--industry` is set, load it additively. Same caching pattern:
  remember `last_industry_pack` from the previous run.
- If `--generic`, load no packs.
- Read the active pack files and surface their *recommended persona families*
  and *URL seed-lists* to use later.
- Override the cache with `/focus-group config set product <slug>` or
  `/focus-group config set industry <slug>`.

### Step 4 — **Customer-grounding gate (runs before topic research)**

Non-negotiable by default — see [references/org-profile-schema.md](references/org-profile-schema.md). Scan the user's prompt for a named org or explicit cultural/scale signals. If neither is present and no org profile is on file (or it is > 14 days old), stop and ask.

**Q1 — How to profile:**
1. **Profile by name** — name the actual org; the skill grounds research in it (Step 4a).
2. **Profile by culture & size** — 6-field wizard plus optional culture multi-select (Step 4b).
3. **Skip — generic feedback is fine** — proceed without org grounding; report header notes "generic feedback."

**Q2 — Relationship (asked only if Q1 = 1 or 2):**
1. **Current customer** — try `sf` / Salesforce MCP / Slack for live grounding (Step 4c).
2. **Prospect / lead** — stick to public sources via `/download`.
3. **Not sure / mixed** — public sources first; layer in internal data later if confirmed.

#### Step 4a — Profile by name
Say plainly: *"I won't guess facts about [Org Name] from memory — let's ground this."* Offer `/download` against a small public seed-list (the org's About / IR / news / a search like `"<Org Name>" salesforce site:linkedin.com OR site:crunchbase.com`). Propose a profile draft from the harvested artifacts; the user confirms / corrects / fills gaps. Save with `source: "public-web:<org>"` and the source URLs. If Q2 = Current customer, branch to Step 4c.

#### Step 4b — Profile by culture & size
Run the 6-field wizard in [references/org-profile-schema.md](references/org-profile-schema.md): size · Salesforce maturity · tech adoption posture · regulatory environment · decision-making structure · culture (multi-select). Save with `source: "self-described"`.

#### Step 4c — Current customer (high-value internal grounding)
This is the highest-leverage proactive install moment in the skill. If any of `sf`, Salesforce MCP, Slack MCP are missing, present the ranked install menu (see [references/usage.md](references/usage.md) §8). Four-option pattern:
- (a) Walk me through the top one (`sf`) now
- (b) Walk me through all three *(fastest for an established account where IT trusts the user to wire in dev-tool integrations; for a sensitive or politically-watched account, prefer (a) and add the rest one at a time as the customer relationship can absorb each step)*
- (c) Skip for this run; ask me again next time I name a customer
- (d) Skip and don't ask again

**Sensitivity note for the orchestrator.** If the customer profile signals heightened sensitivity — public-sector / federal / DoD, healthcare with PHI, regulated finance, anything with an obvious privacy gradient — soften the (b) option's framing and ask before recommending it. The default ranking still surfaces (a) first; (b) becomes opt-in rather than equally weighted.

For tools that ARE available, present per-data, per-tool consent (see [references/org-profile-schema.md](references/org-profile-schema.md) Step 0c). **Nothing from the raw extraction reaches a model without an explicit user-approved summary step.** Save with `source: "internal:sf+slack:<org>"`.

### Step 5 — Compose & confirm the panel

Three beats (see [references/persona-roster.md](references/persona-roster.md)):

**5a — Detect & recommend.** Consume the active product/industry pack, the org profile, the user's role (from Step 1), the prompt, and any URL `meta.json` files. Propose a panel sized to the org profile (cap at 5; `--everyone` opts into the full set). The recommendation flexes:
- Small nonprofit + Nonprofit Cloud → skip Enterprise Architect; lead with Executive Director, Director of Development, Program Manager.
- Fortune 100 bank + Financial Services → lead with Enterprise Architect, FINRA-aware InfoSec Officer, CIO Economic Buyer.

**Deliberative-spread enforcement (mandatory).** After composing the recommended panel, verify it against the 4-axis model in [references/deliberation.md](references/deliberation.md):
- **At least one structural dissenter** must be present in any panel of 3+. Structural dissenters are personas whose `## Deliberative profile` includes low ambiguity-tolerance + conservative risk orientation (e.g., InfoSec Officer, Compliance Officer, Procurement).
- **Spread on ambiguity-tolerance axis:** the panel must not be uniformly low OR uniformly high. If it is, swap one persona for a counterweight (e.g., swap a second conservative-analytical seat for a progressive-challenger or moderate-collaborative one).
- **Spread on locus-of-control axis:** at least one internal-locus persona (owns the outcome) and one external-locus persona (subject to forces outside their control) should be represented.
- **If the panel is deliberatively homogeneous** after applying the above checks, **prepend a warning to the panel preview**: *"⚠ Deliberative spread: this panel clusters on [axis]. Consider swapping [persona] for [suggestion] to catch what uniform [trait] panels miss."* The user can override, but they see the tradeoff.

**Empty industry persona pool guard.** Before composing, check whether the active industry pack's `personas/industries/<slug>/` directory has any `.md` files. If the directory is empty (or contains only `.gitkeep`), the composer must fall back to operations-leaning generics (generic-technical, generic-stakeholder, plus the appropriate Salesforce-side seats) AND **prepend a visible notice to the panel preview**: *"⚠ The `<slug>` industry persona pool is currently empty. I'm using operations-leaning generics — treat this report as directionally useful but not industry-deep. (See [references/industry-packs/](references/industry-packs/) for which packs ship which personas.)"* Never silently substitute generics for a missing industry roster; the notice converts silent degradation into honest scaffolding.

**Sub-vertical / product-pack alignment advisor.** When the customer-type classifier routes to a specific sub-vertical and the pack ships a sub-vertical-conditioned `## Recommended product-pack pairings` block (e.g., `### For renewables developer / IPP`), compare the recommended stack to the product packs the user actually named (or that the prompt strongly implies). When they differ in load-bearing ways — packs the user named that the sub-vertical's recommended stack omits, OR packs the user omitted that the sub-vertical's stack treats as required — **prepend a visible advisory to the panel preview**: *"⚠ Sub-vertical alignment: your customer routed to **<sub-vertical>** in the **<pack>** pack. The pack's recommended stack for this sub-vertical is **<A, B, C>**. Packs you named that aren't load-bearing here: **<X, Y>** — consider carving them from the bundle, or be explicit about why they're in scope. Packs the sub-vertical typically expects that you didn't name: **<Z>**."* This surfaces the "selling IOU-default Field Service to an IPP" mistake before dispatch instead of waiting for the panel to point it out. Skip when the pack has no sub-vertical-conditioned pairings block, or when the user's stack matches the recommendation.

**5b — Menu (`AskUserQuestion` or numbered prompt).** Pre-check the recommended personas; allow add / swap / drop / quick-pick (Buyer · Tech · Discovery · Demo Readiness · Architecture Review · Industry Deep-Dive · Everyone).

**5c — Confirm & lock.** Show the final panel; ask "Run it? yes / change". Include in the preview:
- **Routing decision** in plain language — e.g., *"Routed to: Payer sub-vertical (matched: 'health plan' + 'member' + 'prior auth' signals)"* — so the user can catch a misclassification before dispatch. Show the active classifier's sub-vertical pick plus the top 2-3 signals that triggered it.
- **Sub-profile selections** — which persona loaded which sub-profile (e.g., *"Capital Markets Director → PE-RE fund acquisitions principal"*) so the user can see whether the layering matched the customer.
- **Cross-pack persona pulls** — when the recommender pulled a persona from a different industry pack (e.g., cross-loading `guest-loyalty-lead` from hotels-hospitality into an airlines panel), name the source pack and why.

### Step 6 — Choose mode
Stakeholder (sign-off lens) or Audience (reception lens). Defaults from [references/persona-roster.md](references/persona-roster.md); flip when the purpose differs.

### Step 7 — Topic research (auto-run with consent)
**Default behavior:** When the user approved web research at Step 4 (chose "Profile by name" or "Profile by culture & size" with relationship = prospect/lead), `/download` runs automatically for any in-scope URLs not yet in `references/<slug>/`. No additional prompt needed — Step 4 consent covers it.

**Consent-gated exceptions:**
- If Step 4 Q1 = "Skip — generic feedback is fine" → do NOT auto-run `/download`. Offer it as an option only.
- If `--no-citations` is set → skip `/download` entirely.
- If the customer profile signals heightened sensitivity (public-sector, healthcare with PHI, regulated finance) → ask before each URL rather than batch-auto.
- LinkedIn / sign-in-wall / paywall URLs → respect the Step 2 short-circuit rules (never fetch; suggest local-save workaround).

**Failure is non-blocking.** If `/download` finds nothing or fails for any URL, note the gap in the report header and proceed. The accuracy rubric's citation-density factor will reflect the missing sources.

Apply [references/deliberation.md](references/deliberation.md) Duty 6: validate every harvested artifact actually contains the expected content before any persona reads it.

### Step 8 — Distribute panel across models

**Step 8.0 — Anonymize pre-dispatch gate (mandatory; fires before any external CLI call).**

This gate runs **before** round-robin distribution and is non-skippable
when any of the following are true:

- the active org profile has `source: "internal:..."` (any `sf` / Salesforce MCP / Slack-MCP-derived data),
- the active org profile has `customer_name` set (named org, even from public sources),
- any panel prompt contains content that would match the `/anonymize` patterns (emails, phone numbers, money amounts ≥ 4 digits, ARR/MRR/TCV phrasing, Salesforce org IDs / sandbox aliases, etc. — see [`/anonymize` SKILL.md](../anonymize/SKILL.md)),
- the user passed `--attendees <path>` (attendee profiles always contain personal data).

**Gate logic:**

1. Read `anonymize_runtime.available` from `.focus-group-cache.json`. If
   stale, refresh with the `/anonymize` skill's `detect-runtime.sh` /
   `detect-runtime.ps1`.
2. **If `available: false`** — STOP before any external dispatch. Surface
   the universal install offer ([references/usage.md](references/usage.md) §8 pattern):

   > *I detected customer-grounded content in this panel and no
   > `/anonymize` runtime on this host (Python 3 / Node.js / PowerShell —
   > any one is sufficient). Sending this to external LLMs without
   > anonymization would put identifiable customer data on third-party
   > servers, which the skill's privacy contract refuses to do.*
   >
   > *(a) Walk me through installing Python now (~3 min)*
   > *(b) Walk me through Node.js (~2 min if `node` is already present)*
   > *(c) Run `--single-ai` for this panel — host Claude only, no external dispatch, no anonymize required*
   > *(d) Cancel this run*

   The gate **never silently downgrades to plaintext dispatch**. The
   user must pick one of (a)–(d). Picking (c) flips the run to
   `--single-ai` and continues; (d) aborts cleanly.

3. **If `available: true` and `degraded: true`** (POSIX shell or
   PowerShell — regex-only mode, no L3 heuristic), the orchestrator
   MUST pass `--scrub <name>` for every entity name it knows from the
   org profile (customer name, contact names from `internal_data`,
   org alias, Slack channel names) before calling `anonymize.py scrub`.
   Surface a one-line note: *"Anonymize is in degraded mode (regex only).
   I'm passing the N entity names I know about as `--scrub` overrides."*

4. **If `available: true` and `degraded: false`** (Python or Node.js,
   full L1+L2+L3 detection), proceed normally — the library handles
   detection.

5. Every panel prompt destined for `codex`, `gemini`, `opencode`, or any
   second-process Claude (`claude -p --model ...` for the multi-Claude
   fallback, plus `cross_ai.py` dispatches in Stage B) **must pass through
   `anonymize.scrub()` immediately before the dispatch call.** Local
   `Agent`-tool subagent dispatches on the host Claude do NOT require the
   scrub (the host model already has all the context the user authorized).

6. The orchestrator records the gate decision (`pass` / `degraded` /
   `single-ai-fallback` / `aborted`) in the report header line:
   `**Anonymize:** pass (python) | degraded (powershell) | single-ai-fallback | n/a (generic, no customer data)`.

**Then — Step 8.1 — Distribute.** Round-robin across available channels
(Claude, Codex, Gemini, opencode). If only Claude is available, use the
multi-Claude fallback (Opus + Sonnet). Quota-skip → reassign to the next
channel. See [references/multi-model-panel.md](references/multi-model-panel.md).

**`--single-ai` skips Step 8.0 entirely** — no external dispatch happens,
so no anonymize gate is needed. The host Claude is the only model in scope.

**`--no-anonymize` is not an officially supported switch.** If a caller
sets it (or a user types it), surface the warning in [`/anonymize` SKILL.md
"Safety rules" §3](../anonymize/SKILL.md) and require an explicit
"yes, send identifiable data" confirm before continuing.

### Step 9 — Stage A: aggregate
Claude (latest) aggregates persona feedback into the **Recommendations Report** per [references/output-format.md](references/output-format.md). **Frame the report for the user's role** (Step 1) — an Account Executive gets talk tracks and discovery-question revisions; a Solution Engineer gets demo-flow gotchas and feasibility flags; an Architect gets estate-impact and integration-sequencing notes; a Business Value Consultant gets ROI math and value-hypothesis language. Every persona's response follows the mandatory structure in [references/persona-output-template.md](references/persona-output-template.md). The aggregation step reads these structured responses and composes the role-framed instrument (Meeting Prep / Demo Prep / Architecture Review / Value Case) per [references/output-format.md](references/output-format.md) — role-framed instrument FIRST, then analytical Deep Analysis sections. Apply the anti-groupthink duties in [references/deliberation.md](references/deliberation.md): independent-derivation test, preserve dissent, Abilene check, devil's-advocate the verdict.

### Step 9.5 — "So What?" Transformation (the actionability gate)

Before consolidation, apply the actionability filter to every finding from Stage A. For each item in the aggregated persona feedback, answer one question: **"What should the user (in their stated role from Step 1) do differently in their next customer interaction because of this?"**

- If the answer is a **specific action** (change a slide, prepare a response, demo a feature, ask a question, flag a risk to deal desk) → the item stays in the role-framed instrument (Meeting Prep / Demo Prep / Architecture Review / etc.).
- If the answer is **"nothing — this is background context"** → the item moves to the Deep Analysis appendix (Consensus, Disagreement, or Blind Spots sections).
- If the answer is **"I'm not sure"** → the item goes to Deep Analysis with a note: "May be actionable with more context."

This gate ensures the top-level output contains ONLY directly actionable material. The user reads the instrument section and knows exactly what to do. Background context is preserved but doesn't clutter the primary output.

**Stage-aware specificity check.** Every action item that passes the "specific action" test must ALSO pass a specificity check calibrated to the active deal stage:

| Stage | Required fields | Acceptable "BY WHEN" |
|-------|----------------|---------------------|
| **Discovery** | WHO + WHAT | "next call" / "before discovery meeting" is fine |
| **Demo / Mid** | WHO + WHAT + WHAT-TO-SHOW (the specific demo moment, slide, or proof point) | "before the demo" / "during POV setup" |
| **Negotiation** | WHO + WHAT + BY WHEN + HOW TO VERIFY (what confirms it's done) | Concrete: "before SOW review," "by procurement deadline" |
| **Post-sale** | WHO + WHAT + METRIC TO WATCH (the number that proves value) | "by next QBR" / "within 30 days" |

Items that fail the stage-appropriate specificity check are **rewritten** by the synthesis (adding the missing fields from context) or **demoted** to Deep Analysis if the missing information genuinely isn't available. The rewrite is preferred — demoting should be rare.

**Under `--quick` / `--fast`:** Stage A.5 is mandatory (it IS the output filter). Only items that pass both the "specific action" test AND the specificity check appear. Everything else is dropped entirely (no Deep Analysis appendix in quick mode).

**Persona output template dependency:** Stage A.5 reads the structured persona output per [references/persona-output-template.md](references/persona-output-template.md). The "Risk Level" tags (RED/YELLOW/GREEN) and "What Would Change My Mind" fields are the primary inputs to the actionability filter.

### Step 10 — Stage B: consolidate
Submit the Stage-A report to a *different* model than Stage A used (Codex/Gemini/opencode, or the second Claude model if multi-Claude fallback) via `cross_ai.py`. Ask each to consolidate, flag what Stage A over- or under-weighted, and produce a deduplicated action-item list. Skip under `--single-ai`. If all channels quota-fail, skip and note.

### Step 11 — Stage C: merge + accuracy score + citations
Merge Stage B with Stage A. Where they agree → high confidence. Where they disagree → surface, judge, decide (do not vote-count). Where Stage B caught something missed → add it, attributed. Compute the accuracy score per [references/accuracy-rubric.md](references/accuracy-rubric.md). Attach the citations block from all `references/<slug>/meta.json` files used.

Under `--require-citations`, move under-cited claims to a "Needs verification" section and cap the accuracy score at 70 until the gap is closed.

Under `--no-citations`, skip citation enforcement entirely: do not cap accuracy, do not move claims to "Needs verification," do not reference missing citations in the report. The accuracy rubric's citation-density factor scores 0 (no penalty, no bonus).

### Step 12 — Present & save
Present to the user. Save to `.scratch/focus-group/<YYYY-MM-DD>-<short-slug>.md`.

## Errors and failures

Apply the err-lite doctrine in [references/err-doctrine.md](references/err-doctrine.md): name the cause in one plain-English sentence, say what was done without the failing piece, and offer 1–2 concrete next steps. Never paste a raw stack trace at the user. End with *"If you'd like, paste the screen you see and I'll translate it."*

## Model resolution — per channel, in precedence order

1. A per-invocation `--<channel>-model` switch, if given.
2. Else the saved default in `config.json` → `channel_models.<channel>`.
3. `channel_models` ships **concrete model ids** kept fresh by the freshness gate below. A concrete id is **pinned**: pass it to `cross_ai.py` via its matching `--<channel>-model` flag. The sentinels `"deep"`, `"default"`, and `null` mean *let `cross_ai.py` deep mode pick the CLI's deepest model* — pass nothing.

### Model freshness gate (≈monthly)

On every `/focus-group` run (and on `/focus-group config`; skip under `--single-ai`), read `last_model_check` from `config.json`:

- **< ~30 days ago** → do nothing, proceed.
- **≥ 30 days ago, or field absent** → re-infer each CLI's latest model per `config.json` `_policy`. Compare to `channel_models`:
  - All current → set `last_model_check` to today; proceed silently.
  - A newer model exists for any channel → ask the user once (single `AskUserQuestion`) showing each drifted channel as *configured → newest available*. On approval, write the new id(s). Either way, set `last_model_check` to today, then proceed.

The gate **never blocks the panel.** If a check cannot complete (no API key, offline, file missing), note it, leave `channel_models` unchanged, do not restamp `last_model_check`, then proceed.

## Sibling skills the pipeline calls

- **`/anonymize`** (`.claude/skills/anonymize/SKILL.md`) — every prompt that
  reaches an external LLM passes through anonymize first. Bidirectional
  placeholders (`{{COMPANY_1}}`, `{{PERSON_2_ROLE=CISO}}`, etc.) preserve
  reasoning precision; the local map.json restores real values when the
  response comes back. Required when grounding includes customer data;
  blocking when no anonymize runtime is available (the skill surfaces the
  install offer rather than send identifiable data to LLMs).
- **`/slackbot`** (`.claude/skills/slackbot/SKILL.md`) — Step 4c (current
  customer) calls `/slackbot` to surface deal-channel conversations and
  customer mentions in channels the user belongs to. The output is fed
  through `/anonymize` before any persona prompt sees it.
- **`/download`** (`.claude/skills/download/SKILL.md`) — Step 7 calls
  `/download` for public-source grounding (prospect customer websites,
  IR pages, Salesforce help/Trailhead docs). LinkedIn URLs are
  short-circuited per the `/download` Safety Rule.
- **`/cross-ai-review`** (`.claude/skills/cross-ai-review/SKILL.md`) —
  Stage B (consolidation) calls `cross_ai.py` to dispatch the Stage-A
  report to a second model. Also provides the multi-Claude fallback
  when only the Claude CLI is available.
- **`/make-this-mine`** (`.claude/skills/make-this-mine/SKILL.md`) —
  guided personalization interview. Writes to this skill's `config.json`
  (keys: `role_elaboration`, `deal_types`, `excluded_noise`,
  `preferred_panel_size`, `default_stage`). The pipeline reads these at:
  Step 1 (role enrichment), Step 2 (stage tiebreaker), Step 5a (panel
  sizing and bias), Step 9.5 (noise demotion).

## References

- [references/usage.md](references/usage.md) — the user-facing walkthrough (`/focus-group help`)
- [references/persona-roster.md](references/persona-roster.md) — full persona library + quick-pick panels
- [references/product-packs/](references/product-packs/) — one file per Salesforce product pack
- [references/industry-packs/](references/industry-packs/) — one file per Salesforce industry pack
- [references/org-profile-schema.md](references/org-profile-schema.md) — the customer-grounding gate, wizard, and internal-data consent flow
- [references/deliberation.md](references/deliberation.md) — cognitive diversity and anti-groupthink
- [references/multi-model-panel.md](references/multi-model-panel.md) — channel discovery and multi-Claude fallback
- [references/output-format.md](references/output-format.md) — the report template
- [references/accuracy-rubric.md](references/accuracy-rubric.md) — how the 0–100 score is computed
- [references/err-doctrine.md](references/err-doctrine.md) — error handling voice and patterns
- [references/tooling-preflight.md](references/tooling-preflight.md) — Step 0 probe details
