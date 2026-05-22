---
name: slackbot
description: Build an anonymized customer profile from the user's Slack workspace via the Slack MCP — surface deal-channel conversations, customer mentions across channels the user belongs to, recent sentiment / open-thread shape — then run the result through /anonymize so the profile feeds into /focus-group without any customer-identifying data ever reaching an external LLM. Member-only scope, never DMs.
---

# /slackbot — Cursor shim

Thin shim that delegates to the canonical skill at
[`.claude/skills/slackbot/`](../../.claude/skills/slackbot/).

## Behavior

When the user invokes `/slackbot <customer-name>`:

1. **Read the canonical SKILL.md** at
   [`.claude/skills/slackbot/SKILL.md`](../../.claude/skills/slackbot/SKILL.md)
   and follow its 5-step workflow.
2. **Detect a Slack MCP server** in the user's MCP config — any server
   with `slack` in its name or a known Slack server ID. Do NOT probe
   PATH: MCP servers are config-file entries (typically `~/.claude/mcp.json`
   or a project `.mcp.json`), not standalone binaries. If no Slack MCP
   server is configured, route to the install walkthrough at
   [`.claude/skills/slackbot/references/install-walkthrough.md`](../../.claude/skills/slackbot/references/install-walkthrough.md).
   The Slack desktop `slack.exe` is a chat client, not an automation
   tool — never treat it as a positive detection signal.
3. **Scope is member-only.** Never query DMs or channels the user isn't
   already a member of. This is non-negotiable.
4. **Run the raw profile through `/anonymize`** before any persona prompt
   or model call sees it. Apply the SKILL.md's per-data consent step
   before merging into `.org-profile.json`.
5. **Help mode.** `/slackbot help` prints the SKILL.md walkthrough and
   stops.

## Pass-through

Any arguments the user passes go directly through to the underlying
flow. The shim does not reinterpret them.
