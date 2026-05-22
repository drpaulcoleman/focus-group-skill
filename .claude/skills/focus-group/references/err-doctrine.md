# Err Doctrine — Plain-English Error Handling for Sales-Team Users

The audience for these skills includes people who spend their day in CRM,
Slack, and email — not a terminal. A raw stack trace, an `ENOENT` message,
or "command not found" without translation is either intimidating, opaque,
or feels like a personal failing ("did I do something wrong?"). None of
those reactions get the user closer to a working result.

This doctrine codifies the voice every error-handling path in `/focus-group`,
`/download`, and `/cross-ai-review` uses. It is adapted from the Bulisolio
`.00-ERR` doctrine, softened for non-engineer users.

## The four-line shape of every user-facing error

When anything fails, the skill says exactly four things, in order:

1. **The cause, in one plain-English sentence.** No jargon. No filenames or
   line numbers unless they would actually help.
2. **What was done without the failing piece.** ("I went ahead with the four
   other personas." "I saved the page but the JavaScript content didn't load
   — what's on disk is the bare shell.")
3. **One or two concrete next steps the user can take.** Ranked: easiest
   first. ("If you'd like a clean fetch, the headless-browser install takes
   about three minutes — I can walk you through it.")
4. **The "help me help you" close.** Always end with *"If you'd like, paste
   the screen you see and I'll translate it."*

That last line matters. It teaches the user that pasting a raw error is
helpful, not embarrassing, and that the AI is the right place to translate.
It is the single most important behavior to repeat: it gets the user past
the next blocker on their own next time.

## What we never do

- **Never paste a raw stack trace at the user.** If a stack trace is
  unavoidable in a log, hide it behind a "Show technical details" disclosure
  or save it to a file and reference the path.
- **Never blame the user.** A missing CLI is *the tool isn't here yet*, not
  *you forgot to install it*. An empty page is *the site needs a real
  browser*, not *you fetched it wrong*.
- **Never silently swallow an error.** Telling the user something worked
  when it didn't, or producing a useless artifact and labelling it good,
  destroys trust the next time something *does* work. If a page came back
  empty, say so.
- **Never drop into tech-speak for a fix the user can't apply.** "Set
  `PYTHONPATH`" means nothing to most AEs. "Want me to walk you through
  installing Python (about three minutes)?" does.

## Examples

### A missing headless browser when `/download` is asked for a JS page

Wrong:
> `Error: playwright not installed; falling back to fetch-basic.sh which
> returned <div id="app"></div>`

Right:
> **What happened:** The page is built with JavaScript that only runs when
> a real browser is on it. I have a basic fetch tool but no browser
> available, so I got back the empty shell of the page instead of the
> content. **What I did:** Saved the shell to
> `references/help-salesforce-com-service-cloud-overview/page.html` and
> flagged it as incomplete. **What you could do:** The most useful upgrade
> here is Python with Playwright (about three minutes). Want me to walk you
> through it? *If you'd like, paste the screen you see and I'll translate it.*

### A quota-exhausted CLI in `/cross-ai-review`

Wrong:
> `gemini exit 1: insufficient_quota; cross_ai.py continuing without it`

Right:
> **What happened:** Gemini is out of credit on this account today —
> nothing wrong with the prompt or the setup. **What I did:** Ran the
> review with Claude and Codex; their two answers are in the report and I
> noted Gemini as skipped. The accuracy score is a little lower because
> coverage went from 3-of-3 to 2-of-3. **What you could do:** If you want
> Gemini's view, re-run tomorrow with `--prompt-file <run>/prompt.txt
> --only gemini` and it will append to the same run. *If you'd like, paste
> the screen you see and I'll translate it.*

### `sf org list` returns no orgs in `/focus-group` Step 3c

Wrong:
> `No orgs found. Run 'sf org login web' first.`

Right:
> **What happened:** Salesforce CLI is installed but no Salesforce org is
> connected to it yet. **What I did:** Skipped the live-data part and
> proposed a culture-and-size profile draft for you instead. **What you
> could do:** Connecting a sandbox takes about a minute — `sf org login web`
> opens a browser, you log in to the sandbox as you normally would, and
> next time you run `/focus-group` for this customer I can pull the live data.
> Want to do that now? *If you'd like, paste the screen you see and I'll
> translate it.*

## The catalog (adapted from `.00-ERR`)

The original doctrine asks for a per-project catalog of named causes so the
organization learns from each failure. For sales-team users this is too much
machinery. Instead, each skill keeps a tiny per-workspace log at
`.claude/skills/<skill>/.err-log.md` that records the **friendly cause name**,
date, and what we did.

After 5 entries with the same cause, the skill proactively says:

> *"This has come up a few times — want me to walk you through fixing it
> once and for all? It'd take about [N] minutes."*

That's the catalog discipline, softened. Frequency triggers proactivity;
the skill makes the offer; the user decides.

## The voice rule (universal)

Plain, professional, neutral. No slang. No labels for the reader ("noob",
"newbie", "non-technical", "lay user"). No jokes at the user's expense.
Read the same whether the user is a brand-new AE or a 20-year architect —
only the *depth* of the explanation flexes, never the tone.
