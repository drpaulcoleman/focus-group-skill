---
name: slackbot
description: >-
  Build an anonymized customer profile from the user's Slack workspace via
  the Slack MCP server — surface deal-channel conversations, customer
  mentions across channels the user belongs to, and the recent sentiment /
  open-thread shape — then run the result through /anonymize so the profile
  feeds into /focus-group without any customer-identifying data ever
  reaching an external LLM. Invoke when the user names a customer
  (especially an existing customer or active prospect) AND the Slack MCP
  is configured. Scope is conservative: only channels the user is a member
  of, never DMs. Use this proactively at /focus-group Step 3c (current
  customer branch) when Slack MCP is detected. Also usable standalone via
  /slackbot <customer-name> to produce a profile that can be saved and
  reused across focus-group runs.
---

# /slackbot — Slack-Sourced Customer Profile (Anonymized)

`/slackbot` queries the user's Slack workspace (via the Slack MCP) for
mentions of a named customer, summarizes what's actively being discussed,
runs the result through `/anonymize` so nothing identifiable leaks, and
returns a structured profile that `/focus-group` can use as grounding.

The output answers questions like:
- Which deal channels mention this customer?
- Who on the account team has been talking about them?
- What's the current shape of open conversations (renewal? escalation? expansion? quiet)?
- Is there a Slack Connect channel with the customer?

All of it sanitized through `/anonymize` before any persona prompt or
synthesis sees it.

## When to invoke it

- **Automatically by `/focus-group` Step 3c.** When the user picks "current
  customer" in the customer-grounding gate and a Slack MCP server is
  detected, `/focus-group` proposes running `/slackbot` against the named
  customer as one of the per-data-type consent boxes.
- **Standalone:** `/slackbot <customer-name>` produces a profile to
  `.org-profile-raw/<customer-slug>/slack.md` (git-ignored), suitable for
  reuse across multiple `/focus-group` runs.

## Three modes the skill answers in

### Help mode
If the user invokes `/slackbot help` / `--help` / `-h` / `?`, do NOT query
Slack — print the user-facing walkthrough and stop.

### Profile mode (default)
`/slackbot <customer-name>` — query, summarize, anonymize, save.

### Inspect mode
`/slackbot inspect <customer-name>` — show a saved customer profile
without re-querying Slack.

- **Source file:** prefers `.org-profile-raw/<slug>/slack.anonymized.md`
  (the redacted version the rest of the suite consumes). Pass `--raw`
  to view `.org-profile-raw/<slug>/slack.md` instead (the unredacted
  local copy; never share its contents outside the laptop).
- **No saved profile:** if neither file exists for that customer, the
  skill says so plainly and offers to run Profile mode now (one-line
  confirm: "I haven't profiled <customer> yet. Run a fresh profile?").
- **Multiple customers match:** list the matches and ask the user to
  disambiguate; do not pick one silently.
- **Output shape:** pretty-print the markdown summary; do not dump
  the raw JSON of the underlying MCP-call captures.

## Prerequisites and detection

The skill requires a **Slack MCP server** configured in the user's MCP
config. Detection: any MCP server with `slack` in its name or a known
Slack server ID. The skill calls MCP tools (e.g., `conversations.list`,
`conversations.history`, `search.messages`) to query channels and
messages.

If no Slack MCP server is configured, the skill stops and routes to
the install walkthrough at
[`references/install-walkthrough.md`](references/install-walkthrough.md)
via the four-option menu in
[`../focus-group/references/usage.md`](../focus-group/references/usage.md)
§8 (walk through Slack MCP setup now / skip for this run / never ask
again).

> **Note for sales-team users:** the Slack CLI is a developer tool
> for building Slack apps and isn't relevant here. The Slack MCP
> server is the right integration for grounding a focus-group panel
> in your team's Slack context.

## The workflow

### 1. Resolve the customer name
The customer name (passed as the slash-command argument, or read from the
active `.org-profile.json`) becomes the search query. Optionally accepts
common aliases: `/slackbot "Providence Health"`, `/slackbot
providence-health`, `/slackbot --org-profile` (reads the saved customer
name).

### 2. Discover candidate channels (member-only)

**Scope rule (load-bearing):** the skill queries **only channels the
user is a member of**. Never DMs. Never channels they have no membership
in. This protects against accidentally surfacing things the user
shouldn't have access to and against leaking confidential channel
membership patterns to the LLM later.

The query shape (via MCP):
1. `conversations.list` filtered to `is_member: true`, types
   `public_channel,private_channel`.
2. For each candidate channel, search for the customer name (and
   conventional variants — drop "Inc/LLC/Corp" suffixes, try a slugified
   form).
