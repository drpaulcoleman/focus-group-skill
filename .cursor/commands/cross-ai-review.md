---
name: cross-ai-review
description: Fan one prompt out to whichever AI CLIs are installed (Claude, Codex, Gemini, opencode) — headless and in parallel — for an independent errors-and-omissions audit. Falls back to running two Claude models (Opus + Sonnet) when only Claude is installed. Produces an Accuracy score and a Citations block.
---

# /cross-ai-review — Cursor shim

Thin shim that delegates to the canonical skill at
[`.claude/skills/cross-ai-review/`](../../.claude/skills/cross-ai-review/).

## Behavior

When the user invokes `/cross-ai-review <prompt-or-draft>`:

1. **Read the canonical SKILL.md** at
   [`.claude/skills/cross-ai-review/SKILL.md`](../../.claude/skills/cross-ai-review/SKILL.md)
   and follow its four-step workflow (compose → run → read → synthesize).
2. **Call the bundled script** at
   [`.claude/skills/cross-ai-review/scripts/cross_ai.py`](../../.claude/skills/cross-ai-review/scripts/cross_ai.py)
   via your shell tool. Common shapes:
   ```
   python .claude/skills/cross-ai-review/scripts/cross_ai.py --check
   python .claude/skills/cross-ai-review/scripts/cross_ai.py --prompt-file <path> --label <slug>
   python .claude/skills/cross-ai-review/scripts/cross_ai.py --prompt-file <path> --require-citations
   python .claude/skills/cross-ai-review/scripts/cross_ai.py --prompt-file <path> --multi-claude
   ```
3. **Help mode.** When the user invokes `/cross-ai-review help` /
   `--help` / `-h` / `?`, do NOT run the script — print the user-facing
   walkthrough from the canonical SKILL.md.
4. **Read the report** at `~/.claude/cross-ai-runs/<run-id>/report.md`
   and produce the Cross-AI Review Summary the SKILL.md describes,
   including the Accuracy score and the Citations block.
5. **Errors.** Apply the err-doctrine at
   [`.claude/skills/focus-group/references/err-doctrine.md`](../../.claude/skills/focus-group/references/err-doctrine.md).

## Multi-Claude fallback

If only the `claude` CLI is reachable, the script automatically runs two
Claude models in parallel (Opus + Sonnet). Force this mode with
`--multi-claude` when other CLIs are installed but you want a
same-vendor double-check.

## Local config

The script reads
[`.claude/skills/cross-ai-review/config.json`](../../.claude/skills/cross-ai-review/config.json)
as a fallback when
[`.claude/skills/focus-group/config.json`](../../.claude/skills/focus-group/config.json)
is not present. Both files have the same shape; the `/focus-group` config
wins when both exist.

## Pass-through

Any arguments the user passes go directly to the script. The shim does
not reinterpret them.
