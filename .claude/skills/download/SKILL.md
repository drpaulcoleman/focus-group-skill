---
name: download
description: >-
  Download web pages, PDFs, Salesforce help / Trailhead / release-notes
  articles, and search results into the local references/ folder so AI sees
  fully rendered content, not empty JavaScript shells. Runtime-adaptive —
  detects and uses whatever is installed (Python+Playwright, Node.js+Playwright
  / Puppeteer, Windows PowerShell+Edge, Chrome / Chromium headless, or plain
  curl). Invoke whenever the user wants to fetch a URL, capture documentation,
  save an article or PDF, gather sources on a subject or topic, JS-render a
  page that came back empty, ground a /focus-group panel in real citations, or
  runs the /download command. Prefers a linked PDF over crawling many HTML
  pages; always includes Google Scholar for academic/technical subjects;
  always includes help.salesforce.com / trailhead.salesforce.com /
  architect.salesforce.com / developer.salesforce.com when the topic looks
  Salesforce-flavored. Proactively offers to install missing runtimes /
  Salesforce CLI / Salesforce MCP / Slack MCP at the moment the value is
  concrete, never automatically and never repeatedly.
---

# /download — Reference Harvester for Sales-Team AI Grounding

Brings reference material into the git-ignored `references/` folder so it can
**ground a `/focus-group` panel** (and be cited in the final report) instead of
having the AI guess from training data. Captures **fully rendered** content
(JS executed), so single-page apps and modern documentation sites — including
most of `help.salesforce.com` and `trailhead.salesforce.com` — come back with
real content instead of an empty shell.

The skill is **runtime-adaptive**. The host machine may have Python, Node.js,
PowerShell, or only a basic shell — the skill probes for what is installed and
uses the best available path. It assumes nothing and never auto-installs.

## Why we need a "headless browser" — in plain English

A lot of modern websites are not the printed cookbook the early web was. They
are more like a kitchen: when your browser visits the page, the site sends a
small starter dough and a recipe, and your browser actually *bakes* the page
in front of you using JavaScript. A simple URL fetch (`curl`, `wget`, the
basic-shell fallback) only grabs the starter dough — open it later and you see
an empty page with `<div id="app"></div>` and nothing useful inside.

A **headless browser** (Chrome, Edge, Playwright, Puppeteer) is a real browser
running invisibly. We send it to the page, let it bake the recipe, then read
the finished dish. That is why the skill prefers a headless runtime — and why
`help.salesforce.com`, `trailhead.salesforce.com`, and most modern Lightning /
LWC / React apps need one to return anything useful.

If only the no-JS fallback is available, modern pages may come back incomplete.
The skill will say so plainly and offer to walk the user through installing a
headless runtime (Python+Playwright, or Edge on Windows 11).

## Three modes the skill answers in

