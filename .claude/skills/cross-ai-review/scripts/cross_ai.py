#!/usr/bin/env python3
# =============================================================================
# cross_ai.py  --  fan one prompt out to the Claude, Gemini, and Codex CLIs
# =============================================================================
# Part of the `cross-ai-review` Claude skill.
#
# WHAT IT DOES
#   Submits an identical prompt to every installed AI CLI in headless
#   (non-interactive) mode, in parallel, collects every response into one
#   comparison report, and degrades gracefully: a CLI that is missing,
#   rate-limited, or out of tokens is SKIPPED and noted -- it never aborts
#   the run. A partial review (2 of 3, or even 1 of 3) still completes.
#
# WHY IT EXISTS
#   Each CLI speaks a different dialect for "answer this prompt and exit":
#       claude  ->  claude -p                    (prompt on stdin)
#       gemini  ->  gemini -p "<prompt>"          (prompt as an argument)
#       codex   ->  codex exec -                  (prompt on stdin)
#   ...plus per-CLI flags for model, reasoning depth, sandbox, and trust.
#   This script hides those differences behind one command and one report
#   format so a cross-AI assessment is a single deterministic step.
#
# EXIT CODE
#   0  -> the run completed and a report was written (even if channels were
#         skipped -- a skip is an expected outcome, not a script failure).
#   1  -> the script itself could not run: bad arguments, no prompt supplied,
#         or not a single CLI was available.
#
# PLATFORM NOTE (Windows)
#   The CLIs install as `.cmd` shims. Python resolves them via shutil.which()
#   (which honors PATHEXT) and the modern subprocess module launches `.cmd`
#   files directly. The prompt is always delivered on stdin or as a list
#   argument -- never interpolated into a shell string -- so there is no
#   shell-quoting or command-injection surface.
# =============================================================================

import argparse
import concurrent.futures
import datetime
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

# -----------------------------------------------------------------------------
# Channel configuration
# -----------------------------------------------------------------------------
# Each AI CLI is a "channel". The functions below translate the abstract
# request (prompt, deep-vs-fast, optional model override) into the concrete
# argument vector that CLI expects. Keeping every CLI-specific quirk in this
# one block is deliberate: when a CLI changes its flags, this is the only
# place to edit. The companion reference doc references/cli-matrix.md explains
# each flag and how to update it.

CHANNELS = ("claude", "gemini", "codex", "opencode")

# Multi-Claude fallback: when only `claude` is installed, run two Claude models
# in parallel so the audit still gets cross-model independence. These are
# "virtual" channels -- each runs the claude CLI with a different --model.
# Models are read from the shared `/focus-group` config (`multi_claude_fallback`).
_MULTI_CLAUDE_CHANNELS = ("claude-opus", "claude-sonnet")

# Substrings that mean "this CLI is out of tokens / rate-limited / over quota".
# Matched case-insensitively, and ONLY against the output of a run that already
# FAILED (non-zero exit). We never scan a successful answer for these words --
# otherwise a prompt that legitimately discusses "rate limits" would be
# misread as a quota failure.
QUOTA_PATTERNS = [
    r"rate[\s_-]?limit",
    r"\bquota\b",
    r"resource[\s_]?exhausted",
    r"resource has been exhausted",
    r"usage limit",
    r"\b429\b",
    r"too many requests",
    r"insufficient[\s_]?quota",
    r"insufficient (?:credit|funds|balance)",
    r"out of (?:credit|tokens)",
    r"credit balance is too low",
    r"payment required",
    r"exhausted your",
    r"weekly limit",
    r"\b5-hour limit\b",
    r"reaching your usage limit",
    r"you(?:'ve| have) (?:hit|reached) your",
    r"upgrade to (?:a )?(?:pro|paid|premium)",
]
_QUOTA_RE = re.compile("|".join(QUOTA_PATTERNS), re.IGNORECASE)

# ANSI escape sequences -- stripped from captured output so the report is
# clean even if a CLI ignores NO_COLOR.
_ANSI_RE = re.compile(r"\x1b\[[0-9;?]*[ -/]*[@-~]|\x1b\][^\x07\x1b]*(?:\x07|\x1b\\)")

# Gemini takes its prompt as a command-line ARGUMENT. Windows caps a whole
# command line near 32 KB, so for an unusually large prompt we fall back to
# delivering it on stdin instead.
GEMINI_ARG_LIMIT = 28000


