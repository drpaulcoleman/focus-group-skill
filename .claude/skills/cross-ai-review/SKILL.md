---
name: cross-ai-review
description: >-
  Submit one identical prompt to whichever AI command-line tools are
  installed (Claude, Gemini, Codex, opencode) — headless and in parallel —
  collect every answer into one report, and synthesize where they agree,
  disagree, and what each missed. If only Claude is available, fan out to
  two Claude models (Opus + Sonnet) so the user still gets a multi-model
  audit. Reports an estimated Accuracy score (0–100) and a Citations block
  built from any /download references in the workspace. Any CLI that is
  rate-limited or out of tokens is skipped automatically so a partial review
  still completes. Use this whenever the user wants a cross-AI review, a
  second or third opinion from other models, an independent accuracy /
  errors-and-omissions / hallucination audit, a fact-check across models,
  or asks things like "what do Gemini and Codex think", "cross-check this
  with the other AIs", "run this by all three models", "have another AI
  verify this", or invokes /cross-ai-review. Do NOT trigger for an ordinary
  single-model question — only when the user genuinely wants the same prompt
  fanned out to multiple independent AI CLIs.
---

# /cross-ai-review — Multi-Model Errors-and-Omissions Audit

Fan one prompt out to every AI command-line tool installed — **Claude**,
**Codex**, **Gemini**, **opencode** — collect every answer into one report,
turn the spread into a usable assessment, score the accuracy, and attach a
citations block.

The point of consulting other models is that they fail differently than each
other: a claim all of them accept is probably solid; a claim only one flags
is worth a hard look.

For sales-team users where a hallucinated claim in front of a customer is
deal-killing, the skill **guarantees at least two models always run**:

- If multiple CLIs are installed → fans out to all of them.
- If **only `claude`** is installed → fans out to two Claude models in parallel
  (default Opus + Sonnet) so the audit still has cross-model independence.

Explicit-trigger — runs when the user asks for a cross-AI check, not
automatically on every planning task.

## Three modes the skill answers in

### Help mode
If the user invokes `/cross-ai-review help` / `--help` / `-h` / `?`, do NOT
fan out — print the user-facing walkthrough: what the skill does, the
multi-Claude fallback rule, the install offers, the four-step workflow,
the accuracy rubric, the prompt templates, and the err-doctrine.
Then stop.

### Preflight check
`python <skill>/scripts/cross_ai.py --check` prints which CLIs were found and
which model each would use.

### Fan-out mode (the main flow)
Four steps: **compose → run → read → synthesize**. Do not skip the synthesis
— raw answers are not a review; the review is what you make of them.

## What it is good for

- **Cross-AI plan / design review** — a second and third opinion on an
  architecture, approach, or decision before committing to it.
- **Accuracy & errors-and-omissions audit** — does a document, spec, or
  piece of analysis contain mistakes, or leave out something important?
- **Hallucination / fact-check** — are the factual claims actually true, or
  is a model inventing them?
- **Disagreement-hunting** — deliberately surfacing where capable models
  diverge, because that is where the real risk usually hides.
- **Stage B of `/focus-group`** — consolidating a Stage-A persona-panel report.

## Prerequisites

Any one of `claude`, `gemini`, `codex`, `opencode` installed and logged in.
The skill never handles keys or credentials — each CLI authenticates on its
own. Run a preflight check any time you are unsure:

```
python <skill>/scripts/cross_ai.py --check
```

When only `claude` is detected, the skill silently configures the
**multi-Claude fallback** (Opus + Sonnet running in parallel) so the user
still gets a multi-model audit. The fallback uses `claude -p --model
<model-id>` twice and treats each Claude model as its own channel for the
purpose of agreement/disagreement scoring.

## The workflow

### 1. Compose the prompt

Each CLI receives **only the prompt you write** (plus the project files it
auto-loads — see "Context", below). So the prompt must stand on its own:
state the task, paste or attach the material under review, and ask for
exactly the judgment you want back.

Two hard rules:

- **No secrets or personal data.** API keys, passwords, tokens, customer
  records, anything private. The prompt is sent to several separate external
  services. Scrub first.
- **Keep it focused.** A tight prompt with specific questions gets a sharp
  answer. Dumping ten files and asking "thoughts?" gets mush. Attach the
  material that genuinely needs reviewing and nothing else.

Pick the framing that matches the task — see **Prompt templates** below.

### 2. Run the fan-out script

Save the prompt to a file and run it. The script submits to every available
CLI in parallel (or both Claude models if only `claude` is present), writes
a combined report, and **always finishes** — a CLI that is missing,
rate-limited, or out of tokens is skipped and noted, never fatal.

```
python <skill>/scripts/cross_ai.py --prompt-file <prompt.txt> --label "<short-label>"
```

Common variants:

