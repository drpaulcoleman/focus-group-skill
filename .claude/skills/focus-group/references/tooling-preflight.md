# Tooling Preflight — Step 0 Probe Details

Step 0 of the `/focus-group` pipeline (and the first thing `/cross-ai-review`'s
`--check` mode does) is a quick probe of what's available on the host so
the rest of the workflow can pick the right channels and surface the right
install offers at the right moments.

## What the probe checks

| Category | Tools probed | What we record |
|----------|--------------|----------------|
| **AI CLIs** | `claude`, `codex`, `gemini`, `opencode` | Which are on PATH; their `--version` if cheap to get. Used by `/cross-ai-review` and `/focus-group` Stage B/C model distribution. |
| **Multi-Claude fallback eligibility** | `claude` only — checks the configured `multi_claude_fallback.primary` and `secondary` model ids resolve | Used when no other CLI is present. |
| **Headless browser runtimes** | Python+Playwright, Node+Playwright/Puppeteer, PowerShell+Edge, Chrome/Chromium/chrome.exe, `curl`, `wget` | Used by `/download`. |
| **Salesforce integrations** | `sf` on PATH; `sf org list` returns ≥1 authorized org; MCP config has a `salesforce`-named server | Used by `/focus-group` Step 3c. |
| **Slack integrations** | `slack` on PATH; MCP config has a `slack`-named server | Used by `/focus-group` Step 3c. |
| **Version control** | `git` on PATH; `.git/` in workspace | Used by the session-end `git` install offer in `/download` (soft prompt). |
| **Anonymize runtime** | Python 3 / Node.js / PowerShell / POSIX shell — runs the `/anonymize` skill's `detect-runtime.sh` (POSIX) or `detect-runtime.ps1` (Windows) | Used by `/focus-group` **Step 8.0 pre-dispatch gate**. Records `preferred` runtime + `degraded: true/false` (degraded = PowerShell or shell, regex-only, no L3 heuristic). When `available: false`, the gate blocks any external CLI dispatch on customer-grounded content until the user picks an install or `--single-ai` fallback. |

## What the probe does NOT do

- **Never prompts for installs at probe time.** Install offers fire at the
  moment of concrete value (an empty page returned, a named customer with
  no `sf`, etc.). See [usage.md](usage.md) §8 for the trigger table.
- **Never logs in or authenticates anything.** If `sf` is installed but no
  orgs are connected, that's reported; the skill does not run `sf org
  login`. The user does.
- **Never sends a probe result anywhere.** The probe is local and silent.

## Where the probe writes

The probe writes a human-readable runtime card to `references/_runtime.md`
on first run per workspace (and refreshes it when the user runs `/focus-group
config` or asks). The card is short — a checklist the user can scan to
understand what the skill detected and what they're missing.

Example `references/_runtime.md`:

```
# Runtime probe (2026-05-20)

AI CLIs detected:
  ✓ claude          (claude-opus-4-7)
  ✗ codex           — not installed
  ✗ gemini          — not installed
  ✗ opencode        — not installed
  → Multi-Claude fallback configured: claude-opus-4-7 + claude-sonnet-4-6

Headless browser runtimes detected:
  ✗ Python + Playwright — Python found, Playwright not installed
  ✗ Node + Playwright/Puppeteer — Node found, neither installed
  ✓ Microsoft Edge (Windows 11) — headless mode available
  → /download will use Edge headless.

Salesforce integrations:
  ✗ sf CLI — not installed
  ✗ Salesforce MCP — no server configured
  → If you profile an existing customer, you'll see an install offer.

Slack integrations:
  ✗ Slack MCP — not installed
  ✗ Slack MCP — no server configured

Version control:
  ✓ git on PATH
  ✗ .git/ in workspace — not yet a git repo
  → If you generate files here, you'll see a soft offer at session end.

Anonymize runtime:
  ✓ Python 3.12  (preferred — full L1+L2+L3 detection)
  ✓ Node.js 22   (also available — would be used as fallback)
  → Step 8.0 pre-dispatch gate will pass cleanly when customer data is in scope.
```

## Persistence

The probe result is cached for **24 hours** in
`.claude/skills/focus-group/.focus-group-cache.json`. The cache invalidates
immediately on any failed CLI/MCP call (so removing a tool is picked up the
next time the skill tries to use it). The ≈monthly model-freshness gate
re-runs the probe as part of its check. The user can force a fresh probe
with `/focus-group --probe`.
