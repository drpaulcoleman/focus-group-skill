# Accuracy Rubric (0–100)

The Accuracy score reported by `/focus-group` Stage C and `/cross-ai-review`'s
synthesis is an **estimate of internal confidence** in the panel/review's
output — not a truth claim. It exists so the user can see at a glance
whether to ship the recommendation as-is, double-check it, or run more
grounding before sending it to a customer.

The report header always says so explicitly:
> *Accuracy: 82/100 — an internal-confidence estimate based on coverage,
> agreement, citations, and hedging. This is not a truth check.*

## The six factors

| Factor | Weight | How we score |
|--------|--------|--------------|
| **Channel coverage** | 20 | `(responding_channels / available_channels) × 20`. With multi-Claude fallback, two responding Claude models count as 2-of-2 (so coverage is 20), but the report notes this is single-vendor and the agreement weight is dampened in factor 2. |
| **Inter-model agreement on factual claims** | 25 | For each factual claim in the output: 3+ channels agree → 1.0; 2-of-3 → 0.66; lone claim → 0.33. Average × 25. Multi-Claude (same vendor) agreement is multiplied by 0.7 before averaging — same architecture, weaker signal. |
| **Citation density** | 15 | `(claims_backed_by_meta_json / total_factual_claims) × 15`. A `references/<slug>/meta.json` from `/download` counts; an inline URL the model invented does not. |
| **Hedging / uncertainty calibration** | 10 | Reward appropriate hedging on under-cited claims ("according to the customer's public IR page, ..."); penalize confident assertions on under-cited claims. Spot-check 5 claims; each scores 0–2. |
| **Anti-hallucination cross-check** | 10 | Spot-check 3 claims against their cited sources. Pass → 10. Any one fails → 0 (and the failed claim is flagged in the report). |
| **Platform-fact verification** | 20 | For each claim about Salesforce platform behavior (governor limits, pricing, feature GA status, sharing-model behavior, API limits, data-volume thresholds), verify against the active product pack's `## Platform Facts` section. **Claims that contradict the pack** → flagged and corrected in the report, scored 0. **Claims the pack confirms** with a non-TODO row → scored 1.0. **Claims that land on a TODO-stub row** (the pack lists the topic but has not been verified) → scored **0.5** and the report flags the claim as "unverified — check current Salesforce help / release notes before quoting to a customer." **Claims the pack doesn't cover at all** (no row, even as stub) → scored 0.25 and marked "off-pack — verify against current docs." Average × 20. If no platform claims exist in the output, score the full 20 (no risk of misinformation). See "TODO-stub scoring rationale" below for why stubs receive half-credit instead of zero. |

Total: 0–100. Reported as `Accuracy: NN/100 — <one-line summary of where the
points came from and where they did not>`.

## Platform-fact verification — details

This factor prevents AEs and SEs from quoting incorrect platform behavior to
customers. The accuracy score should reflect whether the report's claims about
Salesforce would survive a customer's admin Googling them.

**What counts as a "platform claim":**
- Governor limits (e.g., "50,000 records per DML," "100 SOQL queries per transaction")
- Feature GA status (e.g., "Agentforce is GA," "this feature is in beta/pilot")
- Pricing model statements (e.g., "Data Cloud is separately priced," "conversations are consumption-based")
- Sharing-model behavior (e.g., "private by default," "with sharing runs in user context")
- API and integration limits (e.g., "REST API daily limit," "bulk API batch size")
- Data-volume thresholds (e.g., "Data Cloud supports X events/day")

**What does NOT count:**
- General industry claims ("banks are highly regulated") — validated by citation density
- Persona opinions ("the CIO won't approve this") — validated by deliberative profile authenticity
- Competitive claims ("Dynamics does X") — validated by competitive-trigger sources

**Verification source:** The active product pack's `## Platform Facts` matrix.
All 13 packs in this repo ship a Platform Facts section, with rows that are
either **filled** (verified, citable) or **TODO-stubbed** (named topic, not
yet verified — visible to maintainers as work owed).

A TODO-stub row is **not** a free pass: panel claims that land on a stub
score 0.5 for that claim (half-credit) and the report flags it as
unverified. The remaining pressure to fill stubs is real — full credit
requires a verified, citable row — but the score reflects the actual
risk: an unverified claim *might* be correct, and a panel built on a
pack whose maintainer is behind on stub-filling shouldn't be punished
the same as a panel making a claim that contradicts a verified row.

### TODO-stub scoring rationale

Earlier versions of this rubric scored TODO-stub matches at 0 (full
penalty). That created a perverse incentive: a panel making a *correct*
claim that happened to land on an unfilled stub row would tank the
accuracy headline (e.g., 65/100) the same way a panel making a *wrong*
claim against a verified row would. Users would see the low score and
either lose trust in the panel's substance or learn to ignore the score
entirely — both bad outcomes.