```
# Inline prompt
python <skill>/scripts/cross_ai.py --prompt "Review this approach: ..." --label auth-review

# Attach the material being audited (repeatable)
python <skill>/scripts/cross_ai.py --prompt-file ask.txt --attach design.md --attach api.json

# Quick gut-check (cheaper, faster, less thorough)
python <skill>/scripts/cross_ai.py --prompt-file ask.txt --fast

# Only some channels
python <skill>/scripts/cross_ai.py --prompt-file ask.txt --skip gemini

# Force the multi-Claude fallback even when other CLIs are available
python <skill>/scripts/cross_ai.py --prompt-file ask.txt --multi-claude

# Skip the citations block AND the accuracy score entirely (no scan, no rubric)
python <skill>/scripts/cross_ai.py --prompt-file ask.txt --no-citations

# Strict citation mode (caps score at 70 when the workspace has zero citations on file)
python <skill>/scripts/cross_ai.py --prompt-file ask.txt --require-citations
```

The script prints a status line per channel and the path to the report. It
runs in **deep** mode by default (strongest model + high reasoning effort
per CLI); `--fast` downshifts to quick models.

**Where channel models come from (in precedence order):**
1. A per-invocation `--<channel>-model` flag, if given.
2. Else the shared `/focus-group` skill's `config.json` (`channel_models`) — so
   a cross-AI review and a `/focus-group` panel always pick the same model per
   CLI.
3. Else this skill's own `config.json` (a local fallback that ships sensible
   defaults so the skill works standalone if `/focus-group` isn't installed).
4. Else each CLI's built-in deep default.

### 3. Read the report

The script writes a run folder (default `~/.claude/cross-ai-runs/<run-id>/`):

- `report.md` — human-readable: the prompt, each channel's answer or its
  skip/failure note, **the Accuracy score with rubric breakdown**, and the
  **Citations block** sourced from any `references/<slug>/meta.json` files
  in the workspace.
- `report.json` — the same data structured, including per-channel `status`.
- `prompt.txt` — the exact prompt, preserved so a skipped channel can be
  re-run later with identical input.

**Read `report.md`.** Note which channels answered, which were skipped, and
how the citation density shaped the accuracy score.

### 4. Synthesize — present a Cross-AI Review Summary

This is the deliverable. Compare the answers and report what matters, using
this structure (adapt the headings to the task):

```
## Cross-AI Review Summary

**Channels:** claude-opus OK · claude-sonnet OK · codex SKIPPED (quota)
              — 2 of 3 responded (multi-Claude fallback in effect)
**Accuracy:** 82/100 — high coverage, moderate citation density, 2 claims
              under-cited (flags below)

**Consensus** — where the responding models agree (independent reasoning paths)
- ...

**Disagreement** — where they diverge, and which side is better supported
- claude-opus vs codex on <point>: ... — <your read of who is right and why>

**Errors, omissions & possible hallucinations flagged**
- <model> flagged <claim/gap>: ... — <holds up / does not, because ...>

**Risks / blind spots raised**
- ...

**Bottom line** — synthesized recommendation, and how much the skipped
channel(s) and citation gaps limit confidence.

**Citations**
[1] Salesforce. (2026, May 10). Service Cloud overview. Retrieved May 20,
    2026, from https://help.salesforce.com/...
[2] ...
```

Principles for a good synthesis:
- **You are the judge, not a vote-counter.** Three models agreeing on
  something wrong is still wrong. Weigh the *reasoning*, not the headcount.
- **Disagreement is the signal.** Where the models split, dig in and resolve
  — that is the highest-value part of the review.
- **Be honest about coverage.** If only one channel responded, say so plainly
  and treat it as a single opinion. If only multi-Claude ran, say so — two
  Claude models still share architecture; the agreement is weaker than a
  cross-vendor agreement.
- **Attribute claims.** "Codex flagged X" lets the user trace it; "the AIs
  said X" does not.

## Accuracy score (0–100)

Computed by `cross_ai.py` per the rubric in
[../focus-group/references/accuracy-rubric.md](../focus-group/references/accuracy-rubric.md).
The factors:

| Factor | Weight |
|--------|--------|
| Channel coverage (responding / available) | 25 |
| Inter-model agreement on factual claims | 30 |
| Citation density (claims with a `meta.json` source) | 25 |
| Hedging / uncertainty calibration | 10 |
| Anti-hallucination cross-check (spot-check 3 claims) | 10 |

**Reported as** `Accuracy: 82/100 — high coverage, moderate citation density,
two claims under-cited (see flags)`.

Under `--require-citations`, the **score is capped at 70** when the workspace
has zero `references/<slug>/meta.json` citation files on file. The script
records the cap on the report header. The skill can also offer to run
`/download` first against a recommended seed list to add citations before
the run. Note: per-claim "Needs verification" demotion (attributing each
under-cited claim individually) is a planned addition — today, the cap is
workspace-level rather than per-claim. The orchestrator can do the
per-claim audit by re-reading `report.md` and flagging in the synthesis.

