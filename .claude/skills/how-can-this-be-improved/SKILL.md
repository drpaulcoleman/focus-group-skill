---
name: how-can-this-be-improved
description: >-
  User-triggered improvement coach. Invoked explicitly by the user via
  `/how-can-this-be-improved [file | skill]` (or `/how-can-this-be-improved
  help`). PRIMARY target: the culmination output of a `/focus-group` panel
  — the final synthesized report under `.scratch/focus-group/` — to sharpen
  it before the user acts on it or sends it on. Also useful for any other
  file (a draft proposal, QBR section, email, talk-track, demo script,
  spec, architecture sketch — anything markdown / text the user wants a
  second-pass sharpening on). Runs in one of three modes: (a) given a file
  path, reviews that file and reports what to sharpen, cut, add, or back
  with a citation; (b) given a skill name (`focus-group`, `download`,
  `cross-ai-review`, `anonymize`, `slackbot`, or this skill itself),
  audits that skill's `SKILL.md` and reference files for drift,
  underspecification, docs-vs-implementation gaps, and overloaded
  surfaces; (c) no argument — reads what the workspace knows about the
  user (`config.json`, `.focus-group-cache.json`, recent
  `.scratch/focus-group/` history) and recommends targeted improvements
  to the suite based on observed usage patterns. Use this whenever the
  user says "how can this be improved", "sharpen this panel report",
  "audit this QBR", "what should I tighten before I send this", "what's
  missing from the skill", "based on how I've been using these, what
  should I change", or invokes the slash command. Do NOT auto-activate
  from adjacent talk about reviews — runs only on explicit invocation.
---

# /how-can-this-be-improved — Improvement Coach

`/how-can-this-be-improved` is the **sharpening pass** that sits one step
beyond the rest of the suite: instead of producing new output, it looks at
what you already have — a report, a skill, or the cumulative shape of how
you've been using these skills — and tells you what to change to make the
next run noticeably better.

The primary target is the **culmination of a `/focus-group` panel** —
the final report that pulls every persona's feedback into one place. Run
this on the report before you act on it or send anything on, and you'll
catch the hedges, the missing citations, the buried bottom line, and the
audience the panel didn't cover before they reach a customer. It works
on any markdown / text file, though, so use it on drafts, QBRs, emails,
specs, or anything else you want a second-pass sharpening on.

## Three modes the skill answers in

The argument decides which one runs. Matches the three-modes convention
used by the other skills in the suite (Panel mode in `/focus-group`,
Scrub mode in `/anonymize`, Fan-out mode in `/cross-ai-review`).

### Help mode

If the user invokes `/how-can-this-be-improved help` / `--help` / `-h` /
`?`, or asks *how to use* the skill rather than for a review, do NOT run
an audit — read [`references/usage.md`](references/usage.md) and present
the walkthrough (what it does, the three modes, the kinds of feedback
each mode produces, how it composes with the rest of the suite, examples,
and edge cases). Then stop.

### File-review mode (Mode A) — `/how-can-this-be-improved <path-to-file>`

Examples the user is likely to bring:
- A saved panel report from `.scratch/focus-group/<date>-<slug>.md`.
- A draft proposal, QBR section, email, talk-track, or demo script.
- A spec, build plan, or architecture sketch.
- Anything markdown / text the user wants a second-pass sharpening on.

#### What the review covers

| Lens | What you flag |
|------|---------------|
| **Sharpness** | Hedges, filler, throat-clearing, "in order to," "it should be noted that," sentences that could lose 30% of their words without losing meaning. |
| **Structure** | Where the reader has to scroll back to remember what was promised; sections out of priority order; missing TL;DR; tables that should be prose; prose that should be tables. |
| **Backed claims** | Specific factual claims (numbers, governor limits, native features, regulatory thresholds, customer references) that have no citation. For each, suggest: *cite, soften to qualitative, or drop*. |
| **Missing perspectives** | Audiences the document doesn't address but probably should — InfoSec on a deal-team email, the Economic Buyer on a Solution Engineer demo flow, the Champion's manager on a QBR. |
| **Repetition** | Phrases or ideas restated 2–3 times across sections — usually a sign the author was nervous about being heard. Mark for compression. |
| **Tone fit** | Does it match the audience? A QBR for an Economic Buyer reads differently than a hand-off to a customer's IT director. |
| **Bottom line** | Is there one? If a reader stopped after the first paragraph, would they know what you're asking them to do? |

