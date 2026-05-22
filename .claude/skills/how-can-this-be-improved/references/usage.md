# How to use `/how-can-this-be-improved`

This is the user-facing walkthrough the skill prints when you run
`/how-can-this-be-improved help` (or `--help`, `-h`, `?`) or ask how the
skill works.

## What `/how-can-this-be-improved` is

`/how-can-this-be-improved` is the **sharpening pass** that sits one
step beyond the rest of the suite. Instead of producing new output, it
looks at what you already have — a report, a skill, or the cumulative
shape of how you've been using these skills — and tells you what to
change to make the next run noticeably better.

The primary target is the **culmination of a `/focus-group` panel** —
the final report that pulls every persona's feedback together. Run this
on that report before you act on it or send anything on, and you'll
catch the hedges, the missing citations, the buried bottom line, and the
audience the panel didn't cover before they reach a customer.

It works on any markdown / text file, though — drafts, QBRs, emails,
specs, talk-tracks, demo scripts — so use it wherever you want a
second-pass sharpening.

It is **explicit-trigger** — it runs only when you invoke it.
**Local-only** — it never calls external models on its own. If you want
the recommendations fact-checked, chain through `/cross-ai-review`.

## How to invoke it

| You type | What happens |
|----------|--------------|
| `/how-can-this-be-improved <path-to-file>` | **Mode A — file review.** Reads the file and returns what to sharpen, cut, add, or back with a citation. Primary use: a saved `/focus-group` panel report under `.scratch/focus-group/`. |
| `/how-can-this-be-improved <skill-name>` | **Mode B — skill audit.** Reads the skill's `SKILL.md` + reference files and reports drift between docs and implementation, underspecified spots, overloaded surfaces, missing edge cases, and cross-skill inconsistency. Valid names: `focus-group`, `download`, `cross-ai-review`, `anonymize`, `slackbot`, `how-can-this-be-improved`. |
| `/how-can-this-be-improved` *(no argument)* | **Mode C — user-pattern review.** Reads what the workspace knows about you (`config.json`, `.focus-group-cache.json`, recent `.scratch/focus-group/` history) and recommends targeted improvements to the suite based on observed usage. |
| `/how-can-this-be-improved help` | Shows this guide. |

## Mode A — Review a file

**Most common use:** sharpening the panel report `/focus-group` just
produced before you act on it.

```
/focus-group review my QBR for Pacific Grants Alliance
   ...panel runs, writes the report to .scratch/focus-group/2026-05-21-pacific-grants-qbr.md...

/how-can-this-be-improved .scratch/focus-group/2026-05-21-pacific-grants-qbr.md
```

You get back:

- **What's working** — 3–5 things to keep and not touch.
- **Sharpen** — table of (where, issue, suggested edit) entries.
- **Cut** — chunks to remove, with the reason.
- **Add** — what's missing, where to put it, starter draft.
- **Cite or soften** — factual claims without backing, with a
  *cite / soften / drop* recommendation for each.
- **Bottom-line check** — does the document say what it needs to say?
- **The single highest-leverage change** — the one edit that lifts the
  document the most.

Same flow works on any draft you'd want a second-pass sharpening on —
proposals, emails, talk-tracks, demo scripts, specs, architecture
sketches. Markdown or plain text, both fine.

## Mode B — Audit a skill

```
/how-can-this-be-improved focus-group
```

You get back:

- **Strengths** — what's working, don't disturb.
- **Drift between docs and implementation** — where the SKILL.md
  promises a switch or behavior the code/files don't deliver (or
  vice-versa).
- **Underspecified** — where a fresh Claude would still have questions.
- **Overloaded** — sections trying to do too many things.
- **Edge cases not handled** — failure modes the skill should name but
  doesn't.
- **Cross-skill consistency** — flag names, output sections, file
  conventions that don't match the other skills in the suite.
- **Top 3 changes** — prioritised, with one sentence each on why.

Ends with one concrete next change in `Edit/Write`-ready form (file path
+ rough nature of the edit) so you can either ask Claude to make it or
do it yourself.

## Mode C — User-pattern review

```
/how-can-this-be-improved
```

The skill looks at what your workspace knows about how you've been using
the suite:

- Your saved role and default packs (`.claude/skills/focus-group/config.json`).
- The CLIs / MCPs detected on this machine
  (`.claude/skills/focus-group/.focus-group-cache.json`).
- Past panel reports under `.scratch/focus-group/`.
- The saved customer profile (`.claude/skills/focus-group/.org-profile.json`).
- How much anonymization traffic has gone through the suite
  (`.anonymize/map.json` if present, default location is the workspace root).

It surfaces patterns and recommends targeted improvements:

- "You ran six panels on Health Cloud this month — would loading
  `--industry healthcare-life-sciences` as the saved default help?"
- "You've swapped InfoSec Officer into every Buyer panel — consider
  editing the quick-pick to include them by default."
- "Three of your last four reports flagged citation gaps — try
  `--require-citations` as the default for a week."
- "You haven't invoked `/cross-ai-review` since the install. Is the
  Gemini CLI behaving on this machine?"
- "Your saved customer profile is 23 days old. Refresh?"

## Composing with the rest of the suite

- **Sharpening flow** (the bread and butter):
  `/focus-group <subject>` → report at `.scratch/focus-group/<date>-<slug>.md`
  → `/how-can-this-be-improved <that-path>` → sharpened version → act / send.

- **Trust-but-verify flow** when the sharpening adds new factual
  claims: pass the revised doc through `/cross-ai-review` before
  sending.

- **Suite maintenance flow** every few weeks:
  `/how-can-this-be-improved` (no arg) → see what patterns the suite
  hasn't caught up with → `/how-can-this-be-improved <skill-name>` on
  any skill the user-pattern review flagged → apply the fixes.

## Privacy and scope

- This skill **does not call external models** on its own. It reads
  files in the workspace and writes the report inline.
- It **never modifies files** without explicit user approval. The
  output is recommendations — not edits. If you want the changes
  applied, say "apply" or "make the changes" and Claude will use the
  `Edit` tool.
- It **never sends content off-machine**. The workspace is the limit.

## Edge cases

| Situation | What the skill does |
|-----------|---------------------|
| File path doesn't exist | Says so plainly; does not attempt the audit. |
| Skill name not recognised | Lists the valid skill names and asks which you meant. |
| Workspace fully empty (Mode C) | Says so; suggests a first `/focus-group` run before re-invoking. |
| File is binary / unparseable | Says so; asks you to extract the text content (e.g., for a PDF, point at `/download` or a manual extract). |
| File is huge (>2,000 lines) | Tells you which sections it reviewed in depth and which it skimmed; offers a follow-up pass focused on the skimmed sections. |
| You ask it to apply the edits | Asks for one-line confirmation per edit batch (or a single "approve all"), then uses `Edit` to apply. |
