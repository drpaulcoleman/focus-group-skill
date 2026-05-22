# Slack MCP Setup — Plain-Language Walkthrough

This is what the skill presents when the user accepts the install offer
during `/focus-group` Step 3c or runs `/slackbot help install`.

## Why this helps you right now

You're trying to ground a focus-group panel on what your team has
actually been saying about this customer. Slack is where most of that
conversation lives. Without Slack MCP, the panel only knows what's in
Salesforce — useful, but it misses the Slack-thread tone, the
escalations, the side-channel chatter that says "this customer is
about to churn" or "champion just got promoted." About 5 minutes to
set up; the next focus-group run benefits immediately.

## What we're installing

A Slack MCP server is a small program your Claude Code (or Cursor)
session uses to talk to Slack on your behalf. You authorize it with
your Slack account; nothing else gets your credentials. The skill
never sees your password, never writes to Slack, and reads only the
channels you're already a member of.

There are several Slack MCP servers in the wild; the most widely-used
options as of writing:

- **`@modelcontextprotocol/server-slack`** — official-style, maintained.
- **Slack's own MCP** if your Slack workspace admin has rolled one out.

Pick one. The official-style server is the safe default.

## Three steps

### 1. Install the server

Open a terminal and run:

```sh
npm install -g @modelcontextprotocol/server-slack
```

(If `npm` isn't installed, the skill will route you to the Node.js
install walkthrough first. About 3 minutes.)

### 2. Get a Slack token

Go to https://api.slack.com/apps → **Create New App** → **From scratch**
→ name it "MCP — <your name>" → pick your workspace.

In the new app:
- **OAuth & Permissions** → scroll to **User Token Scopes** → add:
  - `channels:read` (list public channels)
  - `channels:history` (read messages in public channels you're in)
  - `groups:read` (list private channels you're in)
  - `groups:history` (read messages in private channels you're in)
  - `users:read` (resolve user IDs to names)
  - `search:read` (search across channels you're in)
- **Install to Workspace** → approve.
- Copy the **User OAuth Token** (starts with `xoxp-...`). Treat it
  like a password.

> *Why a User token, not a Bot token?* User tokens scope to what
> **you** can see — the same channels you'd see if you opened Slack.
> Bot tokens scope to what the bot was invited to. For "what's my team
> saying about this customer", User scope is the right model and
> preserves the member-only guarantee.

### 3. Register the server with Claude Code

Add a block to your Claude Code MCP config:

**Path:** `~/.claude/mcp.json` (or wherever Claude Code reads MCP servers
in your version; the install command's output tells you).

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_USER_TOKEN": "xoxp-...your-token-from-step-2..."
      }
    }
  }
}
```

Restart Claude Code (or Cursor). The skill will detect the Slack MCP
server on the next `/focus-group` or `/slackbot` invocation.

## Verifying it works

In Claude Code:

```
/slackbot <a customer name you've discussed in Slack>
```

If the setup worked, the skill reports something like:

> *"Found 3 channels in your workspace that mention <COMPANY_1>. Last
> mention: 4 days ago in <SLACK_CHANNEL_2>. Want to see the profile?"*

If it didn't work, paste whatever you see and the err-doctrine takes
it from there.

## If something fails

- **"Slack MCP not detected"** after restart — verify the JSON is
  valid (`cat ~/.claude/mcp.json | python -m json.tool` should print
  it cleanly), verify the path to your token has no typos.
- **"403" or "unauthorized"** — the token's scopes are wrong. Go back
  to the OAuth page and confirm all six scopes from step 2 are
  approved, then re-install the app to your workspace.
- **"No channels matched"** for a customer you're sure your team
  talks about — the user-token scope only sees channels you're a
  *member of*. If team conversations happen in channels you're not in,
  you won't see them. Join the channel, or accept this limit.

The err-doctrine close: *"If you'd like, paste the screen you see and
I'll translate it."*