#### Output format

Use this structure:

```
## What's working
- 3–5 bullets — the parts the user should keep and not touch.

## Sharpen
| Where | Issue | Suggested edit |
|-------|-------|----------------|
| Section / line | One-sentence diagnosis | Concrete rewrite or cut |

## Cut
- Each item: the chunk that should be removed + the reason.

## Add
- Each item: what's missing + where to put it + 2–4 sentences of starter draft.

## Cite or soften
- Factual claims without backing, with the *cite / soften / drop* recommendation.

## Bottom-line check
- One sentence: does the document say what it needs to? If not, propose the missing line.
```

End with the **single highest-leverage change** the user should make next
— the one edit that, by itself, would lift the document the most. Make
that recommendation prominent.

If the file is large (over ~2,000 lines), tell the user which sections
you reviewed in depth and which you skimmed, and offer a follow-up pass
focused on the skimmed sections.

### Skill-audit mode (Mode B) — `/how-can-this-be-improved <skill-name>`

Skill names: `focus-group`, `download`, `cross-ai-review`, `anonymize`,
`slackbot`, `how-can-this-be-improved`.

#### What the audit covers

| Lens | What you flag |
|------|---------------|
| **Description triggering** | Does the YAML `description:` make the skill triggerable for the cases it should fire on? Spot under-triggering (too narrow) and over-triggering (too eager). |
| **Drift** | Does the `SKILL.md` body promise switches, modes, or behaviors that the reference files / scripts no longer implement (or vice-versa)? |
| **Underspecification** | Places where the skill says "do X" without enough detail for a fresh Claude to do X consistently. |
| **Overloaded surfaces** | One section trying to do five things — usually a sign the section should split. |
| **Reference file fit** | Reference files that are stale, never linked from `SKILL.md`, or duplicated content from the body. |
| **Edge cases** | Failure modes the skill should handle but doesn't name (quota-skipped CLI, missing file, conflicting switches, empty input). |
| **Voice** | Slips into developer / jargon tone in a skill meant for sales-team users; or vice-versa. |
| **Cross-skill consistency** | Does this skill's flag names, output sections, file conventions match the other skills in the suite? |

#### What to actually read

1. The skill's `SKILL.md`.
2. Every file under the skill's `references/` folder.
3. Any `scripts/` for parity between docs and code.
4. The skill's `config.json` (if present) for fields that don't match SKILL.md.
5. The mention of this skill in `README.md` and `index.html` (drift between marketing and spec).

#### Output format

```
## Strengths
- 3–5 bullets — what's working and should not be disturbed.

## Description triggering
- One paragraph on whether the YAML `description:` would actually fire the skill on the user utterances it should fire on (under-triggering) and whether it would over-fire on adjacent ones (over-triggering). Quote a few example utterances and predict trigger/no-trigger.

## Drift between docs and implementation
| Where | Doc says | Code/files do | Fix |
|-------|----------|----------------|------|

## Underspecified
- Each: section + the question a fresh Claude would still have + 1–2 lines to add.

## Overloaded
- Each: the section + how to split it.

## Edge cases not handled
- Each: the case + the line the skill should print + where it should print it.

## Cross-skill consistency
- Each inconsistency with another skill in the suite + which one should bend.

## Top 3 changes
1. ... (one sentence each on why)
2. ...
3. ...
```

End with **one concrete next change**, named in `Edit/Write`-ready form
(file path + the rough nature of the edit) so the user can either ask you
to make it or do it themselves.

### Usage-pattern mode (Mode C) — `/how-can-this-be-improved` (no argument)

No file, no skill name — the skill looks at **what the workspace knows
about the user** and recommends targeted improvements to the suite based
on observed usage.

#### What to read

All paths are relative to the workspace root unless noted. Skill-local files live under `.claude/skills/<skill>/`; user-workspace artifacts live at the workspace root.