# -----------------------------------------------------------------------------
# Shared per-CLI model selection
# -----------------------------------------------------------------------------
# The deep-mode model for each channel is shared with the `/focus-group` skill:
# that skill's config.json is the single source of truth, so a cross-AI review
# and a /focus-group panel always run on the same model per CLI. This script only
# READS it -- it never writes it. The path is resolved relative to this file --
#   skills/cross-ai-review/scripts/cross_ai.py  ->  skills/focus-group/config.json
# -- so it works wherever the global skills directory lives. A missing or
# malformed config is non-fatal: the channel falls back to its built-in deep
# default in the build_* functions below.
FOCUS_GROUP_CONFIG = Path(__file__).resolve().parents[2] / "focus-group" / "config.json"

# Local fallback config for when the /focus-group skill is not installed alongside.
# Same shape as the /focus-group config.json, but shipped with this skill so it
# works standalone. The /focus-group config wins when both exist.
LOCAL_CONFIG = Path(__file__).resolve().parent.parent / "config.json"

# Values in the shared config that mean "let the CLI pick its own latest,
# deepest model" instead of pinning a specific id. Compared lower-cased.
_MODEL_LATEST_SENTINELS = {"", "latest", "default", "deep", "none", "null"}


def _load_config():
    """Load the shared /focus-group config, falling back to this skill's local
    config when /focus-group isn't installed. Returns {} on any failure."""
    for path in (FOCUS_GROUP_CONFIG, LOCAL_CONFIG):
        try:
            return json.loads(path.read_text(encoding="utf-8"))
        except (OSError, ValueError):
            continue
    return {}


def load_channel_models():
    """Per-channel deep-mode model id, read from the shared `/focus-group` config.

    Returns {channel: model_id or None}. None means "no pin -- use the CLI's
    built-in deep default". Never raises: a missing or malformed config, or a
    sentinel value (`latest` / `default` / ...), yields None for that channel.
    """
    models = {c: None for c in CHANNELS}
    data = _load_config()
    cfg = data.get("channel_models") or {}
    for c in CHANNELS:
        val = cfg.get(c)
        if isinstance(val, str) and val.strip().lower() not in _MODEL_LATEST_SENTINELS:
            models[c] = val.strip()
    return models


def load_multi_claude_models():
    """Returns (primary_model_id, secondary_model_id) for the multi-Claude
    fallback, or sensible Opus/Sonnet defaults if not configured."""
    data = _load_config()
    cfg = data.get("multi_claude_fallback") or {}
    primary = (cfg.get("primary") or "opus").strip() or "opus"
    secondary = (cfg.get("secondary") or "sonnet").strip() or "sonnet"
    return primary, secondary


def build_claude(prompt, deep, model_override):
    """Argument vector for the Claude Code CLI. Prompt is delivered on stdin."""
    args = ["-p", "--output-format", "text", "--no-session-persistence"]
    args += ["--model", model_override or ("opus" if deep else "haiku")]
    if deep:
        # `--effort high` asks for maximum reasoning; `--fallback-model` lets
        # an overloaded Opus quietly fall back to Sonnet instead of failing.
        args += ["--effort", "high", "--fallback-model", "sonnet"]
    return args, prompt  # (argv_tail, stdin_text)


def build_gemini(prompt, deep, model_override):
    """Argument vector for the Gemini CLI. Prompt is an argument (or stdin)."""
    # --skip-trust: skip the "trust this workspace?" dialog that would hang a
    #   headless run. --approval-mode plan: read-only mode -- the sub-AI may
    #   read repo files for context but can never modify anything.
    args = ["--output-format", "text", "--skip-trust", "--approval-mode", "plan"]
    model = model_override or (None if deep else "gemini-2.5-flash")
    if model:
        args += ["-m", model]
    if len(prompt) <= GEMINI_ARG_LIMIT:
        args += ["-p", prompt]
        return args, None
    # Oversized prompt: deliver on stdin, point -p at it.
    args += ["-p", "Respond to the full prompt provided on standard input."]
    return args, prompt


def build_codex(prompt, deep, model_override):
    """Argument vector for the OpenAI Codex CLI. Prompt is delivered on stdin."""
    # `exec` is the non-interactive subcommand; the trailing `-` means
    # "read the prompt from stdin". --sandbox read-only keeps an audit
    # incapable of editing files. --skip-git-repo-check lets it run outside
    # a git repo (needed for --clean-room).
    args = ["exec", "--sandbox", "read-only", "--skip-git-repo-check"]
    if model_override:
        args += ["-m", model_override]
    args += ["-c", f"model_reasoning_effort={'high' if deep else 'low'}", "-"]
    return args, prompt