3. For channel names that contain the customer name (deal channels,
   Slack Connect channels), include them in full; for other channels,
   only include the matching messages within a recent time window
   (default last 30 days).

### 3. Build the raw profile (local-only)

The skill assembles a structured profile in
`.org-profile-raw/<customer-slug>/slack.md` (git-ignored). Sections:

- **Matched channels** — channel names and a one-line membership/purpose hint.
- **Mention timeline** — bullets of customer mentions (date, channel, message excerpt, author), most recent first, last 30 days by default.
- **Open threads** — threads from the last 90 days that look stalled
  (last activity > 14 days, no resolution emoji/closing message).
- **Sentiment signal** — a rough read on tone (escalation language, renewal
  hand-off language, churn risk markers, expansion-opportunity markers).
  Heuristic only — say so plainly in the output.
- **People in the conversation** — Slack handles, account-team
  vs. customer-side (Slack Connect detection).
- **Slack Connect channels** — listed separately if any exist; these are
  the channels the customer is also in.

### 4. Run the profile through `/anonymize`

Call `anonymize.py scrub` with `--scrub <customer-name>` plus all detected
person names from the profile passed as `--scrub <name>` (Layer 1, always
wins). The result lands at
`.org-profile-raw/<customer-slug>/slack.anonymized.md`.

### 5. Present an approval summary to the user

Show the user:
- Channel count and a 2-3 line summary per channel (with placeholders).
- The open-threads list (with placeholders).
- The sentiment read.
- *"This summary is what your panel will see. Approve, edit, or reject?"*

On approval, the anonymized summary is merged into the active
`.org-profile.json`'s `internal_data.approved_summary`.

## Errors

Apply the err-doctrine in
[`../focus-group/references/err-doctrine.md`](../focus-group/references/err-doctrine.md):
- Slack MCP unauthorized → name what failed, suggest re-running the
  Slack MCP login flow (the install walkthrough has the exact steps),
  never paste a raw stack trace.
- Slack MCP returns 0 channels for the search → tell the user plainly
  ("no mentions of <customer> in any channel you're a member of in the
  last 30 days"); offer to widen the window (90 / 180 days) or skip.
- Anonymize call fails (e.g., the script is missing) → fall back to
  saving the RAW profile only, never the anonymized one, and refuse to
  hand it onward to `/focus-group` until the anonymize step succeeds.
- Slack MCP returns 429 / rate-limited → stop, save what was already
  fetched as a partial profile, and report plainly: "Slack throttled
  us after N channels / M messages — saved a partial profile.
  Resume in K minutes?" Never silently truncate or pretend the partial
  result is complete; mark the saved file with a `partial: true`
  header so downstream consumers know not to draw conclusions from
  absent channels.
- User is a member of zero channels (or all channels are private and
  the MCP token doesn't have access) → say so plainly and offer to
  walk the user through the OAuth scope / channel-invite path so the
  bot has something to read.

## Privacy posture

- **Member-only scope:** never queries channels the user isn't already in.
- **Never DMs:** the skill never queries direct messages, even if the
  MCP server exposes a tool for it.
- **Local-only raw:** the raw profile (with real names, channel names,
  message text) lives in git-ignored `.org-profile-raw/`. It never
  leaves the laptop.
- **Anonymize before any model:** the only profile that reaches a
  model is the anonymized version, after the user approves the summary.
- **No telemetry.** The skill does not phone home in any form.

## CLI shape (if invoked outside Claude Code via a script)

There is no Python script for `/slackbot` — the skill operates by calling
the Slack MCP server's tools from inside the agent loop. (MCP calls are
the right interface; there's no value in re-implementing them in
Python.) If a user wants to script this, the recommended path is to
invoke the Slack MCP server directly and pipe the result through
`anonymize.py scrub`.

## What the skill is NOT

- It is not a Slack notifications integration. It does not post anything
  to Slack. It is read-only.
- It is not a Slack search across the whole workspace; it respects
  member-only scope by design.
- It is not a substitute for `/focus-group` Step 3c's per-data consent
  flow. It is one of several data sources the consent flow can offer.

## References

- [`../focus-group/references/org-profile-schema.md`](../focus-group/references/org-profile-schema.md) — how the anonymized profile feeds into `.org-profile.json` and the persona-prompt grounding block.
- [`../anonymize/SKILL.md`](../anonymize/SKILL.md) — the anonymization contract.
- [`../focus-group/references/err-doctrine.md`](../focus-group/references/err-doctrine.md) — the err-doctrine voice.
- [`references/install-walkthrough.md`](references/install-walkthrough.md) — how to set up the Slack MCP server (for when the user hits the install offer).
