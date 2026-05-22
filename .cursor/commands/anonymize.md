---
name: anonymize
description: Bidirectional placeholder anonymization for LLM-bound text — scrub customer names, PII, financial figures, and other identifying data into placeholders before they reach external LLMs; restore real values after the response comes back. Library called by /focus-group, /slackbot, /cross-ai-review; also usable standalone via /anonymize <paste>. Local map never leaves the laptop. Aggressive scrub posture (when in doubt, scrub).
---

# /anonymize — Cursor shim

Thin shim that delegates to the canonical skill at
[`.claude/skills/anonymize/`](../../.claude/skills/anonymize/).

## Behavior

When the user invokes `/anonymize` (with `scrub`, `restore`, `inspect`, or
`reset` subcommand, or any text to sanitize):

1. **Read the canonical SKILL.md** at
   [`.claude/skills/anonymize/SKILL.md`](../../.claude/skills/anonymize/SKILL.md)
   and follow it.
2. **Pick the runtime** via
   [`.claude/skills/anonymize/scripts/detect-runtime.sh`](../../.claude/skills/anonymize/scripts/detect-runtime.sh)
   (or `detect-runtime.ps1` on Windows native). Use the highest-tier
   script available (Python > Node > PowerShell > shell). If `none`,
   surface the install offer per
   [`../../.claude/skills/focus-group/references/usage.md`](../../.claude/skills/focus-group/references/usage.md)
   §8.
3. **Help mode.** `/anonymize help` prints the SKILL.md walkthrough and
   stops.

## Pass-through

Any arguments the user passes go directly to the chosen script (one of
anonymize.py / anonymize.mjs / anonymize.ps1 / anonymize.sh). The shim
does not reinterpret them.

## Critical posture

Never send a prompt containing customer-identifying data to any
external LLM (Claude, Gemini, Codex, opencode, anything else) without
running it through `/anonymize` first when in a context where it's
available. See
[`../../.claude/skills/anonymize/references/scrub-patterns.md`](../../.claude/skills/anonymize/references/scrub-patterns.md)
for what counts as identifying.