def build_opencode(prompt, deep, model_override):
    """Argument vector for the opencode CLI (open-source). Prompt on stdin.

    The opencode CLI is the most variable of the four -- its non-interactive
    flag has shifted between versions. We use the documented `run` subcommand
    when available, fall back to `-p` (print mode) otherwise. The user can
    pin the right invocation via --opencode-model and we always pass the
    prompt on stdin so quoting is safe."""
    args = ["run"]
    if model_override:
        args += ["--model", model_override]
    if deep:
        args += ["--reasoning", "high"]
    return args, prompt


CHANNEL_BUILDERS = {
    "claude": build_claude,
    "gemini": build_gemini,
    "codex": build_codex,
    "opencode": build_opencode,
    # Virtual multi-Claude channels: both use the claude CLI with --model pin.
    "claude-opus": build_claude,
    "claude-sonnet": build_claude,
}

# Map virtual multi-Claude channel names to the real CLI to resolve on PATH.
_CHANNEL_TO_CLI = {
    "claude": "claude",
    "gemini": "gemini",
    "codex": "codex",
    "opencode": "opencode",
    "claude-opus": "claude",
    "claude-sonnet": "claude",
}


# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------
def strip_ansi(text):
    """Remove ANSI colour / control sequences from captured CLI output."""
    return _ANSI_RE.sub("", text or "")


def resolve_cli(name):
    """Return the absolute path of a CLI on PATH, or None if not installed.

    shutil.which() honors PATHEXT, so on Windows it finds `claude.cmd` etc.
    If a CLI is installed twice (e.g. nvm + npm-global), the first PATH match
    wins -- the same one an interactive shell would run.
    """
    return shutil.which(name)


def classify(exit_code, stdout, stderr, timed_out):
    """Turn a raw subprocess result into a channel status.

    Returns one of:
      "ok"      -> the CLI answered (zero exit code)
      "quota"   -> failed AND the failure looks like a token/quota/rate limit
      "error"   -> failed for some other reason
      "timeout" -> the CLI did not finish within the timeout

    Quota detection is gated behind a non-zero exit on purpose: a successful
    answer is never scanned for quota words, so a prompt about "rate limiting"
    cannot be misclassified.
    """
    if timed_out:
        return "timeout"
    if exit_code == 0:
        return "ok"
    if _QUOTA_RE.search((stdout or "") + "\n" + (stderr or "")):
        return "quota"
    return "error"


def tail(text, lines=20):
    """Last N non-empty-trimmed lines of text -- used for diagnostic excerpts."""
    rows = (text or "").rstrip().splitlines()
    return "\n".join(rows[-lines:])


def run_channel(name, prompt, deep, model_override, timeout, cwd):
    """Run one AI CLI and return a result dict.

    This function never raises for an AI-side failure -- a missing CLI, a
    crash, a timeout, or an exhausted quota all come back as a structured
    result so the caller can report them and carry on.
    """
    started = time.monotonic()
    result = {
        "name": name,
        "status": "error",
        "model": model_override or "",
        "duration_s": 0.0,
        "exit_code": None,
        "response": "",
        "diagnostic": "",
    }

    real_cli = _CHANNEL_TO_CLI.get(name, name)
    cli_path = resolve_cli(real_cli)
    if not cli_path:
        result["status"] = "missing"
        result["diagnostic"] = f"`{real_cli}` was not found on PATH -- CLI not installed."
        return result

    argv_tail, stdin_text = CHANNEL_BUILDERS[name](prompt, deep, model_override)
    argv = [cli_path] + argv_tail

    # NO_COLOR / TERM=dumb discourage colour codes and spinner animations that
    # would otherwise pollute the captured text.
    env = dict(os.environ)
    env["NO_COLOR"] = "1"
    env["TERM"] = "dumb"

    timed_out = False
    try:
        proc = subprocess.run(
            argv,
            input=stdin_text,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=timeout,
            cwd=str(cwd),
            env=env,
        )
        exit_code, stdout, stderr = proc.returncode, proc.stdout, proc.stderr
    except subprocess.TimeoutExpired as exc:
        timed_out = True
        exit_code = None
        stdout = exc.stdout.decode("utf-8", "replace") if isinstance(exc.stdout, bytes) else (exc.stdout or "")
        stderr = exc.stderr.decode("utf-8", "replace") if isinstance(exc.stderr, bytes) else (exc.stderr or "")
    except OSError as exc:
        result["status"] = "error"
        result["diagnostic"] = f"Failed to launch `{name}`: {exc}"
        result["duration_s"] = round(time.monotonic() - started, 1)
        return result

    stdout, stderr = strip_ansi(stdout), strip_ansi(stderr)
    result["duration_s"] = round(time.monotonic() - started, 1)
    result["exit_code"] = exit_code
    result["status"] = classify(exit_code, stdout, stderr, timed_out)

    if result["status"] == "ok":
        result["response"] = stdout.strip()
        if not result["response"]:
            result["diagnostic"] = "CLI exited 0 but produced no output."
    elif result["status"] == "timeout":
        result["diagnostic"] = (
            f"No response within {timeout}s. Partial output:\n" + tail(stdout + "\n" + stderr)
        )
    else:  # quota | error
        result["diagnostic"] = tail(stderr or stdout) or f"Exited with code {exit_code}."
    return result


