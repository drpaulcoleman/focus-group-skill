# Output Format — The Final Recommendations Report Template

Stage A (aggregate), Stage B (consolidate), and Stage C (merge) all produce
text. Stage C's output is what the user actually sees, and it's saved to
`.scratch/focus-group/<YYYY-MM-DD>-<short-slug>.md`. This file defines that
template.

## Header

```
# /focus-group — <one-line topic>

**Panel:**          <persona1 (channel/model)> · <persona2 (channel/model)> · ...
**Modes:**          Stakeholder | Audience (per persona)
**Models that ran:** <list>
**Models skipped:** <list with reason: quota / missing / timeout / error>
**Grounding:**      product=<pack> · industry=<pack | none> · org-profile=<source>
**Anonymize:**      pass (<runtime>) | degraded (<runtime>) | single-ai-fallback | n/a (generic, no customer data)
**Sensitivity:**    low | medium | high | highest — <one-line "where can this report go?" summary>
**Accuracy:**       NN/100 — <one-line summary>
**Date:**           YYYY-MM-DD
```

The **Sensitivity** field follows the rubric in
[`privacy-model.md`](privacy-model.md#sharing-rules--where-can-a-report-go).
Quick map:

- `--generic` (no customer profile) → **low**
- Profile by culture & size, no `internal_data` → **medium**
- Profile by name (public sources only) → **medium-high**
- Profile by name with `internal_data` (sf / Salesforce MCP / Slack) → **high**
- Any of the above + heightened-sensitivity industry (public sector,
  HIPAA-regulated healthcare, regulated finance) → bump one level →
  often **highest**

The one-line summary should name the most-restrictive sharing rule that
applies — e.g., *"high — account team only; never in a Slack Connect
channel that includes the customer."*

When grounding includes a named customer, also include:
```
**Customer:**       <Name> — sources: <url> (retrieved YYYY-MM-DD), ...
```

When `--require-citations` was passed:
```
**Citation mode:**  Strict — N claims moved to "Needs verification"
```

When the multi-Claude fallback was in effect:
```
**Fallback:**       Multi-Claude (Opus + Sonnet) — single-vendor agreement,
                    confidence dampened by 0.7 in the rubric
```

## Role-Framed Instrument (top of report — before analytical sections)

The first thing the user sees is a directly actionable section framed for their
role (from Step 1). The analytical sections follow as "Deep Analysis" for
reference. This section is the **primary output** — the rest is supporting evidence.

### When role = AE (Account Executive)

```
## Your Meeting Prep

### Talk Tracks (ready to use)
1. [Opening hook — one sentence drawn from panel consensus the AE can open with]
2. [Economic buyer reframe — addresses their #1 concern in their language]
3. [Competitive positioning — what to say when the competitor comes up, drawn from
   product pack competitive triggers]

### Objections You'll Hear (and responses)
| Objection (in customer words) | Your Response | Evidence/Demo Point |
|------|------|------|
| "[verbatim from persona 'What I'd Say']" | "[suggested response using 'What Would Change My Mind']" | [citation or feature] |
| ... | ... | ... |

### MEDDPICC Gaps This Surfaces
- **M (Metrics):** [what the panel revealed about unmeasured value — or confirmation]
- **E (Economic Buyer):** [gap in access/alignment — or confirmation]
- **D (Decision Criteria):** [criteria the panel surfaced that weren't in the pitch]
- **D (Decision Process):** [process steps the panel identified — procurement, legal, board]
- **I (Identified Pain):** [pain the content addresses vs. pain it misses]
- **C (Champion):** [what your champion needs from you to sell internally]
- **C (Competition):** [competitive exposure the panel identified]

### Red Flags (handle before the meeting)
[Only RED-level items from persona Risk Levels, with the specific resolution
from "What Would Change My Mind." If none, say "None — panel gave green light."]
```

### When role = SE (Solution Engineer)

```
## Your Demo Prep

### Demo Script Changes
1. [Specific slide/flow to modify — what to show instead, drawn from persona feedback]
2. [Sharing model / governor limit / integration concern to address live in the demo]
3. [Data Cloud or platform dependency to surface early — don't let it ambush in scoping]

### Technical Objections You'll Face (and live responses)
| Objection (from admin/architect) | What to Show in the Org | What NOT to Say |
|------|------|------|
| "[verbatim from technical persona 'What I'd Say']" | [specific config/feature to demo] | [the claim that would lose credibility] |
| ... | ... | ... |

### Post-Demo Landmines
- [Thing 1 that looks fine in demo but breaks in production — sharing model at scale, governor limit under load, integration timeout, etc.]
- [Thing 2...]

### What the Admin Will Google After
- [Term/feature 1 the technical buyer will verify — ensure your demo supports it]
- [Term/feature 2...]
- [Term/feature 3...]
```

### When role = enterprise-architect or technical-architect

```
## Your Architecture Review

### Integration Sequencing
1. [System 1 integration — order, pattern, risk, from persona feedback]
2. [System 2 integration — ...]

### Technical Risks (by severity)
| Risk | Severity | Mitigation | Owner |
|------|----------|-----------|-------|
| [from persona feedback] | RED/YELLOW/GREEN | [from "What Would Change My Mind"] | [role] |

### Platform Constraints to Validate
- [Governor limit / sharing model / data volume concern — with specific numbers]
- [...]

### Estate Impact
- [What changes in the customer's existing Salesforce footprint]
- [What changes in adjacent systems]
```

### When role = industry-specialist

```
## Your Industry Positioning

### Regulatory Alignment
- [Regulation 1]: [How the content aligns or conflicts — specific section/clause]
- [Regulation 2]: ...

### Industry-Specific Objections
| Stakeholder | Their Concern | Industry Context | Resolution |
|------|------|------|------|
| [role from industry pack] | [verbatim] | [why this matters in THIS industry] | [specific] |

### Peer References to Cite
- [Similar org in this industry that solved this — if known from grounding]
- [Industry trend that supports or challenges the approach]
```

### When role = bvc (Business Value Consultant)

```
## Your Value Case

### ROI Assumptions to Validate
| Assumption | Current Basis | Risk | How to Verify |
|------|------|------|------|
| [from persona feedback] | [source] | [what breaks it] | [specific validation step] |

### Value Narrative Gaps
- [Gap 1 — what the content claims vs. what the panel challenged]
- [Gap 2 — ...]

### TCO Considerations Surfaced
- [Hidden cost 1 the panel identified]
- [Hidden cost 2...]
```

### When role = other (csm, lead-engagement, partner-am, or custom)

Use the AE format as the default frame, adjusted for the role's vocabulary in
the header ("Your Prep" instead of "Your Meeting Prep").

## Deep Analysis (supporting evidence — after the role-framed instrument)

The following sections provide the analytical backing for the role-framed
instrument above. They are reference material — the user may read them for
depth but the primary output is the instrument section.

### Consensus
Where the responding models / personas agree. **Each consensus point names
the personas that reached it independently** and confirms they got there
via different reasoning paths (per the independent-derivation test in
[deliberation.md](deliberation.md)). Identical reasoning across personas is
flagged as a possible house-view artifact, not robust consensus.

### Disagreement
Where the panel splits. For each disagreement:
- Name the personas / models on each side.
- State the strongest case for each.
- Give the synthesis's read of which side is better supported, and why.
- Do **not** vote-count.

### Dissent spotlight
Every minority view and lone serious flag gets its own line here. Never
let weight-of-numbers bury a dissent. *A lone persona spotting a fatal
flaw outranks four personas admiring colors.*

### Blind spots & risks raised
What the panel surfaced as risks the original content didn't address.

### Combined verdict
The synthesis's recommendation. Per the Abilene check in
[deliberation.md](deliberation.md): every endorsed verdict line **names
the persona that argued for it with conviction**. If no persona did,
either cut the line or label it as the orchestrator's own inference, not
a panel finding.

### Action Items (confidence-weighted)

A table of concrete next steps, ranked by leverage and tagged with confidence:

| # | Action | Confidence | Source Personas | Time to Prep |
|---|--------|-----------|-----------------|-------------|
| 1 | [imperative sentence] | HIGH / MEDIUM / LOW | [persona names that drove this] | [realistic time estimate] |
| 2 | ... | ... | ... | ... |

**Confidence levels:**
- **HIGH** — 2+ personas agreed independently (cross-model if available);
  platform-verified where applicable. Invest prep time here.
- **MEDIUM** — 1 persona with conviction, or 2 personas with weak signal.
  Worth addressing if time permits.
- **LOW** — Orchestrator inference or lone weak signal. Flag for later; don't
  spend prep time on it before the next interaction.

**Time to Prep** — realistic estimate of how long the action takes. Helps the
AE/SE decide what fits before Thursday's call vs. what waits for next week.

### Needs verification *(present only under `--require-citations`)*
Claims that scored well otherwise but lack a `references/<slug>/meta.json`
source. Each entry suggests a `/download` target that would close the gap.

### Where the panel was weak
Honest acknowledgment of:
- Personas that didn't bring their distinct lens (got absorbed into the
  consensus).
