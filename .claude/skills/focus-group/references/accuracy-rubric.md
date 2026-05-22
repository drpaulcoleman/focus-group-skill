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
| **Platform-fact verification** | 20 | For each claim about Salesforce platform behavior (governor limits, pricing, feature GA status, sharing-model behavior, API limits, data-volume thresholds), verify against the active product pack's `## Platform Facts` section. **Claims that contradict the pack** → flagged and corrected in the report, scored 0. **Claims the pack confirms** with a verified row are scored on a freshness curve (see "Freshness decay" below): row verified ≤12 months ago → 1.0; 12–24 months → 0.75 + "verified but aging" flag; >24 months → 0.5 + "stale — re-verify before quoting" flag. **Claims that land on a TODO-stub row** (the pack lists the topic but has not been verified) → scored **0.5** and the report flags the claim as "unverified — check current Salesforce help / release notes before quoting to a customer." **Claims the pack doesn't cover at all** (no row, even as stub) → scored 0.25 and marked "off-pack — verify against current docs." Average × 20. If no platform claims exist in the output, score the full 20 (no risk of misinformation). See "TODO-stub scoring rationale" and "Freshness decay" below. |

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

### Freshness decay on filled rows

The earlier rubric treated any filled row the same regardless of how
recently it was verified. That broke down quickly: Salesforce ships
~3 releases a year and governor limits, GA status, and pricing model
details move per release. A "verified once in 2024" row scoring 1.0 in
2026 is dishonest accounting — the row reflects *past* truth, not
*current* truth.

Freshness decay (effective 2026-05-22) reads the `Last verified` column
of each filled row and scales the per-claim score:

| Age of `Last verified` | Score | Report flag |
|------------------------|-------|-------------|
| ≤ 12 months | 1.0 | (none) |
| 12–24 months | 0.75 | "verified but aging — re-check before quoting to a customer" |
| > 24 months | 0.5 | "stale — re-verify against current docs before quoting" |

The 24-month threshold matches roughly one major-release cycle past
the typical "this is still current" window. Stale-flagged claims are
not removed from the report — the underlying concern often still
holds, even if the specific number has shifted; the flag tells the user
to confirm before externalizing.

A filled row with **no `Last verified` date** (or a malformed date) is
treated as 12–24-months-old (0.75) — better than TODO (0.5), worse
than fresh (1.0). Maintainers should always include the date.

**Header counts:** the report header always shows separate counts for
the platform claims actually made, so users can read the score in
context: `Platform claims: 4 verified-fresh · 1 aging · 0 stale · 1
TODO-stub · 1 off-pack`. A high score on a panel with several aging
or TODO-stub claims is structurally less reliable than the same score
on all-fresh claims, and the count makes that visible.

### Trivial-row maintainer caution

A filled row scoring 1.0 still has to pass the "would a customer's
admin Google this and get a useful answer?" sniff test. A row that says
*"Agentforce exists"* is technically verifiable but adds nothing — it
will catch any panel claim about Agentforce and inflate the score
without grounding in real platform behavior. The rubric does not
mechanically detect trivial rows, but the maintainer note in each pack
calls this out: rows should encode *load-bearing* facts (governor
limits, GA status, pricing motions, sharing model, default vs. opt-in
behavior) — not breadth-of-fill for its own sake.

When a reviewer scrubs a pack and finds rows that exist purely to lift
score without informing a customer-facing answer, those rows should be
*removed*, not preserved. A pack that is honest about the gaps
(short list of high-quality filled rows + visible TODOs) is more
useful than a long list of breadth-fill rows.

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
- **Offline failure is surfaced loudly, not silently.** When every `/download`
  attempt fails (offline, DNS error, all seed URLs unreachable), the
  orchestrator stops *before* panel dispatch and offers (a) abort and retry
  online, (b) continue accepting the 70 cap, or (c) drop `--require-citations`
  for this run. See SKILL.md Step 7 "Offline-failure path under
  `--require-citations`" for the exact prompt. This avoids the footgun of a
  silent 70 cap with no obvious remediation when the standard "Tighten this
  report" block is suppressed (because the user already opted into rigor).

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

## What changes under `--single-ai`

Only `claude` runs (no external CLIs, Stage B/C skipped, Stage A is the
final report). There is no second model and no second channel — the
agreement-based factor needs explicit redefinition so the score the user
sees is honest:

- **Channel coverage (factor 1, /20):** 1-of-1 channel responded → 20.
  Coverage is full *for the chosen mode*; the cap is information-only.
- **Inter-model agreement (factor 2, /25, normally cross-model):**
  redefined as **inter-persona agreement within the single model**.
  For each factual claim, count how many of the responding personas
  reach the same conclusion via independently-derived reasoning (per
  [deliberation.md](deliberation.md)'s independent-derivation test):
  3+ personas → 1.0; 2 personas → 0.66; lone claim → 0.33. Average,
  then multiply by **0.5** before scaling to 25 — same model, same
  architecture, same training data, so persona-level agreement is a
  much weaker signal than cross-model agreement (weaker than even the
  multi-Claude 0.7 dampening, because there is only one model in
  play). Effective ceiling on factor 2 under `--single-ai` is
  ~12/25.
- **Factors 3–6 are unchanged.** Citations, hedging, anti-hallucination,
  and platform-fact verification are model-count-agnostic.
- **Practical ceiling under `--single-ai`** is ~87/100 (full marks
  on factors 1, 3, 4, 5, 6 plus the dampened factor 2 ceiling). A
  perfect 100 is structurally unreachable, which is correct: the mode
  trades cross-model robustness for speed/privacy, and the score
  should reflect that trade.
- **Report header always says so plainly:** *"Single-AI mode — one
  model, one architecture. Inter-model agreement replaced with
  inter-persona agreement (dampened 0.5)."*

## What the score does NOT measure

- **Whether the recommendations are *useful*.** A panel can be highly
  confident in a recommendation that doesn't fit the customer.
- **Whether the citations are *recent enough*.** Citation density treats a
  2020 source the same as a 2026 one; the user must read the dates.
- **Whether the panel was *the right panel*.** A misconfigured panel can
  score 95 and still miss what mattered. The synthesis stage's "where the
  panel was weak" line in the report is the correct place to look for this.

The score is a sanity check, not a verdict.