# -----------------------------------------------------------------------------
# Citation scanning (sources left by /download in references/<slug>/meta.json)
# -----------------------------------------------------------------------------
def scan_citations(workspace):
    """Walk the workspace's references/ folder for /download meta.json files.

    Returns a list of dicts: {url, title, retrieved, slug}. Never raises --
    a missing references/ folder yields []. Malformed meta.json files are
    skipped (the workspace can still produce a report)."""
    refs = Path(workspace) / "references"
    citations = []
    if not refs.is_dir():
        return citations
    for meta in sorted(refs.glob("**/meta.json")):
        try:
            data = json.loads(meta.read_text(encoding="utf-8"))
        except (OSError, ValueError):
            continue
        citations.append({
            "url": data.get("url") or data.get("source_url") or "",
            "title": data.get("title") or data.get("page_title") or meta.parent.name,
            "retrieved": data.get("retrieved") or data.get("retrieval_date") or "",
            "slug": meta.parent.name,
        })
    return citations


def format_apa(c, n):
    """Format one citation as a numbered APA-style line."""
    title = c.get("title") or c.get("slug") or "(untitled)"
    url = c.get("url") or "(no URL)"
    retrieved = c.get("retrieved")
    if retrieved:
        return f"[{n}] {title}. Retrieved {retrieved}, from {url}"
    return f"[{n}] {title}. From {url}"


# -----------------------------------------------------------------------------
# Structural pre-score (NOT the canonical 6-factor accuracy rubric)
# -----------------------------------------------------------------------------
# IMPORTANT: this score is a coarse *structural* heuristic computed from
# channel availability and citation file counts -- nothing more. It does NOT
# implement the canonical 6-factor accuracy rubric in
# `../focus-group/references/accuracy-rubric.md`, which requires per-claim
# inter-model agreement averaging, anti-hallucination spot-checks, and
# Platform-Fact verification against each pack's `## Platform Facts` table.
#
# The canonical accuracy score is computed by the synthesis agent during
# `/focus-group` Stage C, where claim extraction and pack lookup happen.
# This script's pre-score is useful as a fast triage signal -- "did 3
# channels respond and is there any citation grounding at all?" -- and is
# rendered in the report with that framing, not as `Accuracy: NN/100`.
def compute_prescore(results, citations, require_citations, multi_claude):
    """Compute the coarse 0-100 structural pre-score.

    Returns {"score": int, "summary": str, "factors": {...}, "kind": "structural-pre-score"}.

    This is NOT the canonical accuracy rubric. See the block comment above
    and `../focus-group/references/accuracy-rubric.md` for the canonical
    six-factor rubric (channel coverage 20, inter-model agreement 25,
    citation density 15, hedging 10, anti-hallucination 10, Platform-Fact
    verification 20). Stage C of `/focus-group` computes that score; this
    function does not.

    Pre-score factors (structural only):
      coverage         (25)  responded / available
      agreement        (30)  channel-count proxy for agreement -- not the
                             rubric's per-claim averaging.
      citation_density (25)  citations present in the workspace.
      hedging          (10)  proxy: full marks when citation density is high.
      cross_check      (10)  full marks unless require_citations and zero
                             citations on file."""
    factors = {}
    total = len(results)
    ok = sum(1 for r in results if r["status"] == "ok")

    # Coverage
    coverage = (ok / total) * 25 if total else 0

    # Agreement: structural -- 2+ responding -> partial credit; 3+ -> full.
    # We have no ground truth here; this is a deliberately coarse proxy.
    if ok >= 3:
        agreement = 30
    elif ok == 2:
        agreement = 20
    elif ok == 1:
        agreement = 10
    else:
        agreement = 0
    if multi_claude and ok >= 2:
        agreement *= 0.7  # same vendor, weaker independence

    # Citation density: scale linearly up to "rich" (8+ citations -> full).
    n_cites = len(citations)
    citation_density = min(n_cites / 8.0, 1.0) * 25

    # Hedging proxy
    hedging = 10 if citation_density >= 12 else max(0, citation_density / 25 * 10)

    # Cross-check: penalize only under require_citations when nothing on file
    cross_check = 10
    if require_citations and n_cites == 0:
        cross_check = 0

    score = round(coverage + agreement + citation_density + hedging + cross_check)
    if require_citations and n_cites == 0:
        score = min(score, 70)

    factors = {
        "coverage": round(coverage),
        "agreement": round(agreement),
        "citation_density": round(citation_density),
        "hedging": round(hedging),
        "cross_check": round(cross_check),
    }
    parts = []
    if ok == total and total > 0:
        parts.append("full coverage")
    elif ok > 0:
        parts.append(f"{ok}/{total} channels responded")
    else:
        parts.append("no channels responded")
    if multi_claude:
        parts.append("multi-Claude fallback (single-vendor)")
    if n_cites == 0:
        parts.append("no citations on file")
    elif n_cites < 4:
        parts.append(f"thin citation density ({n_cites})")
    else:
        parts.append(f"{n_cites} citations on file")
    if require_citations and n_cites == 0:
        parts.append("score capped at 70 by --require-citations")
    summary = "; ".join(parts)
    return {"score": score, "summary": summary, "factors": factors}


