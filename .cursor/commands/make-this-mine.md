---
name: make-this-mine
description: Guided personalization interview that tunes /focus-group to your role, deal types, industry, and noise preferences. Writes to focus-group config.json (single source of truth).
---

# /make-this-mine — Cursor shim

This is a thin shim that delegates to the canonical skill content shipped
under `.claude/skills/make-this-mine/`. The shim exists because Cursor reads
`.cursor/commands/` for slash commands and Claude Code reads
`.claude/skills/` — same skill, two host conventions.

## Behavior

When the user invokes `/make-this-mine`:

1. **Read the canonical SKILL.md** at
   [`.claude/skills/make-this-mine/SKILL.md`](../../.claude/skills/make-this-mine/SKILL.md)
   and follow its interview flow. It is the source of truth.
2. **Write personalization keys** to the existing
   `.claude/skills/focus-group/config.json` — never to a separate file.
3. **Present the summary card** at the end showing what was saved.
