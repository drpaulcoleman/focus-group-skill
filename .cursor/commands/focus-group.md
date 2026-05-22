---
name: focus-group
description: Multi-persona, multi-model review panel for Salesforce sales conversations. Convenes AE / SE / Industry Specialist / Architect / buyer-side / industry-specific personas; grounds in customer profile (by name, by culture & size, or skip); produces a synthesized report with accuracy score and citations.
---

# /focus-group — Cursor shim

This is a thin shim that delegates to the canonical skill content shipped
under `.claude/skills/focus-group/`. The shim exists because Cursor reads
`.cursor/commands/` for slash commands and Claude Code reads
`.claude/skills/` — same skill, two host conventions.

## Behavior

When the user invokes `/focus-group` (with any arguments — file paths, pasted
content, URLs, switches like `--product`, `--industry`, `--generic`,
`--require-citations`, etc.):

1. **Read the canonical SKILL.md** at
   [`.claude/skills/focus-group/SKILL.md`](../../.claude/skills/focus-group/SKILL.md)
   and follow its full 11-step pipeline. It is the source of truth — the
   shim does not override or summarize it.
2. **Read the referenced sub-docs** as the pipeline says, including but
   not limited to:
   - [`personas/`](../../.claude/skills/focus-group/personas/) — every persona
     file the recommender or the user picks.
   - [`references/usage.md`](../../.claude/skills/focus-group/references/usage.md)
     for the `help` flow.
   - [`references/persona-roster.md`](../../.claude/skills/focus-group/references/persona-roster.md)
     for panel composition.
   - [`references/product-packs/`](../../.claude/skills/focus-group/references/product-packs/)
     and
     [`references/industry-packs/`](../../.claude/skills/focus-group/references/industry-packs/)
     for grounding.
   - [`references/org-profile-schema.md`](../../.claude/skills/focus-group/references/org-profile-schema.md)
     for the customer-grounding gate (Step 3).
   - [`references/multi-model-panel.md`](../../.claude/skills/focus-group/references/multi-model-panel.md)
     for channel distribution (Cursor users still benefit from the
     multi-Claude fallback when only the Claude CLI is reachable).
   - [`references/output-format.md`](../../.claude/skills/focus-group/references/output-format.md)
     for the final report.
   - [`references/err-doctrine.md`](../../.claude/skills/focus-group/references/err-doctrine.md)
     for any error path.
3. **Pass through user arguments verbatim.** The shim does not
   reinterpret them.
4. **Help mode.** When the user invokes `/focus-group help` / `--help` / `-h`
   / `?`, do NOT run a panel — read
   [`references/usage.md`](../../.claude/skills/focus-group/references/usage.md)
   and walk the user through it. Same contract as Claude Code.
5. **Config mode.** `/focus-group config` reads/writes
   [`.claude/skills/focus-group/config.json`](../../.claude/skills/focus-group/config.json) —
   same file the Claude Code path uses, so settings carry across hosts.

## Why a shim instead of a copy

The shim keeps `.claude/skills/focus-group/SKILL.md` as the single source of
truth. Edits there flow to both hosts without a sync step. If you find a
case where the shim approach drops something Cursor needs, please file an
issue against the repo — the fallback plan is generated twin files
written by `scripts/sync-cursor.{sh,ps1}`.

## Note for the Cursor agent

Cursor is the host environment — you don't add another model channel to
the panel. `/cross-ai-review` handles model dispatch through the same
CLIs (`claude`, `codex`, `gemini`, `opencode`) that Claude Code uses,
and the multi-Claude fallback (Opus + Sonnet) covers the case where only
the Claude CLI is reachable. Cursor's own model picker is separate from
the cross-AI fan-out and doesn't need to be addressed here.
