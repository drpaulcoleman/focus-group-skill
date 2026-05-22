---
name: download
description: Runtime-adaptive web/PDF/search harvester for /focus-group grounding. Fetches Salesforce Help / Trailhead / Architect / developer.salesforce.com and any other URL into a local references/ folder for AI context and citations. Uses Python+Playwright, Node+Playwright, PowerShell+Edge, Chrome headless, or curl/wget — whichever is installed.
---

# /download — Cursor shim

Thin shim that delegates to the canonical skill content at
[`.claude/skills/download/`](../../.claude/skills/download/).

## Behavior

When the user invokes `/download <url-or-topic>`:

1. **Read the canonical SKILL.md** at
   [`.claude/skills/download/SKILL.md`](../../.claude/skills/download/SKILL.md)
   and follow its full workflow (detect runtime → pick path → fetch /
   search → write to `references/<slug>/`).
2. **The bundled scripts** are at
   [`.claude/skills/download/scripts/`](../../.claude/skills/download/scripts/) —
   call them directly from the Cursor agent's shell tool:
   - `detect-runtime.sh` (POSIX sh; works under Git Bash / WSL on Windows
     and natively on macOS/Linux).
   - `harvest.py` (Python+Playwright; best JS-rendering).
   - `harvest.mjs` (Node+Playwright/Puppeteer; also full JS).
   - `harvest.ps1` (PowerShell+Edge; ships with Windows 11).
   - `harvest-chrome.sh` (Chrome headless; macOS / Linux / Windows).
   - `fetch-basic.sh` (curl/wget fallback; no JS).
3. **Help mode.** When the user invokes `/download help` / `--help` /
   `-h` / `?`, do NOT fetch anything — print the user-facing walkthrough
   from the canonical SKILL.md (including the plain-English explanation
   of why headless browsers exist).
4. **Salesforce-aware search.** When the topic looks Salesforce-flavored,
   add `help.salesforce.com`, `trailhead.salesforce.com`,
   `architect.salesforce.com`, `developer.salesforce.com/docs`, and
   `salesforce.stackexchange.com` to the search-engine chain. See the
   canonical SKILL.md for the full chain.
5. **Errors.** Apply the err-doctrine at
   [`.claude/skills/focus-group/references/err-doctrine.md`](../../.claude/skills/focus-group/references/err-doctrine.md):
   one plain-English cause sentence, what was done without the failing
   piece, one or two next steps, then *"If you'd like, paste the screen
   you see and I'll translate it."*

## Pass-through

Any arguments the user passes go directly to the harvest scripts. The
shim does not reinterpret them.