# -----------------------------------------------------------------------------
# Report rendering
# -----------------------------------------------------------------------------
STATUS_ICON = {
    "ok": "OK",
    "quota": "SKIPPED (quota/rate-limit)",
    "error": "FAILED",
    "timeout": "TIMED OUT",
    "missing": "NOT INSTALLED",
}


def render_report(meta, results, prompt, prescore, citations):
    """Build the human-readable markdown report."""
    lines = []
    lines.append(f"# Cross-AI Run -- {meta['timestamp_utc']}")
    lines.append("")
    if meta.get("label"):
        lines.append(f"- **Label:** {meta['label']}")
    lines.append(f"- **Run ID:** {meta['run_id']}")
    lines.append(f"- **Reasoning depth:** {meta['depth']}")
    lines.append(f"- **Working directory:** {meta['working_dir']}")
    lines.append(f"- **Context:** {'clean-room (isolated)' if meta['clean_room'] else 'in-repo'}")
    if meta.get("multi_claude"):
        lines.append("- **Multi-Claude fallback in effect** (single-vendor; "
                     "agreement weight dampened by 0.7).")
    summary = " | ".join(f"{r['name']} = {STATUS_ICON[r['status']]}" for r in results)
    lines.append(f"- **Channels:** {summary}")
    ok = sum(1 for r in results if r["status"] == "ok")
    lines.append(f"- **Responded:** {ok} of {len(results)}")
    if prescore:
        lines.append(f"- **Structural pre-score:** {prescore['score']}/100 -- {prescore['summary']}")
        lines.append(f"  (factors: coverage {prescore['factors']['coverage']}, "
                     f"agreement {prescore['factors']['agreement']}, "
                     f"citation density {prescore['factors']['citation_density']}, "
                     f"hedging {prescore['factors']['hedging']}, "
                     f"cross-check {prescore['factors']['cross_check']})")
        lines.append("  *Structural pre-score only -- channel availability + citation file count. "
                     "NOT the canonical 6-factor accuracy rubric "
                     "(coverage / agreement / citations / hedging / anti-hallucination / "
                     "Platform Facts). The canonical score is computed by `/focus-group` "
                     "Stage C, which has the claim extractor and pack-fact lookup. "
                     "See `../focus-group/references/accuracy-rubric.md`.*")
    if meta.get("require_citations"):
        lines.append("- **Citation mode:** Strict (`--require-citations`) -- "
                     "claims without a meta.json source are demoted; score capped at 70 "
                     "until the gap closes.")
    lines.append("")
    lines.append("## Prompt")
    lines.append("")
    lines.append(prompt.strip())
    lines.append("")

    for r in results:
        lines.append("---")
        lines.append("")
        head = f"## {r['name']} -- {STATUS_ICON[r['status']]}"
        if r["status"] == "ok":
            head += f" -- {r['duration_s']}s"
        lines.append(head)
        lines.append("")
        if r["status"] == "ok":
            lines.append(r["response"] or "_(empty response)_")
        else:
            note = {
                "quota": "Channel skipped -- the CLI is rate-limited or out of tokens. "
                         "This is an expected outcome, NOT counted as a failure.",
                "error": "Channel failed for a non-quota reason.",
                "timeout": "Channel did not return in time.",
                "missing": "CLI is not installed on this machine.",
            }[r["status"]]
            lines.append(f"> {note}")
            lines.append("")
            if r["diagnostic"]:
                lines.append("Diagnostic excerpt:")
                lines.append("")
                lines.append("```")
                lines.append(r["diagnostic"])
                lines.append("```")
        lines.append("")

    # Citations block
    lines.append("---")
    lines.append("")
    lines.append("## Citations")
    lines.append("")
    if citations:
        for i, c in enumerate(citations, 1):
            lines.append(format_apa(c, i))
    else:
        lines.append("*No citations on file. The pre-score reflects this "
                     "(citation density = 0). To strengthen the next run, "
                     "ask `/download <url-or-topic>` first.*")
    lines.append("")
    return "\n".join(lines)


