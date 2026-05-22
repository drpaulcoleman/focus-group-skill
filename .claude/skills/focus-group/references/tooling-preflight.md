# Tooling Preflight — Step 0 Probe Details

Step 0 of the `/focus-group` pipeline (and the first thing `/cross-ai-review`'s
`--check` mode does) is a quick probe of what's available on the host so
the rest of the workflow can pick the right channels and surface the right
install offers at the right moments.

## What the probe checks

| Category | Tools probed | What we record |
|----------|--------------|----------------|
| **AI CLIs** | `claude`, `codex`, `gemini`, `opencode` | (a) Which are on PATH (records `present: true/false`); (b) for each present CLI, a single low-cost health-check call ("ok?", 8 s timeout) to confirm it can actually answer — records `operational: true/false` plus `health: "ok" / "unauth" / "quota" / "error" / "missing"` and `last_error`. The whole batch is run in parallel with a ~10 s overall cap. **Operational, not present, gates round-robin assignment.** |
| **Multi-Claude fallback eligibility** | `claude` only — checks the configured `multi_claude_fallback.primary` and `secondary` model ids resolve | Used when no other CLI is `present && operational` (covers missing CLIs *and* present-but-`unauth`/`quota`/`error` CLIs). |
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
  ✓ claude          v1.0.84    (claude-opus-4-7)              operational
  ⚠ codex           v0.3.1     (gpt-5.5)                      present but unauth — run `codex login`
                                                              update available: 0.3.1 → 0.4.0
  ⚠ gemini          v0.5.2     (gemini-3.1-pro-preview)       present but quota-exhausted (retry tomorrow)
  ✗ opencode        — not installed
  → Multi-Claude fallback configured: claude-opus-4-7 + claude-sonnet-4-6
    (cross-vendor cohort is non-operational; fallback engaged for diversity)
  → 1 update available (codex). Run `/focus-group --probe` to re-check after updating.

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

## Operational health states

The probe records one of these `health` values per CLI. Each maps to a
specific dispatch behavior and a specific remediation hint surfaced in
the report header when the multi-Claude fallback engages:

| `health` | Meaning | Dispatch behavior | Surfaced remediation |
|----------|---------|-------------------|----------------------|
| `ok` | Health check passed (exit 0, non-empty stdout) | Eligible for round-robin assignment. | — |
| `unauth` | Failed with `not signed in` / `not authenticated` / `missing API key` / `unauthorized` (case-insensitive) | Excluded from round-robin; counts toward "no operational vendor" trigger. | "Run `<cli> login` (or set the provider API key) to add it back to the panel." |
| `quota` | Failed with `quota` / `rate limit` / `429` / `usage limit` / `out of credit` | Excluded; counts toward fallback trigger. | "Account is rate-limited or out of credit; retry tomorrow or top up." |
| `error` | Failed for some other reason (timeout, segfault, missing dependency) | Excluded; counts toward fallback trigger. | "Last error: `<truncated>` — run `/focus-group --probe` after fixing." |
| `missing` | CLI is not on PATH | Excluded; counts toward fallback trigger; not surfaced (install-offer triggers handle this elsewhere). | — |

The probe parses **stderr first, then stdout** for these patterns
because most CLIs write auth/quota errors to stderr. Pattern matching
is case-insensitive and conservative — when in doubt, the probe records
`error` (not `unauth` or `quota`) so the user sees the raw message and
can decide.

## Staleness check (orthogonal to operational state)

Alongside the health check, the probe captures `version` and
`latest_version` for each present CLI and computes
`update_available: true/false`. Staleness is independent of operational
state — a CLI can be operational *and* stale.

When one or more operational CLIs have updates available, SKILL.md
Step 0 surfaces a **single** consolidated offer at the end of the probe
(see SKILL.md "Staleness check"). The offer is user-confirmed and runs
the per-CLI update command on approval; it never auto-runs. The offer
suppresses for 24 h per CLI on dismissal, and is never shown under
`--quick`/`--fast` or for non-operational CLIs (fix the operational
issue first).

The probe never reaches out to a package registry just to check for
updates — it relies on signals the CLI itself emits (startup banner,
`--version`, an opt-in `update --check` subcommand). When no signal is
available, `latest_version` stays `null` and `update_available` stays
`false`. Silence is the safe default.

## Persistence

The probe result is cached for **24 hours** in
`.claude/skills/focus-group/.focus-group-cache.json` (schema version 2 —
adds `present` / `operational` / `health` / `version` /
`latest_version` / `update_available` fields per CLI; older version-1
caches are re-probed once on first read).

The cache invalidates immediately on any failed CLI/MCP call (so
removing a tool *or* its quota running out is picked up the next time
the skill tries to use it — see SKILL.md "Runtime invalidation"). The
≈monthly model-freshness gate re-runs the probe as part of its check.
The user can force a fresh probe with `/focus-group --probe`.