### Help mode
If the user invokes `/download help` / `--help` / `-h` / `?`, do NOT fetch
anything — print the user-facing walkthrough: what the skill does, how to
invoke it, the JS-rendering explanation above, the runtime chain, every
flag with a worked example, and the err-doctrine ("if something goes wrong,
paste the screen at me and I'll translate"). Then stop.

### Fetch mode (one URL)
`/download <url>` — fetch that URL into `references/<slug>/`.

### Search mode (a subject)
`/download <subject phrase>` (no URL) — run the search-engine chain, write a
ranked deduplicated result list to `references/_search/<subject-slug>.md`,
optionally harvest the top results.

## Safety rules — read before doing anything

1. **Never auto-install a runtime or library.** If the best path needs
   something not installed (Playwright, Edge, etc.), STOP, tell the user what
   is missing in plain English, show the install command, and ask if they
   want to install now or proceed with what's available. Do not run
   installers yourself.
2. **Never execute downloaded content.** Harvested files are *data*. Do not
   run, `eval`, `import`, or `source` anything downloaded. If a download is
   itself a script or executable, save it but do not run it, and flag it.
3. **Confirm before downloading script/executable files.** If a target URL
   resolves to a `.js / .sh / .ps1 / .exe / .msi / ...` artifact rather than
   a document or PDF, ask the user before saving it.
4. Stay within what the user asked for. Do not crawl an entire site unless
   explicitly asked.
5. **LinkedIn URLs short-circuit.** If the URL matches
   `(https?://)?(www\.)?linkedin\.com/(in|company|pub)/...`, do NOT
   attempt to fetch it — LinkedIn blocks scrapers, and an empty-shell
   artifact is worse than no artifact (it invites downstream
   hallucination). Instead, surface the local-files workaround documented
   in
   [`../focus-group/SKILL.md`](../focus-group/SKILL.md) Step 1 ("save the
   profile locally as a .md or .pdf and point me at the folder"). The
   same applies to any URL clearly behind a sign-in wall (corporate
   SharePoint, Box, paywalled domains).

## Step 1 — Detect the runtime

Run the probe and read its report:

```sh
sh .claude/skills/download/scripts/detect-runtime.sh
```

It prints which runtimes, browsers, and tools are available.

## Step 2 — Choose the path

Use the first row whose requirements the probe confirmed:

| Runtime present                            | Use this script              | JS rendering        |
|--------------------------------------------|------------------------------|---------------------|
| Python 3 **with Playwright**               | `scripts/harvest.py`         | Yes (best)          |
| Node.js **with Playwright/Puppeteer**      | `scripts/harvest.mjs`        | Yes                 |
| Windows PowerShell **+ Microsoft Edge**    | `scripts/harvest.ps1`        | Yes (Edge headless) |
| Chrome / Chromium (macOS, Linux, Windows)  | `scripts/harvest-chrome.sh`  | Yes (Chrome headless)|
| Only `curl` / `wget` (or none of the above)| `scripts/fetch-basic.sh`     | No — static HTML/PDF only |

If only the no-JS fallback is available, tell the user (using the analogy
above) and offer the §"Proactive install offers" walkthrough.

## Fetching a URL

```sh
# Python path
python scripts/harvest.py "<url>" --out references
# Node path
node scripts/harvest.mjs "<url>" --out references
# PowerShell path
powershell -File scripts/harvest.ps1 -Url "<url>" -Out references
# Chrome headless path
sh scripts/harvest-chrome.sh "<url>" references
# No-JS fallback
sh scripts/fetch-basic.sh "<url>" references
```

Each saves, under `references/<slug>/`:
- `page.html` — rendered DOM
- `page.md` — readable text extract
- `meta.json` — source URL, page title, retrieval date (for APA citation)

### Prefer the PDF

Long technical documentation is often published as a single consolidated PDF
*and* as a sprawling multi-page HTML portal. **Prefer the PDF** — it is one
file, fully self-contained, and far better AI context than crawling dozens of
shell pages.

The harvest scripts apply these rules automatically; apply them yourself if
fetching by hand:

- If the URL returns `application/pdf` (or ends in `.pdf`), download bytes directly.
- If the page links a PDF edition (anchor text like *PDF*, *Download PDF*,
  *Printable*, or an `href` ending `.pdf`), download that PDF instead of the page.
- Salesforce docs are a prime case: the Apex Reference Guide at
  `https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_ref_guide.htm`
  has a linked consolidated PDF — fetch the PDF, not the hundreds of `.htm` pages.

**Salesforce PDF shortcut map.** See
[references/salesforce-pdf-shortcuts.md](references/salesforce-pdf-shortcuts.md)
for a table of known doc sets with PDF versions. The correct workflow is:
fetch the HTML entry point → parse the PDF link from the page footer (the
release number changes 3x/year) → download the resolved PDF. Never hardcode
PDF URLs across sessions.

## Searching a subject

When given a subject/topic instead of a URL, gather candidate sources, then
harvest the promising ones.

### Search-engine fallback chain

Search engines aggressively block automated requests. Use this **ordered
fallback chain** — try the next engine when the current one returns a CAPTCHA,
empty results, or a block page. **Always use the best available renderer**
for each attempt.

**General-web engines (every search):**

| Priority | Engine | URL pattern | Notes |
|----------|--------|-------------|-------|
| 1 | **Google** | `https://www.google.com/search?q=<encoded>` | Requires JS rendering. Best result quality. |
| 2 | **Bing** | `https://www.bing.com/search?q=<encoded>` | Requires JS rendering. Good fallback. |
| 3 | **DuckDuckGo HTML** | `https://html.duckduckgo.com/html/?q=<encoded>` | No JS needed but frequently CAPTCHAs automated requests. |
| 4 | **Google Scholar** | `https://scholar.google.com/scholar?q=<encoded>` | Always attempt for academic/technical topics. Blocks aggressively. |

**Salesforce-aware engines (add when the topic matches `agentforce`, `apex`,
`lwc`, `salesforce`, `slack`, `tableau`, `mulesoft`, `data cloud`, `marketing
cloud`, `commerce cloud`, `service cloud`, `sales cloud`, `experience cloud`,
`field service`, `revenue cloud`, or any of the 16 Salesforce industry
slugs):**

| Engine | URL pattern | Notes |
|--------|-------------|-------|
| **Salesforce Help** | `https://help.salesforce.com/s/global-search/%40all/<encoded>` | Official docs, setup guides, release notes. JS-rendered. |
| **Trailhead** | `https://trailhead.salesforce.com/en/search?keywords=<encoded>` | Tutorials, modules, Trailblazer content. JS-rendered. |
| **Salesforce Architect** | `https://architect.salesforce.com/?q=<encoded>` | Reference architectures, design patterns. JS-rendered. |
| **Salesforce Developer Docs** | `https://developer.salesforce.com/search/?q=<encoded>` | Apex, LWC, API references. JS-rendered; usually has linked PDFs (prefer those). |
| **Salesforce Stack Exchange** | `https://salesforce.stackexchange.com/search?q=<encoded>` | Community Q&A; often the fastest answer for edge cases. |

**Critical rule:** when a headless browser is available, **never fall back to
`fetch-basic.sh` or WebFetch for search-result pages**. Modern search engines
(and `help.salesforce.com`) are JS-rendered — static fetch returns empty
shells or redirect pages.

**How the engine chain is actually executed.** The harvest scripts'
`search()` helper queries **only DuckDuckGo HTML directly** — it returns
a list of URLs from that one engine plus passive links to the other
engines (so the user can open them in a browser). The fuller chain
above is the **recipe the orchestrating model follows**: for each engine
listed, construct its URL from the topic, then invoke `harvest.py <url>`
(or the equivalent runtime) to fetch the rendered result page, then read
the resulting `references/<slug>/page.md` for links to follow. The
orchestrator is responsible for: detecting CAPTCHA / blocked pages,
dropping the engine if blocked, moving to the next, and aggregating the
links into the `references/_search/<slug>.md` summary. This keeps the
scripts simple (one URL in, one rendered page out) while keeping the
multi-engine reasoning in the model where it belongs.

### Detecting a blocked search

After fetching, **check the result** before proceeding:
- Look for CAPTCHA indicators: "select all squares", "verify you are human",
  "unusual traffic", challenge forms, empty result lists.
- If blocked: report which engine failed; immediately try the next in the chain.
- **Never silently abandon search** — exhaust the chain and report status.

### Search output

Write `references/_search/<subject-slug>.md` — a deduplicated, ranked list of
result links with engine attribution. Include which engines succeeded and
which were blocked so the user can intervene if needed.

### Fetching individual result pages

After gathering search results, harvest the promising URLs using the **same
headless browser** (not `fetch-basic.sh`, not WebFetch). Most modern
documentation sites, blogs, and knowledge bases are JS-rendered SPAs — static
fetch returns empty `<div id="app"></div>` shells. The headless browser is
the correct tool for both search AND result harvesting.

## Proactive install offers

Install offers fire at the **moment of concrete value**, not at startup.
Asking the user about Playwright before they've seen an empty page is noise;
asking after we just handed them an empty `<div id="app"></div>` lands.

Triggers and ranked menus follow the universal pattern in
[../focus-group/references/usage.md](../focus-group/references/usage.md) §8:

| When | What we offer | Why this is the right moment |
|------|---------------|------------------------------|
| User fetched a JS-rendered page and only `curl`/`wget` was available — output came back nearly empty | (⭐⭐⭐) Python 3 + Playwright OR (⭐⭐) Node.js + Playwright OR (⭐) Windows: Microsoft Edge (already on Windows 11) | The empty result is visible; the user can see the symptom. |
| The topic looks Salesforce-flavored and `sf` is not detected | (⭐) Salesforce CLI (`sf`) — improves citations and unlocks `/focus-group` Step 3c | Concrete value: better grounding for the active product pack. |
| The topic touches `slack` and no Slack MCP is detected | (⭐) Slack MCP | Same logic. |
| Workspace has no `.git` and the user has been generating files | (⭐) git, soft offer at session end | Time-machine framing — recoverability matters when AI is editing files. |

Every offer uses the same four-option menu shape:
- (a) Walk me through the top one now
- (b) Walk me through all of them
- (c) Skip for this run; ask me again next time this comes up
- (d) Skip and don't ask again

Persist the answer (and the trigger reason) in `.install-asked.json` in the
skill folder. Never pester. The user can re-enable prompts via `/focus-group
config set install-prompts on` (the three skills share this setting).

## Output and citations

Everything lands in `references/` (git-ignored — local context only, never
published). Every `meta.json` records the retrieval date so the material can
be cited in `/focus-group` reports as *"Retrieved Month D, Year, from <url>"*.

When `/focus-group` runs Stage C, it consumes every `meta.json` to build the
citations block at the bottom of the final report. The more `/download` ran
first, the more cite-able the final report is, and the higher the accuracy
score per [../focus-group/references/accuracy-rubric.md](../focus-group/references/accuracy-rubric.md).

## Errors and failures

Apply the err-lite doctrine in
[../focus-group/references/err-doctrine.md](../focus-group/references/err-doctrine.md):
name the cause in one plain-English sentence, say what was done without the
failing piece, and offer 1–2 concrete next steps. Never paste a raw stack
trace at the user. End with *"If you'd like, paste the screen you see and
I'll translate it."*

Common failure shapes:
- Headless runtime missing → suggest the install walkthrough above.
- A site blocks automated access → report it; suggest the user save the page
  manually into `references/` from their own browser. Most modern browsers
  have a "Save Page As — Webpage, Complete" option.
- A page legitimately has no content (404, paywall, login wall) → say so; do
  not silently save a useless artifact.