# -----------------------------------------------------------------------------
# Argument parsing & orchestration
# -----------------------------------------------------------------------------
def read_prompt(args):
    """Resolve the prompt text from --prompt, --prompt-file, or stdin."""
    if args.prompt is not None:
        return args.prompt
    if args.prompt_file and args.prompt_file != "-":
        return Path(args.prompt_file).read_text(encoding="utf-8")
    if args.prompt_file == "-" or not sys.stdin.isatty():
        data = sys.stdin.read()
        if data.strip():
            return data
    return None


def append_attachments(prompt, attachments):
    """Append the contents of each --attach file under a labelled header."""
    if not attachments:
        return prompt
    parts = [prompt.rstrip(), ""]
    for path in attachments:
        p = Path(path)
        parts.append(f"--- ATTACHED FILE: {p.name} ---")
        try:
            parts.append(p.read_text(encoding="utf-8", errors="replace"))
        except OSError as exc:
            parts.append(f"(could not read {path}: {exc})")
        parts.append("")
    return "\n".join(parts)


def parse_args(argv):
    ap = argparse.ArgumentParser(
        prog="cross_ai.py",
        description="Fan one prompt out to the Claude, Gemini, and Codex CLIs "
                    "and collect a single comparison report.",
    )
    src = ap.add_argument_group("prompt source (choose one; default = stdin)")
    src.add_argument("--prompt", help="Prompt text given directly on the command line.")
    src.add_argument("--prompt-file", help="Path to a file holding the prompt ('-' = stdin).")
    src.add_argument("--attach", action="append", default=[], metavar="FILE",
                     help="Append a file's contents to the prompt (repeatable).")

    ch = ap.add_argument_group("channel selection")
    ch.add_argument("--only", help="Comma-separated channels to run (claude,gemini,codex).")
    ch.add_argument("--skip", help="Comma-separated channels to exclude.")

    beh = ap.add_argument_group("behaviour")
    beh.add_argument("--fast", action="store_true",
                     help="Downshift to each CLI's quick model / low reasoning effort.")
    beh.add_argument("--sequential", action="store_true",
                     help="Run channels one at a time instead of in parallel.")
    beh.add_argument("--clean-room", action="store_true",
                     help="Run each CLI in an isolated temp dir so it does NOT "
                          "auto-load CLAUDE.md / GEMINI.md / project context.")
    beh.add_argument("--timeout", type=int, default=600, metavar="SEC",
                     help="Per-channel timeout in seconds (default: 600).")
    beh.add_argument("--label", default="", help="Short human label for this run.")

    mdl = ap.add_argument_group("model overrides (optional)")
    mdl.add_argument("--claude-model", help="Override the Claude model alias / name.")
    mdl.add_argument("--gemini-model", help="Override the Gemini model name.")
    mdl.add_argument("--codex-model", help="Override the Codex model name.")
    mdl.add_argument("--opencode-model", help="Override the opencode model name.")

    fallback = ap.add_argument_group("multi-Claude fallback")
    fallback.add_argument("--multi-claude", action="store_true",
                          help="Force the multi-Claude fallback (Opus + Sonnet in "
                               "parallel) even when other CLIs are installed. "
                               "Automatic when only `claude` is detected.")

    cites = ap.add_argument_group("citations & pre-score")
    cites.add_argument("--require-citations", action="store_true",
                       help="Strict mode -- demote claims without a meta.json "
                            "source; cap the structural pre-score at 70 until "
                            "the gap closes.")
    cites.add_argument("--no-citations", action="store_true",
                       help="Skip the citations block and the citation-density "
                            "factor in the structural pre-score.")

    out = ap.add_argument_group("output")
    out.add_argument("--out-dir", help="Directory for the run folder "
                     "(default: ~/.claude/cross-ai-runs).")

    ap.add_argument("--check", action="store_true",
                    help="Probe which CLIs are installed and exit (no prompt run).")
    ap.add_argument("--dry-run", action="store_true",
                    help="Print the command each channel would run and exit.")
    args = ap.parse_args(argv)
    # Conflict validation: --no-citations and --require-citations contradict.
    if args.no_citations and args.require_citations:
        ap.error("--no-citations and --require-citations are mutually exclusive: "
                 "the first disables citation handling entirely; the second "
                 "demands strict citation coverage. Pick one.")
    return args


