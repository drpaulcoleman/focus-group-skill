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
| **Platform-fact verification** | 20 | For each claim about Salesforce platform behavior (governor limits, pricing, feature GA status, sharing-model behavior, API limits, data-volume thresholds), verify against the active product pack's `## Platform Facts` section. Claims that contradict the pack → flagged and corrected in the report, scored 0. Claims the pack confirms → scored 1.0. Claims the pack doesn't cover → scored 0.5 and marked "unverified — check release notes." Average × 20. If no platform claims exist in the output, score the full 20 (no risk of misinformation). |

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

**Verification source:** The active product pack's `## Platform Facts` matrix
(each product pack should maintain one). When the product pack lacks a Platform
Facts section, this factor scores a flat 15/20 (benefit of the doubt minus a
small penalty for unverifiable claims).

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
