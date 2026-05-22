---
name: make-this-mine
description: >-
  Guided personalization interview that tunes /focus-group to the user's
  specific role, deal types, industry context, and noise preferences.
  Writes to the existing focus-group config.json — single source of truth.
  Explicit-trigger only: invoke via `/make-this-mine`.
---

# /make-this-mine — Personalize Your Focus Group

`/make-this-mine` is a guided interview that tunes the `/focus-group` skill to
your specific working context. It covers dimensions that `/focus-group config`
doesn't ask on its own — deal types you work, noise categories you want
filtered, your preferred panel size, and a richer role description than the
9-slug picker provides.

Everything it learns persists to the **existing** `/focus-group` `config.json`
(single source of truth — no parallel config system). `/focus-group config`
shows the same values. `/focus-group config clear` clears them.

## When to invoke

- First time using the skills — run this once to front-load personalization.
- After a role change (moved from SE to Architect, switched verticals).
- When the skill's recommendations feel noisy or off-target.

## What it asks (the interview)

Six questions, asked in order. Each can be skipped. The interview takes 2–3
minutes for a thoughtful pass.

### Q1 — Role elaboration

*"Your saved role is `<slug>`. In one sentence, what makes YOUR version of
this role different from the generic? (e.g., 'I'm an Enterprise AE covering
financial services accounts >$1B AUM, multi-year platform deals')"*

- Persists to: `config.json` → `role_elaboration` (string, ≤200 chars)
- Effect: Sharpens the role-framed output in Step 9/12 beyond the generic
  slug. An AE who says "I cover healthcare payer accounts" gets panel
  recommendations and talk tracks tuned for payer economics, not generic CRM.

### Q2 — Deal types

*"What deal types do you work most often? Pick all that apply."*

Options (multi-select):
- New logo (land)
- Expansion (grow existing)
- Renewal / retention
- Multi-cloud bundle
- Partner co-sell
- RFP / competitive bake-off
- POV / proof-of-value
- Strategic / advisory (no immediate close)

- Persists to: `config.json` → `deal_types` (array of slugs)
- Effect: Biases persona recommendations toward the buyer archetypes that
  matter for these deal types (e.g., RFP deals weight Procurement and
  the "Evaluating Three Vendors" archetype; expansion deals weight
  Customer Success and the Champion).

### Q3 — Excluded noise categories

*"Which feedback categories are noise for your role? The panel won't suppress
them entirely, but they'll be demoted to Deep Analysis instead of the
primary instrument."*

Options (multi-select):
- Pricing / commercial terms (I don't own pricing)
- Technical architecture deep-dives (I'm not technical)
- Competitive positioning (my deals aren't competitive)
- Regulatory / compliance details (my vertical isn't regulated)
- Post-sale / adoption concerns (I only do pre-sale)
- Internal Salesforce politics / org dynamics (I'm customer-facing only)

- Persists to: `config.json` → `excluded_noise` (array of slugs)
- Effect: Stage A.5 "So What?" gate uses these to demote items that match
  an excluded category. They still appear in Deep Analysis (never deleted)
  but don't clutter the role-framed instrument.

### Q4 — Preferred panel size

*"How many personas do you usually want on a panel?"*

Options:
- 3 (fast, focused)
- 5 (default — balanced depth and speed)
- 7+ (thorough — for high-stakes deals)
- Let the skill decide each time (no override)

- Persists to: `config.json` → `preferred_panel_size` (integer or null)
- Effect: Step 5a panel recommendation targets this size instead of the
  default cap of 5.

### Q5 — Default stage assumption

*"When you don't specify --stage, what stage are most of your reviews for?"*

Options:
- Discovery (early qualification, call prep)
- Demo / POV (mid-cycle, presentation readiness)
- Negotiation (late-stage, paper and pricing)
- Post-sale (QBR, adoption, renewal)
- Let the skill infer from content each time (no default)

- Persists to: `config.json` → `default_stage` (slug or null)
- Effect: When `--stage` is omitted AND the content-type inference is
  ambiguous, use this as the tiebreaker instead of defaulting to "demo."

### Q6 — Industry / product defaults (shortcut)

*"You can also set these with `/focus-group config`. Want to set or change
your defaults now?"*

- Show current `industry` and `product` from config.json.
- If the user wants to change: present the slug lists from the product-packs
  and industry-packs directories.
- Persists to: existing `config.json` → `last_industry_pack`, `last_product_pack`

## After the interview

Present a summary card:

```
Your /focus-group personalization:

Role:           Enterprise AE (healthcare payer, >$1B AUM)
Deal types:     new-logo, expansion, rfp
Excluded noise: technical-architecture, post-sale
Panel size:     5
Default stage:  demo
Industry:       healthcare-life-sciences
Product:        salesforce-crm-agentforce

Saved to config.json. Change any time with:
  /make-this-mine          (re-run the full interview)
  /focus-group config      (view/edit individual keys)
  /focus-group config clear <key>  (reset one field)
```

## Privacy

- All personalization data lives in `config.json` (already git-ignored per
  the focus-group `.gitignore` pattern).
- No personalization data reaches any external model. It shapes which
  personas are recommended and how the report is framed — it doesn't
  become part of the prompt sent to external CLIs.
- The interview never asks for customer names, ARR, or account-specific data.

## Interaction with /focus-group

`/focus-group` reads the personalization keys at:
- **Step 1:** `role_elaboration` enriches the role context (skip re-asking).
- **Step 5a:** `deal_types`, `excluded_noise`, `preferred_panel_size` bias
  panel composition and sizing.
- **Step 9.5:** `excluded_noise` categories are demoted in the "So What?" gate.
- **Step 2 (stage inference):** `default_stage` breaks ambiguous-content ties.

## Config keys added

| Key | Type | Example | Effect |
|-----|------|---------|--------|
| `role_elaboration` | string (≤200) | "Enterprise AE, healthcare payer, >$1B AUM" | Enriches role framing in output |
| `deal_types` | string[] | `["new-logo", "expansion", "rfp"]` | Biases persona + archetype selection |
| `excluded_noise` | string[] | `["technical-architecture", "post-sale"]` | Demotes matching items in Stage A.5 |
| `preferred_panel_size` | int \| null | `5` | Overrides default panel cap |
| `default_stage` | string \| null | `"demo"` | Tiebreaker for ambiguous content |
