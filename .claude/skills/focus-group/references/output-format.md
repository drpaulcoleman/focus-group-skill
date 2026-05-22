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
**Accuracy:**       NN/100 — <one-line summary>
**Date:**           YYYY-MM-DD
```

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

## Body sections — in this order

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

### Action items (ordered)
A numbered list of concrete next steps, ranked by leverage. Each item:
- One imperative sentence.
- Owner (when obvious from the org profile).
- A confidence tag drawn from the accuracy rubric.

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