def selected_channels(args):
    """Return the ordered list of channels to run, plus a boolean
    `multi_claude` flag that signals the fallback engaged so the report
    can label itself correctly."""
    # Forced fallback via --multi-claude: run the two Claude virtual channels.
    if args.multi_claude:
        return list(_MULTI_CLAUDE_CHANNELS), True

    chans = list(CHANNELS)
    if args.only:
        wanted = [c.strip().lower() for c in args.only.split(",") if c.strip()]
        valid = set(CHANNELS) | set(_MULTI_CLAUDE_CHANNELS)
        bad = [c for c in wanted if c not in valid]
        if bad:
            sys.exit(f"error: unknown channel(s) in --only: {', '.join(bad)}")
        # When --only contains multi-Claude virtual channels, honor them too.
        chans = [c for c in (CHANNELS + _MULTI_CLAUDE_CHANNELS) if c in wanted]
    if args.skip:
        drop = {c.strip().lower() for c in args.skip.split(",") if c.strip()}
        chans = [c for c in chans if c not in drop]

    # Auto-fallback: only `claude` is installed -> swap to multi-Claude
    # virtual channels so the user still gets cross-model independence.
    # Skip auto-fallback if the user pinned --only or --skip explicitly.
    if not args.only and not args.skip:
        installed = [c for c in chans if resolve_cli(_CHANNEL_TO_CLI.get(c, c))]
        if installed == ["claude"]:
            return list(_MULTI_CLAUDE_CHANNELS), True

    return chans, False


def do_check(chans):
    print("Cross-AI CLI availability:")
    any_found = False
    for c in chans:
        real = _CHANNEL_TO_CLI.get(c, c)
        path = resolve_cli(real)
        if path:
            any_found = True
            print(f"  {c:10s} installed  -> {path}")
        else:
            print(f"  {c:10s} NOT FOUND  (skipped on any run)")
    # Multi-Claude fallback signal
    real_installed = [c for c in CHANNELS if resolve_cli(_CHANNEL_TO_CLI.get(c, c))]
    if real_installed == ["claude"]:
        primary, secondary = load_multi_claude_models()
        print(f"\nOnly `claude` detected -- multi-Claude fallback would activate:")
        print(f"  primary   = {primary}")
        print(f"  secondary = {secondary}")
        print("Pass --multi-claude to force this mode even when other CLIs exist.")
    return 0 if any_found else 1


