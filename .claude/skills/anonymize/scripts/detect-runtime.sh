#!/bin/sh
# detect-runtime.sh -- which anonymize runtime should we use?
#
# Probes the host for an interpreter capable of running the anonymize
# library. Prints a single-token recommendation on stdout and a short
# human report on stderr.
#
# Output token (stdout, one of):
#   python   -> use scripts/anonymize.py  (preferred; full feature set)
#   node     -> use scripts/anonymize.mjs (full feature set)
#   shell    -> use scripts/anonymize.sh  (DEGRADED -- Layer 1+2 only,
#                                          no heuristic proper-noun detection)
#   none     -> nothing usable; caller should surface the install offer

found_python=""
found_node=""
found_shell=""

# Python: 3.x preferred; either `python3` or `python` (Windows)
for p in python3 python; do
    if command -v "$p" >/dev/null 2>&1; then
        ver=$("$p" -c 'import sys; print(sys.version_info[0])' 2>/dev/null)
        if [ "$ver" = "3" ]; then
            found_python="$p"
            break
        fi
    fi
done

# Node.js
if command -v node >/dev/null 2>&1; then
    if node --version >/dev/null 2>&1; then
        found_node="node"
    fi
fi

# POSIX shell with sed -- always present on macOS/Linux; on Windows requires Git Bash / WSL
if command -v sed >/dev/null 2>&1 && command -v awk >/dev/null 2>&1; then
    found_shell="shell"
fi

# Report
{
    echo "anonymize runtime probe:"
    [ -n "$found_python" ] && echo "  python3  : found ($found_python)" || echo "  python3  : NOT FOUND"
    [ -n "$found_node" ]   && echo "  node     : found"                    || echo "  node     : NOT FOUND"
    [ -n "$found_shell" ]  && echo "  POSIX sh : found"                    || echo "  POSIX sh : NOT FOUND"
} >&2

# Pick the best
if [ -n "$found_python" ]; then
    echo "python"
elif [ -n "$found_node" ]; then
    echo "node"
elif [ -n "$found_shell" ]; then
    echo "shell"
    echo "" >&2
    echo "WARNING: only POSIX shell available. Anonymize will use DEGRADED mode --" >&2
    echo "  Layer 1 (caller-supplied entities) + Layer 2 (regex patterns) only." >&2
    echo "  Layer 3 (heuristic proper-noun detection) is NOT available in shell mode." >&2
    echo "  For full coverage, install Python 3 or Node.js. See:" >&2
    echo "    https://www.python.org/downloads/   (about 3 minutes)" >&2
    echo "    https://nodejs.org/                  (about 3 minutes)" >&2
else
    echo "none"
    echo "" >&2
    echo "No interpreter found. Anonymize cannot run on this host." >&2
    echo "Install one of (pick the easiest for your OS):" >&2
    echo "  - Python 3:   https://www.python.org/downloads/   (universal; recommended)" >&2
    echo "  - Node.js:    https://nodejs.org/                  (also works)" >&2
fi
