# Accuracy Rubric (0–100)

The Accuracy score reported by `/focus-group` Stage C and `/cross-ai-review`'s
synthesis is an **estimate of internal confidence** in the panel/review's
output — not a truth claim. It exists so the user can see at a glance
whether to ship the recommendation as-is, double-check it, or run more
grounding before sending it to a customer.

The report header always says so explicitly:
> *Accuracy: 82/100 — an internal-confidence estimate based on coverage,
> agreement, citations, and hedging. This is not a truth check.*

## The five factors

| Factor | Weight | How we score |
|--------|--------|--------------|
| **Channel coverage** | 25 | `(responding_channels / available_channels) × 25`. With multi-Claude fallback, two responding Claude models count as 2-of-2 (so coverage is 25), but the report notes this is single-vendor and the agreement weight is dampened in factor 2. |
| **Inter-model agreement on factual claims** | 30 | For each factual claim in the output: 3+ channels agree → 1.0; 2-of-3 → 0.66; lone claim → 0.33. Average × 30. Multi-Claude (same vendor) agreement is multiplied by 0.7 before averaging — same architecture, weaker signal. |
| **Citation density** | 25 | `(claims_backed_by_meta_json / total_factual_claims) × 25`. A `references/<slug>/meta.json` from `/download` counts; an inline URL the model invented does not. |
| **Hedging / uncertainty calibration** | 10 | Reward appropriate hedging on under-cited claims ("according to the customer's public IR page, ..."); penalize confident assertions on under-cited claims. Spot-check 5 claims; each scores 0–2. |
| **Anti-hallucination cross-check** | 10 | Spot-check 3 claims against their cited sources. Pass → 10. Any one fails → 0 (and the failed claim is flagged in the report). |

Total: 0–100. Reported as `Accuracy: NN/100 — <one-line summary of where the
points came from and where they did not>`.

## What changes under `--require-citations`

Under strict citation mode:
- Any factual claim without a `references/<slug>/meta.json` source moves to
  a **"Needs verification"** section, separated from the main recommendations.
- The reported Accuracy score is **capped at 70** until the citation gap
  closes, regardless of how high the other factors score. This makes the
  cost of missing citations visible immediately.
- The skill offers to run `/download` first against a recommended seed list
  (from the active product/industry pack) to close the gap.

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