def main(argv):
    args = parse_args(argv)
    chans, multi_claude = selected_channels(args)
    if not chans:
        sys.exit("error: no channels selected.")

    if args.check:
        return do_check(chans)

    prompt = read_prompt(args)
    if not prompt or not prompt.strip():
        sys.exit("error: no prompt supplied. Use --prompt, --prompt-file, or pipe stdin.")
    prompt = prompt.lstrip("﻿")  # drop a UTF-8 BOM if the source carried one
    prompt = append_attachments(prompt, args.attach)

    deep = not args.fast
    # Per-CLI model precedence in deep mode: an explicit --<channel>-model flag
    # wins; otherwise the model pinned in the shared `/focus-group` config.json;
    # otherwise this skill's own local config; otherwise the channel's built-in
    # deep default (the build_* functions). Fast mode ignores config and uses
    # each CLI's quick model.
    model_overrides = {
        "claude": args.claude_model,
        "gemini": args.gemini_model,
        "codex": args.codex_model,
        "opencode": args.opencode_model,
    }
    if deep:
        shared_models = load_channel_models()
        for c in CHANNELS:
            if not model_overrides[c]:
                model_overrides[c] = shared_models.get(c)

    # Multi-Claude virtual channels: each gets its assigned model via the
    # `claude --model <id>` flag inside build_claude.
    if multi_claude:
        primary, secondary = load_multi_claude_models()
        # Multi-Claude virtual channels live alongside the real ones in
        # model_overrides; they're keyed by virtual channel name.
        model_overrides["claude-opus"] = args.claude_model or primary
        model_overrides["claude-sonnet"] = secondary

    if args.dry_run:
        print("Dry run -- commands that WOULD be executed:\n")
        for c in chans:
            real = _CHANNEL_TO_CLI.get(c, c)
            path = resolve_cli(real) or f"<{real}: not installed>"
            tail_args, _ = CHANNEL_BUILDERS[c](prompt, deep, model_overrides.get(c))
            print(f"  {c}: {path} {' '.join(tail_args)}")
        return 0

    # Clean-room runs happen inside a throwaway temp dir so the CLIs find no
    # CLAUDE.md / GEMINI.md to auto-load. The default is the real cwd.
    tmpdir = tempfile.mkdtemp(prefix="xai-clean-") if args.clean_room else None
    run_cwd = Path(tmpdir) if tmpdir else Path.cwd()

    now = datetime.datetime.now(datetime.timezone.utc)
    run_id = "xai-" + now.strftime("%Y%m%d-%H%M%S")
    if args.label:
        slug = re.sub(r"[^a-z0-9]+", "-", args.label.lower()).strip("-")[:40]
        if slug:
            run_id += "-" + slug
    base = Path(args.out_dir) if args.out_dir else Path.home() / ".claude" / "cross-ai-runs"
    run_dir = base / run_id
    run_dir.mkdir(parents=True, exist_ok=True)

    meta = {
        "run_id": run_id,
        "timestamp_utc": now.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "label": args.label,
        "depth": "deep" if deep else "fast",
        "working_dir": str(run_cwd),
        "clean_room": bool(tmpdir),
        "multi_claude": multi_claude,
        "require_citations": bool(args.require_citations),
    }

    if multi_claude:
        print(f"Multi-Claude fallback engaged -- running 2 Claude models in parallel "
              f"({model_overrides['claude-opus']} + {model_overrides['claude-sonnet']}).")
    print(f"Cross-AI run {run_id} -- {len(chans)} channel(s), "
          f"{'deep' if deep else 'fast'} mode, "
          f"{'sequential' if args.sequential else 'parallel'}.")
    print("Working... deep reasoning can take several minutes per channel.\n")

    # ---- run every channel -------------------------------------------------
    def _run(c):
        return run_channel(c, prompt, deep, model_overrides[c], args.timeout, run_cwd)

    if args.sequential:
        results = [_run(c) for c in chans]
    else:
        with concurrent.futures.ThreadPoolExecutor(max_workers=len(chans)) as ex:
            future_map = {ex.submit(_run, c): c for c in chans}
            done = {}
            for fut in concurrent.futures.as_completed(future_map):
                r = fut.result()
                done[r["name"]] = r
        results = [done[c] for c in chans]  # preserve requested order

    # ---- citations + structural pre-score ----------------------------------
    citations = [] if args.no_citations else scan_citations(Path.cwd())
    prescore = None if args.no_citations else compute_prescore(
        results, citations, args.require_citations, multi_claude)

    # ---- write artefacts ---------------------------------------------------
    (run_dir / "prompt.txt").write_text(prompt, encoding="utf-8")
    report_md = render_report(meta, results, prompt, prescore, citations)
    (run_dir / "report.md").write_text(report_md, encoding="utf-8")
    report_json = dict(meta)
    report_json["prompt"] = prompt
    report_json["channels"] = results
    report_json["citations"] = citations
    report_json["prescore"] = prescore
    # Back-compat: keep `accuracy` key pointed at the same payload for any
    # existing consumer, but the canonical key is now `prescore`.
    report_json["accuracy"] = prescore
    report_json["summary"] = {
        "ok": sum(1 for r in results if r["status"] == "ok"),
        "skipped_quota": sum(1 for r in results if r["status"] == "quota"),
        "failed": sum(1 for r in results if r["status"] in ("error", "timeout", "missing")),
        "total": len(results),
    }
    (run_dir / "report.json").write_text(
        json.dumps(report_json, indent=2), encoding="utf-8")

    if tmpdir:
        shutil.rmtree(tmpdir, ignore_errors=True)

    # ---- concise stdout summary (this is what the calling agent reads) -----
    print("Channel results:")
    for r in results:
        extra = f"{r['duration_s']}s" if r["status"] == "ok" else STATUS_ICON[r["status"]]
        print(f"  {r['name']:8s} {STATUS_ICON[r['status']]:28s} {extra}")
    ok = report_json["summary"]["ok"]
    print(f"\n{ok} of {len(results)} channel(s) responded.")
    if prescore:
        print(f"Structural pre-score: {prescore['score']}/100 -- {prescore['summary']}")
        print("  (Not the canonical accuracy score -- see /focus-group Stage C "
              "for the 6-factor rubric with Platform Facts.)")
    if citations:
        print(f"Citations: {len(citations)} source(s) from references/")
    elif not args.no_citations:
        print("Citations: 0 -- run /download first to strengthen the next run.")
    if ok == 0:
        print("WARNING: every channel was skipped or failed -- see the report "
              "for diagnostics before relying on this run.")
    print(f"\nReport (markdown): {run_dir / 'report.md'}")
    print(f"Report (JSON):     {run_dir / 'report.json'}")
    print(f"Prompt preserved:  {run_dir / 'prompt.txt'}")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except KeyboardInterrupt:
        sys.exit(130)