- Channels that were skipped and what coverage that cost.
- Org-profile gaps that limited the depth of feedback.

### Devil's advocate
The strongest honest case **against** the combined verdict. If the
synthesis cannot construct one, the panel was too homogeneous and the
synthesis must say so explicitly.

### Citations
Every `references/<slug>/meta.json` used by any persona, in APA-style:
```
[1] <Source title>. (YYYY, Month D). Retrieved Month D, YYYY, from <URL>
[2] ...
```

If the workspace had no `references/`, this section says so plainly:
> *No citations on file. The accuracy score reflects this (citation
> density = 0). To strengthen the next run, ask `/download <url-or-topic>`
> first.*

## Footer

```
---
**How to iterate this:**
- Re-run with a different panel: `/focus-group <topic> --personas "include CISO, drop CMO"`
- Re-run grounded against an industry pack: `/focus-group <topic> --industry healthcare-life-sciences`
- Strict citation mode: `/focus-group <topic> --require-citations`
- Force a fresh org profile: `/focus-group <topic> --org-profile`

Saved to: .scratch/focus-group/<YYYY-MM-DD>-<short-slug>.md
```

## What the report is NOT

- **Not a sales deck.** No marketing language, no buzzword bingo. The
  synthesis is for the AE/SE to read and decide what to do — not to paste
  into a customer email.
- **Not an absolute truth claim.** The Accuracy score is an *internal
  confidence* estimate. Treat it as a sanity check, not a verdict.
- **Not a substitute for live customer conversation.** Even with internal
  grounding from `sf` and Slack, the panel is reasoning from artifacts.
  The customer in the room can still surprise everyone.