The score is an estimate of *internal confidence*, not a truth claim. The
report header says so.

## Citations block

When the workspace has any `references/<slug>/meta.json` files (left by
`/download`), the synthesis stage appends a Citations block listing the
sources actually used by any model in their reasoning. APA-style format:

```
[1] <Source title>. (YYYY, Month D). Retrieved Month D, YYYY, from <URL>
```

When the workspace has none, the report says so plainly under "Citations"
and the accuracy score reflects the missing coverage (citation density = 0).

## Prompt templates

Prepend the matching frame to the material. Keep them short — they steer
the sub-AI without drowning the actual question.

**Plan / design review**
```
You are independently reviewing a plan. Do not be agreeable — your value is
catching what the author missed. Give: (1) points you agree with, (2) points
you disagree with and why, (3) risks or failure modes not addressed, (4) a
clear verdict (sound / sound with changes / reconsider).

PLAN:
<the plan>

SPECIFIC QUESTIONS:
<what to validate>
```

**Accuracy & errors-and-omissions audit**
```
Audit the material below for correctness and completeness. List: (1) factual
or technical errors, (2) claims that are unsupported or overstated, (3)
important omissions — things that should be covered but are not. Quote the
exact text for each finding. If something is correct, do not pad the list.

MATERIAL:
<the document / spec / analysis>
```

**Hallucination / fact-check**
```
Fact-check every specific claim below. For each: state whether it is TRUE,
FALSE, MISLEADING, or UNVERIFIABLE, and explain briefly. Pay special
attention to invented names, APIs, numbers, citations, or capabilities.

CLAIMS:
<the text to check>
```

## Context: what the sub-AIs see

By default the CLIs run **in the current directory**, so they auto-load that
project's context files (`CLAUDE.md`, `GEMINI.md`, `AGENTS.md`) and can read
repo files. They review with the house rules in view — useful, but it also
means all of them share the same project assumptions.

For a genuinely independent read — no project files, no house rules — add
`--clean-room`. The CLIs then run in an isolated temp directory and judge
the prompt purely on its own merits. Reach for it when the question is
"is this *right*", not "does this fit *our conventions*".

## Graceful degradation — how skips work

A cross-AI run must never be held hostage by one exhausted account. The
script classifies each channel:

| Status | Meaning | Effect on the run |
|--------|---------|-------------------|
| `ok` | the CLI answered | response included |
| `quota` | rate-limited / out of tokens | **skipped**, noted, not a failure |
| `error` | failed for another reason | noted with a diagnostic |
| `timeout` | no response in time | noted; raise `--timeout` to retry |
| `missing` | CLI not installed | noted; triggers install offer (once) |

Quota detection only inspects a run that already **failed** (non-zero exit),
so a prompt that legitimately discusses "rate limits" is never misread as
an exhausted account. When you present the summary, **always state which
channels were skipped** and temper confidence accordingly. To retry a
skipped channel later, re-run with `--prompt-file <run>/prompt.txt --only
<channel>`.

## Proactive install offers

If `codex`, `gemini`, or `opencode` are absent and the user just ran
`/cross-ai-review`, the skill offers a guided install — once per workspace,
with the trigger reason recorded so re-asks are informed. Same four-option
menu as `/focus-group` and `/download`:

> *A second AI sees blind spots the first one missed. For sales material,
> that catches confident-but-wrong claims before a customer does.*
>
> | Priority | Tool | Why this helps you right now |
> |----------|------|------------------------------|
> | ⭐⭐⭐ | gemini | Different architecture from Claude — biggest single jump in coverage. |
> | ⭐⭐ | codex | A third independent vendor — sharpens the audit on long-tail claims. |
> | ⭐ | opencode | Open-source CLI; useful if you want to layer in local models. |
>
> *(a) Walk me through the top one now · (b) Walk me through all of them ·
> (c) Skip for this run; ask me again next time I run a cross-AI review ·
> (d) Skip and don't ask again*

Persist the answer in `.install-asked.json` in the skill folder.

## Errors and failures

Apply the err-lite doctrine in
[../focus-group/references/err-doctrine.md](../focus-group/references/err-doctrine.md):
name the cause in one plain-English sentence, say what was done without the
failing piece, and offer 1–2 concrete next steps. Never paste a raw stack
trace at the user. End with *"If you'd like, paste the screen you see and
I'll translate it."*

## Running it inside a subagent (optional)

For a heavy review whose responses would be long, you can delegate steps 2–4
to a subagent: have it run the script, read `report.md`, and return only the
finished Cross-AI Review Summary. That keeps the raw responses out of the
main conversation. Optional — because the script writes results to files,
you can also just read `report.md` selectively yourself.

## Reference

`references/cli-matrix.md` — exact per-CLI flags, headless-invocation
details, quota/error signatures, and what to change when a CLI updates its
interface. Read it if a channel behaves unexpectedly or a CLI version bump
breaks a flag.
