---
name: how-can-this-be-improved
description: User-triggered improvement coach. Three modes — review a file (primary target: the culmination of a /focus-group panel report, but works on any markdown/text draft), audit a named skill in the suite for drift/underspecification/edge-cases, or (no argument) read what the workspace knows about the user and recommend targeted improvements to the suite based on observed usage patterns. Local-only; never calls external models on its own.
---

# /how-can-this-be-improved — Cursor shim

Thin shim that delegates to the canonical skill at
[`.claude/skills/how-can-this-be-improved/`](../../.claude/skills/how-can-this-be-improved/).

## Behavior

When the user invokes `/how-can-this-be-improved`:

1. **Read the canonical SKILL.md** at
   [`.claude/skills/how-can-this-be-improved/SKILL.md`](../../.claude/skills/how-can-this-be-improved/SKILL.md)
   and follow it.
2. **Argument routing:**
   - `help` / `--help` / `-h` / `?` → print the walkthrough; do not audit.
   - A path → Mode A (file review). Primary target is a panel report at
     `.scratch/focus-group/<date>-<slug>.md`, but any markdown / text
     file works.
   - A skill name (`focus-group`, `download`, `cross-ai-review`,
     `anonymize`, `slackbot`, `how-can-this-be-improved`) → Mode B
     (skill audit).
   - No argument → Mode C (user-pattern review).
3. **Output** goes inline to the chat. The skill never writes files
   without explicit user approval.

## Posture

- **Read-only by default.** Recommendations only — never edits files
  unless the user explicitly says "apply" / "make the changes".
- **Local-only.** Does not call external models. If the user wants the
  recommendations fact-checked, chain through `/cross-ai-review`.
- **Composes well with `/focus-group`.** The expected flow is
  `/focus-group <subject>` → produces report under `.scratch/focus-group/`
  → `/how-can-this-be-improved <that-report-path>` → sharpened version
  before the user sends it on.
