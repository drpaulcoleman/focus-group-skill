# CLI Matrix — per-CLI headless invocation reference

How `scripts/cross_ai.py` drives each AI command-line tool. Read this when a
channel misbehaves or a CLI version bump changes a flag. Everything CLI-specific
lives in the `build_claude` / `build_gemini` / `build_codex` functions and the
`QUOTA_PATTERNS` list at the top of the script — this doc explains those.

Verified against: Claude Code 2.1.x, Gemini CLI 0.42.x, Codex CLI 0.130.x
(May 2026). If a CLI is newer and a flag below is rejected, re-run
`<cli> --help` and update the matching builder function.

## Headless invocation per CLI

| CLI | Headless mode | Prompt delivery | Working dir matters? |
|-----|---------------|-----------------|----------------------|
| claude | `claude -p` (print mode) | stdin | yes — auto-loads CLAUDE.md |
| gemini | `gemini -p "<prompt>"` | argument (stdin if huge) | yes — auto-loads GEMINI.md |
| codex  | `codex exec -` | stdin (the `-`) | yes — auto-loads AGENTS.md |

All three are launched with `NO_COLOR=1` and `TERM=dumb` to suppress colour
codes and spinners; any ANSI residue is stripped from captured output anyway.

## Exact flags and why

### Claude — `claude`

```
claude -p --output-format text --no-session-persistence --model <m> [--effort high --fallback-model sonnet]
```

- `-p` — print mode: answer once, non-interactively, and exit. The workspace
  trust dialog is auto-skipped in this mode, so no hang.
- `--output-format text` — plain text answer, nothing to parse.
- `--no-session-persistence` — a throwaway one-off; do not litter the resume
  history.
- `--model` — deep mode: the id from the shared `/focus-group` config (see "Deep vs
  fast"), falling back to the `opus` alias; fast mode: `haiku`. The aliases stay
  valid as model versions roll forward; a pinned config id is exact.
- `--effort high` — maximum reasoning (deep mode only).
- `--fallback-model sonnet` — if Opus is overloaded, fall back instead of
  failing. Only valid alongside `-p`.

### Gemini — `gemini`

```
gemini --output-format text --skip-trust --approval-mode plan [-m <m>] -p "<prompt>"
```

- `--skip-trust` — skip the "trust this workspace?" dialog that would otherwise
  hang a headless run. **Essential.**
- `--approval-mode plan` — read-only mode: Gemini may read files for context
  but can never edit anything, and it never pauses for an approval prompt.
- `-m` — deep mode: the id from the shared `/focus-group` config if one is pinned,
  else omitted so Gemini uses its default top model; fast mode: `gemini-2.5-flash`.
- `-p "<prompt>"` — the prompt is a command-line ARGUMENT here. Windows caps a
  command line near 32 KB, so for a prompt over ~28 KB the script delivers it
  on stdin instead and points `-p` at the stdin block.

### Codex — `codex`

```
codex exec --sandbox read-only --skip-git-repo-check [-m <m>] -c model_reasoning_effort=<high|low> -
```

- `exec` — the non-interactive subcommand.
- `--sandbox read-only` — the sub-AI can read but never write; an audit cannot
  damage the working tree.
- `--skip-git-repo-check` — allow running outside a git repo (needed for
  `--clean-room`, harmless inside one).
- `-c model_reasoning_effort=high` — deep reasoning (`low` in fast mode). This
  is a config override, so the key is stable across model changes.
- `-m` — deep mode: the id from the shared `/focus-group` config if one is pinned,
  else omitted so Codex uses its default model; not set in fast mode.
- trailing `-` — read the prompt from stdin.

## Deep vs fast

**Deep mode** (the default) takes the model for each channel from the shared
`/focus-group` skill config — `skills/focus-group/config.json`, resolved relative to
this skill — so a cross-AI review and a `/focus-group` panel always run the same
model per CLI, maintained in one place. `load_channel_models()` does the lookup:

- A pinned id under `channel_models` (e.g. `"claude": "claude-opus-4-7"`) is
  passed straight to that CLI.
- A sentinel value (`latest`, `default`, `deep`, `none`, `null`, or empty) — or
  a missing / unreadable config — means "no pin": the channel falls back to its
  built-in deep default in the table below.
- An explicit `--claude-model` / `--gemini-model` / `--codex-model` flag
  overrides both the shared config and the built-in default.

**Fast mode** (`--fast`) ignores the shared config and uses each CLI's quick
model.

| | Claude | Gemini | Codex |
|--|--------|--------|-------|
| deep (default) | shared config, else `--model opus`; `--effort high` | shared config, else default model | shared config, else CLI default; `model_reasoning_effort=high` |
| fast (`--fast`) | `--model haiku` | `-m gemini-2.5-flash` | `model_reasoning_effort=low` |

Per-CLI overrides: `--claude-model`, `--gemini-model`, `--codex-model`.

## Quota / token-exhaustion signatures

The script classifies a channel as `quota` (skip gracefully) only when the run
**failed** (non-zero exit) AND its output matches one of `QUOTA_PATTERNS`.
Gating on a failed exit is deliberate: a successful answer is never scanned, so
a prompt that legitimately discusses "rate limits" cannot be misclassified.

Typical exhaustion text by CLI:

- **Claude** — "Claude usage limit reached", "5-hour limit", "rate limit".
- **Gemini** — "RESOURCE_EXHAUSTED", "Quota exceeded", HTTP "429".
- **Codex** — "rate limit", "usage limit reached", "429", "quota".

If a new CLI version words exhaustion differently and a real quota failure
shows up as `error` instead of `quota`, add the new phrase to `QUOTA_PATTERNS`.
A misclassification is not dangerous — an `error` channel is still skipped and
the run still completes — it just labels the cause less precisely.

## Windows notes

- The CLIs install as `.cmd` shims (e.g. `C:\nvm4w\nodejs\claude.CMD`).
  `shutil.which()` honours `PATHEXT` and finds them; modern `subprocess`
  launches `.cmd` files directly. No `cmd /c` wrapper is needed.
- `codex` and `gemini` may be installed twice (an nvm copy and an
  npm-global copy). `shutil.which()` returns whichever appears first on
  `PATH` — the same one an interactive shell runs. If a run behaves oddly,
  confirm with `python scripts/cross_ai.py --check` which path resolved.

## Clean-room vs in-repo context

- **in-repo (default)** — CLIs run in the current directory and auto-load that
  project's `CLAUDE.md` / `GEMINI.md` / `AGENTS.md`. The review reflects the
  house rules.
- **`--clean-room`** — CLIs run in a throwaway temp directory, so no project
  context files are discovered. A genuinely independent read. The temp
  directory is deleted when the run finishes.

## Troubleshooting

| Symptom | Likely cause / fix |
|---------|--------------------|
| A channel always `timeout` | Deep reasoning is slow — raise `--timeout`. Or that CLI is hanging on a prompt; check it interactively. |
| `missing` for an installed CLI | Not on `PATH` for this shell. Check `--check` output. |
| A real quota failure shows as `error` | The CLI changed its wording — add the phrase to `QUOTA_PATTERNS`. |
| A flag is rejected after a CLI update | Re-run `<cli> --help` (and `codex exec --help`) and update the builder function. |
| Gemini hangs | Confirm `--skip-trust` is still a valid flag; a trust dialog will hang a headless run. |
| Codex output has chrome/preamble | Harmless — the report consumer reads past it. If it grows noisy, consider `codex exec --json` and parse the final message. |