| Source (full path) | What you look for |
|--------------------|-------------------|
| `.claude/skills/focus-group/config.json` | Saved `user_role`, default models, last product / industry pack. |
| `.claude/skills/focus-group/.focus-group-cache.json` | Recently detected CLIs / MCPs — if any are stale, flag for re-detection. |
| `.claude/skills/focus-group/.org-profile.json` | Saved customer / segment profile (per-workspace). Aged > 14 days → flag for refresh. |
| `.claude/skills/focus-group/.org-profile-raw/` (if present) | Raw `sf` / Slack extraction folders, one per customer. Confirms the current-customer flow is actually running. |
| `.scratch/focus-group/*.md` (if present) | Filenames + dates of past panel reports. Read the most recent 5–10 in full to spot patterns. |
| `.anonymize/map.json` (if present) | Frequency of anonymization use — a signal of how much customer-data work is going through the suite. Workspace-root location is the default; an install can override. |

If any of these paths don't exist on this workspace, treat the corresponding signal as "absent" rather than failing — Mode C should run with whatever subset of state exists.

#### What patterns to surface

- **Same subject / product / industry pack invoked repeatedly** → suggest
  saving as the default; suggest pre-loading the relevant `/download`
  seed list; offer to draft a new quick-pick panel for that motion.
- **A persona swapped in or out on every run** → suggest editing the
  default panel recommendation for that user's profile.
- **Citation gaps recurring in reports** → suggest `--require-citations`
  as the default; suggest running `/download` against the active pack's
  seed URLs at the start of each session.
- **A skill never used** → name it and ask if the user is aware of what
  it does, or whether the install path didn't take.
- **Customer profile stale (older than 14 days)** → offer to refresh.
- **No `.org-profile.json` despite a customer name in recent reports** →
  the customer-grounding flow didn't save; suggest re-running with the
  save step approved.
- **A pack the user keeps wishing they had** (inferred from `--generic`
  invocations or repeated description of a context the active pack
  doesn't cover) → offer to scaffold a new pack.

#### Output format

```
## What I learned about your usage
- 4–6 bullets describing the patterns observed.

## Suggested defaults to save
| Setting | Current | Suggested | Why |
|---------|---------|-----------|-----|

## Skills you may not be using yet
- One per skill in the suite the user hasn't invoked recently, with one sentence on the moment it would help.

## Packs and personas to add
- Each: a new product pack, industry pack, or persona that observed usage suggests would close a gap.

## Stale state to refresh
- Customer profile age, cache age, model freshness gate — each with the one-line action.

## Top 3 changes
1. ... (the change + the one-command path to make it)
2. ...
3. ...
```

If the workspace has no saved state yet (a fresh clone), say so plainly,
suggest running `/focus-group` once with a real prompt, and offer to
re-run this audit after that first invocation populates the config and
history files.

## Composing with the rest of the suite

- After `/focus-group` produces a report, pipe it straight in:
  `/how-can-this-be-improved .scratch/focus-group/2026-05-21-acme-qbr.md`.
- Before publishing a draft, `/how-can-this-be-improved <draft>` then run
  the suggestions through `/cross-ai-review` for a fact-check on any
  factual changes you made.
- For the skill-audit mode, follow up with the actual edits (or ask
  Claude to make them) and then re-run this skill — it should converge
  on "no further improvements found" after a pass or two.

## Privacy and scope

- This skill **does not call external models** on its own. It reads
  files in the workspace and writes a report inline.
- It **never modifies files** without explicit user approval. Mode B
  audits produce recommendations, not edits.
- It **never sends content off-machine**. If you want the audit
  fact-checked against another model, the user explicitly chains it
  through `/cross-ai-review`.

## Edge cases

- **File doesn't exist** — say so plainly; do not attempt the audit.
- **Skill name not recognised** — list the valid skill names and ask
  which the user meant.
- **Workspace fully empty (Mode C)** — say so and suggest a first
  `/focus-group` run before re-invoking.
- **File is binary / unparseable** — say so and ask the user to extract
  the text content first (e.g., for a PDF, point them at `/download` or
  a manual extract).
