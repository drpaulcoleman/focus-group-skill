# Multi-Model Panel — Channel Discovery, Distribution, and Multi-Claude Fallback

`/focus-group` distributes the panel across multiple independent AI command-line
tools so different personas are reasoned by genuinely different
architectures that fail differently (see
[deliberation.md](deliberation.md) for *why* this matters). This file
specifies the **how**.

## The channels

| Channel | CLI | Richest-model invocation | Status |
|---------|-----|--------------------------|--------|
| **claude** | `claude` / local subagent | Claude latest (Opus) + `--effort high` | always available (the host CLI) |
| **codex** | `codex` | `codex exec` + `model_reasoning_effort=high` | optional |
| **gemini** | `gemini` | `gemini` default top model | optional |
| **opencode** | `opencode` | `opencode --model <id>` | optional |
| **claude-sonnet** | `claude --model claude-sonnet-...` | second Claude model for multi-Claude fallback | activates automatically when only `claude` is detected |

The 5th channel — **claude-sonnet** — is the public-version "always
cross-model" guarantee: if no second-vendor CLI is installed, the skill
still runs two Claude models in parallel so the panel has at least one axis
of architectural independence.

## Anonymize pre-dispatch gate (Step 8.0)

Before any of the round-robin / fallback / dispatch logic in this file
runs, [`SKILL.md` Step 8.0](../SKILL.md) requires the orchestrator to
verify an `/anonymize` runtime is available **whenever the panel content
is customer-grounded** (named org, internal-source profile, attendee
profiles, or content matching anonymize patterns).

If no runtime is found, the gate blocks dispatch and offers four options:
install Python (~3 min) / install Node.js / fall back to `--single-ai`
(host Claude only, no external dispatch needed) / cancel. The dispatch
logic below assumes the gate has already passed; it never receives raw
customer-identifiable data, only `anonymize.scrub()`-ed prompts with
bidirectional placeholders. See [`/anonymize` SKILL.md](../../anonymize/SKILL.md).

## Round-robin distribution

When the panel is composed (Step 4), the skill assigns each persona to a
channel round-robin from the **available** channels:

```
panel = [AE, SE, CIO, InfoSec, Industry Specialist]
available = [claude, codex, gemini]
assignment:
  AE                 -> claude
  SE                 -> codex
  CIO                -> gemini
  InfoSec            -> claude
  Industry Spec.     -> codex
```

This maximizes model spread across the panel. A persona's lens is
model-agnostic — any channel can run any persona — so round-robin is the
right default unless the user pinned personas to channels manually with
`--persona-models`.

## Multi-Claude fallback

The fallback engages when no other vendor's CLI is **operational** — not
just when no other CLI is **present**. "Present but non-operational"
covers three cases the skill must distinguish from "missing":

- `unauth` — installed but not signed in (`codex` without an API key,
  `gemini` without `gemini auth login`).
- `quota` — signed in but rate-limited or out of credit for the day.
- `error` — present but errored on the Step 0 health check, or errored
  on its first real dispatch in this run.

A CLI on PATH that returns `unauth` / `quota` / `error` is treated the
same as a missing CLI for dispatch — it does not count toward
cross-vendor diversity. SKILL.md Step 0 records this in the cache as
`{ present: true, operational: false, health: "<unauth|quota|error>" }`.

When no other vendor is `present && operational`, the skill silently
configures the fallback **without prompting the user**. The behavior:

1. `available = [claude-opus, claude-sonnet]` (model ids read from
   `config.json` `multi_claude_fallback.primary` and `.secondary`).
2. Round-robin assigns personas to the two models.
3. Stage A aggregator runs on Opus.
4. Stage B consolidator runs on Sonnet.
5. Stage C merges; the accuracy rubric's agreement weight is dampened by
   0.7 because both channels share architecture (see
   [accuracy-rubric.md](accuracy-rubric.md)).
6. The report header says: *"Multi-Claude fallback in effect — two Claude
   models, one architecture. Agreement is meaningful but not as strong as
   a cross-vendor agreement would be."*
7. **When the trigger was non-operational CLIs (not missing ones),** the
   header also lists each bypassed CLI with a one-line remediation
   (e.g., *"codex unauth — run `codex login` to add it back"*) so the
   user can fix the gap rather than wonder where the cross-vendor
   diversity went.

The fallback uses `/cross-ai-review`'s `cross_ai.py` if available; if not,
it spawns two local Claude subagents directly.

**Mid-run promotion.** If a CLI passes the Step 0 health check but fails
its first real persona-prompt dispatch with an auth/quota pattern, the
orchestrator invalidates the cache entry, reassigns the persona, and —
if that leaves Claude as the only operational vendor — promotes the
*remaining* dispatches to multi-Claude. The promotion is surfaced in the
header (*"gemini fell over mid-run — reassigned 2 personas to
multi-Claude"*); the skill never silently retries the broken channel.

**Stage B is never silently skipped when Claude is available.** If
every non-Claude option is non-operational by the time Stage B runs, the
consolidator runs on the second Claude model (Sonnet if A was Opus, or
vice-versa). Skipping Stage B is reserved for the case where *every*
model option — including the second Claude — is unavailable, which is
extremely rare on a host that's running this skill at all.

The skill **does not** prompt the user to install another CLI just because
the fallback engaged — that decision belongs to the install-offer triggers
in [usage.md](usage.md) §8 (which fire after a `/cross-ai-review` run
completes, not during a `/focus-group` panel). The header's one-line
remediation is information, not a prompt.

## Quota-skip and reassignment

If a channel returns `quota` (rate-limited / out of credit), the affected
persona is reassigned to the next available channel in round-robin order.
If no channel can run it (all quota-exhausted), the persona is dropped from
the panel and the report header says so.

A panel run **never fails fatally** because of quota — the synthesis
proceeds with whatever ran and tempers confidence accordingly.

## Local vs dispatched personas

- Personas assigned to **claude** run as local `Agent` subagents (no
  external CLI roundtrip).
- Personas assigned to **codex / gemini / opencode** run via
  `cross_ai.py` (`--only <channel>`), each as a one-shot CLI invocation.
- Personas assigned to **claude-sonnet** (multi-Claude fallback only) run
  via `claude -p --model <sonnet-id>` (a separate subprocess from the
  local Claude session so the two models really are independent).

## Validating channel output (Duty 6)

Per [deliberation.md](deliberation.md) Duty 6: validate every channel's
output **before** merging it. An external CLI can:
- Return off-format output → normalize it, keep the substance.
- Break character → re-prompt once with a stricter framing; if it fails again, discard.
- **Confabulate** (review a *different* content than what was under review) → **discard, note, never merge.**

The aggregator (Stage A, Claude latest) is the reliability backstop. It
does not trust a channel's output just because the channel exited `OK`.

## Cursor IDE host

When the host is the Cursor IDE (via the `.cursor/commands/` shim), the
channel set is the same — Cursor itself doesn't add a model channel. The
shim delegates to the canonical SKILL.md and uses the same probe results.
If Cursor exposes a headless invocation in a future spike (PLAN §17.4(b)),
we'll add `cursor` as a channel; until then, Cursor users get the same
channels every other host gets.
