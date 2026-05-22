# Deliberation — Cognitive Diversity & the Failure Modes of a Panel

A panel is only worth more than a single reviewer if its members genuinely
*think differently*. Five personas that reason the same way are not a panel —
they are one opinion in five fonts. This file defines the cognitive-diversity
model `/focus-group` uses, and the two failure modes the skill must actively defend
against. It is injected into every persona subagent and used by the synthesis
step, in **both** grounding modes.

## Why diversity is the whole point

Merrell's *General Theory of Leadership* (Doctrine 3 — **Diverse Gifts**) states
it directly: every person is "naturally endowed, each with a gift… the potency
of any gift being multiplied… to transform their diversity into the power of
common vision… so that all may prevail with **some** of what they seek." That is
literally the synthesis's job. A panel's value is not consensus — it is the
*friction* between honestly different viewpoints, resolved into something no
single viewpoint could reach.

So divergence is not noise to be averaged away. A lone persona spotting a fatal
flaw outranks four personas admiring the color palette. The synthesis exists to
*hold* difference, not dissolve it.

## The two failure modes of a *simulated* panel

A `/focus-group` panel has a structural hazard a panel of real humans does not: one
model generates every persona. They read the same content with the same
underlying weights. Left unchecked they drift toward a single "house view"
wearing different name tags. Two named organizational-behavior failure modes
describe the danger — guard against both.

### 1. Groupthink
Convergence pressure produces apparent agreement that is not independent. In a
simulated panel this happens *without anyone intending it* — the model's prior
makes five personas land on the same five points. Arbinger's *Leadership and
Self-Deception* names a closely related pattern: **collusion** / "being false
together" — interlocking boxes, where "we are all fish in the same water and no
fish can see the water." Apparent unanimity is the symptom to be suspicious of,
not reassured by.

**Test:** real consensus is five personas reaching the same conclusion *by five
different roads*. Manufactured consensus is five personas reciting it the same
way. If the reasons differ, the agreement is robust. If the reasoning is
interchangeable, treat the "consensus" as a single data point, not five.

### 2. The Abilene paradox
A panel (or a synthesis) endorses a course of action that *no individual
member actually wanted* — everyone assumed everyone else was for it. For
`/focus-group` the risk is the **synthesis manufacturing agreement**: writing a
"combined verdict" or a "top priority" that no persona actually argued for with
conviction, because it felt like the tidy middle.

**Test (the Abilene check):** before the synthesis endorses anything, ask — *which
specific persona argued for this, and with what conviction?* If the answer is
"none, exactly — it just seemed reasonable," cut it or label it as the
orchestrator's own inference, not a panel finding.

## Model-level diversity — the structural fix

The deepest defense against simulated groupthink is not to rely on one model at
all. `/focus-group` distributes the panel across **multiple independent AI command-
line tools** — Claude, Codex, Gemini, opencode — so different personas are
reasoned by genuinely different architectures that fail differently. When only
one CLI is installed, the skill falls back to running two Claude models in
parallel (Opus + Sonnet) to preserve at least one axis of architectural
independence. See `references/multi-model-panel.md`.

This changes how strong a consensus is:

- **Same model, many personas** — agreement is the *weakest* signal; suspect a
  house view (run the independent-derivation test hard).
- **Many models, many personas** — agreement is the *strongest* signal a panel
  can produce: independent architectures, independent personas, same conclusion.

So the synthesis records **which model ran each persona**, and weights a
cross-model + cross-persona consensus far higher than a single-model one. When
every persona happens to land on one model (the others were skipped for quota),
the synthesis says so and tempers confidence accordingly.

## The four diversity axes

Every persona file carries a `## Deliberative profile` positioning it on these
axes. They are deliberately spread across the roster so a well-composed panel is
genuinely heterogeneous.

| Axis | Endpoints | Why it changes the review |
|------|-----------|---------------------------|
| **Tolerance for ambiguity** | Low (wants it nailed down — an open question is a defect) ↔ High (comfortable with "it depends," provisional answers, unknowns) | Low-tolerance personas catch under-specification; high-tolerance personas catch false precision and premature closure. |
| **Locus of control** | Internal (outcomes are ours to shape — here's what *we* change) ↔ External (outcomes are shaped by markets, regulators, users, luck) | Internal personas push for action and ownership; external personas surface forces the plan can't command and must instead absorb. |
| **Risk orientation** | Risk-seeking ↔ risk-aware ↔ risk-averse | Determines whether a persona reads an unknown as an opportunity or a threat. |
| **Worldview / lived experience** | The distinct vantage — adversary's eye, newcomer's anxiety, regulator's chair, the barrier only this persona can see | This is the irreplaceable part. It is *why* the persona is on the panel. |

Each profile also names **where the persona refuses to go along** — its dissent
trigger. Several personas (QA/Test Engineer, Security Reviewer, Security-Anxious
Skeptic, Diligence/Risk Analyst) are *structural dissenters* by design: their job
is to break a forming consensus.

## Composing a panel for spread (used in SKILL.md Step 2)

Role coverage is not enough. A panel of five personas who all have low ambiguity
tolerance and an internal locus will agree quickly and miss the same things.
When recommending a panel:

- Spread the deliberative profiles, not just the roles. Mix ambiguity tolerance;
  mix locus of control.
- Include **at least one structural dissenter** in any panel of three or more.
- If the user's chosen panel is deliberatively homogeneous, say so and suggest
  one persona who would break the monoculture.

## The synthesis's anti-groupthink duties (used in SKILL.md Step 5)

1. **Independent-derivation test** — for each consensus item, confirm the
   personas reached it through their *own* lens. Different reasons → robust;
   identical reasoning → flag as possible house-view artifact.
2. **Preserve and spotlight dissent** — every minority view and lone serious flag
   gets its own line in the synthesis. Never let weight-of-numbers bury it.
3. **The Abilene check** — name the persona behind every endorsed recommendation.
   Unattributable "agreement" is cut or labeled as the orchestrator's inference.
4. **Devil's-advocate the verdict** — the synthesis must state the strongest
   honest case *against* its own combined verdict. If it cannot, the panel was
   too homogeneous and the synthesis should say so.
5. **Call a weak panel weak** — if the panel lacked deliberative spread, the
   synthesis says the result is lower-confidence and names the missing viewpoint.
6. **Validate every channel before merging it** — a persona run on an external
   model can return off-format output, break character, or — worst —
   *confabulate*: produce a review of *different* content than what was under
   review. Before merging any channel's feedback, confirm it actually references
   the real content. Off-format-but-relevant output → normalize it, keep the
   substance. Confabulated output (about the wrong content) → **discard it, note
   it, and never let its invented findings into the synthesis.** The aggregator
   (Claude-latest) is the reliability backstop — it does not trust a channel's
   output just because the channel exited `OK`.

> The goal is not to *manufacture* disagreement either. Sometimes five personas
> genuinely converge for five real reasons — that is the strongest signal a
> panel can produce. The discipline is simply to *earn* the word "consensus"
> rather than assume it.