The 0.5 score (effective 2026-05-22) reflects three things:
1. **The claim might be right.** "Agentforce is GA" lands on a TODO
   stub today, but it has been GA since 2024. Penalizing the panel
   the same as a wrong claim is dishonest accounting.
2. **The risk is real, not zero.** The maintainer hasn't verified the
   row; the claim could still be wrong (numbers shift, GA dates slip,
   pricing models change). Half-credit + the visible "unverified" flag
   tells the user to double-check before quoting to a customer.
3. **Maintainer pressure is preserved.** Filling a stub still raises
   the score from 0.5 → 1.0 per claim that lands on it, so the
   maintenance work still buys real accuracy points. It just isn't
   the *only* lever.

This change typically raises the headline accuracy on platform-touching
panels by 5–15 points relative to the pre-2026-05-22 rubric. The change
is intentional: the previous score was over-conservative.

When the product pack genuinely lacks a Platform Facts section (e.g., a
new pack added without one, or `--generic` mode where no pack is loaded),
this factor scores 10/20 — half-credit, with a header note that the
pack has no verification source on file. (`--generic` mode never had a
pack to verify against, so this is the expected score there, not a
defect.)

> *Note: as of 2026-05-22, factor 6 in `--generic` mode scores 10/20
> instead of 20/20 — this corrects a previous default that was
> over-generous to ungrounded platform claims. Users who run
> `--generic` regularly will see a slightly lower headline score than
> they did pre-2026-05-22; this is the intended behavior, not a
> regression.*

**Correction behavior:** When Stage C identifies a platform-claim mismatch, it:
1. Corrects the claim in the final report (strikethrough original + correction)
2. Notes which persona made the incorrect claim
3. Adjusts the action item if it depended on the incorrect claim
4. Does NOT remove the action item — the underlying concern may still be valid
   even if the specific number was wrong

## What changes under `--require-citations`

Under strict citation mode:
- Any factual claim without a `references/<slug>/meta.json` source moves to
  a **"Needs verification"** section, separated from the main recommendations.
- The reported Accuracy score is **capped at 70** until the citation gap
  closes, regardless of how high the other factors score. This makes the
  cost of missing citations visible immediately.
- The skill offers to run `/download` first against a recommended seed list
  (from the active product/industry pack) to close the gap.

## Low-accuracy follow-up — the 75-point threshold

When the headline score lands below **75/100**, the orchestrator
appends a "Tighten this report" block to the header recommending the
cheapest re-run that would lift the score (see SKILL.md Step 11).

**Why 75?** Below this line, at least one factor has dropped enough
that a re-run with more rigor (`--require-citations` is the broadest
lever) would meaningfully change the report. Above this line, the
remaining headroom is small and the additional run isn't usually
worth the round-trip — the user is better served acting on the
report and revisiting only if specific claims fail in the field.

The block is **informational, not blocking.** Internal sanity-checks
and exploratory panels often run fine at 65–74; the recommendation
exists so the user doesn't *unintentionally* accept a low-confidence
report when one re-run would have helped.

The recommendation is suppressed when:
- `--require-citations` was already used (already at maximum rigor),
- `--no-citations` was used (user explicitly opted out of citation
  enforcement),
- `--quick` / `--fast` was used (the mode trades accuracy for speed
  by design),
- the score is ≥ 75 (the report is already solid enough).

The suggested remediation depends on which factor scored lowest —
SKILL.md Step 11 has the keying table. For a tied or ambiguous
weakness, `--require-citations` is the default fallback because it
forces evidence on factors 3, 5, and indirectly 6 in one move.

## What changes when multi-Claude fallback is in effect

Only `claude` was found on the host. The skill runs two Claude models in
parallel (Opus + Sonnet by default). Then:
- Channel coverage scores against 2-of-2 (full coverage).
- Inter-model agreement is multiplied by **0.7** before averaging — both
  channels share architecture, so agreement is a weaker signal than
  cross-vendor agreement.
- The report header says so plainly: *"Multi-Claude fallback in effect —
  two Claude models, one architecture. Agreement is meaningful but not as
  strong as a cross-vendor agreement would be."*

## What the score does NOT measure

- **Whether the recommendations are *useful*.** A panel can be highly
  confident in a recommendation that doesn't fit the customer.
- **Whether the citations are *recent enough*.** Citation density treats a
  2020 source the same as a 2026 one; the user must read the dates.
- **Whether the panel was *the right panel*.** A misconfigured panel can
  score 95 and still miss what mattered. The synthesis stage's "where the
  panel was weak" line in the report is the correct place to look for this.

The score is a sanity check, not a verdict.
