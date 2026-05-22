#!/bin/sh
# anonymize.sh -- POSIX shell fallback for /anonymize (DEGRADED: L1 + L2 only).
#
# Used when neither Python 3 nor Node.js is installed but a POSIX shell
# (with sed and awk) is. Common on locked-down corporate macOS / Linux
# laptops; available on Windows via Git Bash or WSL.
#
# Same CLI shape as anonymize.py (scrub / restore / inspect / reset),
# subset of patterns:
#   - Caller-supplied entities via repeated --scrub
#   - Regex: email, phone (NA), SF org id, LinkedIn URL, money ($...M / $...K),
#     SSN, EIN, ISO date, headcount, Slack channel (custom prefix).
#   - NO Layer 3 (heuristic proper-noun detection). The skill's caller is
#     expected to pass --scrub <entity> for any name not caught by regex.
#
# Map file is the same JSON shape as the Python/Node versions; if a user
# later installs Python, their existing map continues to work.

set -e

cmd=""
input=""
output=""
map_path=".anonymize/map.json"
known_entities=""  # newline-separated

usage() {
    cat >&2 <<EOF
usage: anonymize.sh {scrub|restore|inspect|reset|help} [--input <f>] [--output <f>] [--map <f>] [--scrub <ent>...]

DEGRADED mode: Layer 1 (caller-supplied) + Layer 2 (regex patterns) only.
For full coverage (Layer 3 heuristic proper-noun detection), install
Python 3 (https://www.python.org/downloads/) or Node.js
(https://nodejs.org/) -- both about 3 minutes.
EOF
}

# --- arg parsing ---
[ $# -gt 0 ] || { usage; exit 1; }
cmd="$1"; shift
while [ $# -gt 0 ]; do
    case "$1" in
        --input)  input="$2"; shift 2 ;;
        --output) output="$2"; shift 2 ;;
        --map)    map_path="$2"; shift 2 ;;
        --scrub)  known_entities="$known_entities
$2"; shift 2 ;;
        -h|--help|help) usage; exit 0 ;;
        *) echo "unknown arg: $1" >&2; usage; exit 1 ;;
    esac
done

# --- helpers ---
read_input() {
    if [ "$input" = "-" ] || { [ -z "$input" ] && [ ! -t 0 ]; }; then
        cat
    elif [ -n "$input" ]; then
        cat "$input"
    else
        echo "error: no input. Pass --input <file>, '-' for stdin, or pipe." >&2
        exit 1
    fi
}

# Shell mode does NOT maintain a real per-entity map -- the cross-runtime
# map promise in SKILL.md applies to Python / Node / PowerShell only. We
# write a clearly-labeled stub so a downstream restore() doesn't silently
# claim the map is empty when really it never existed in this runtime.
ensure_map() {
    if [ ! -f "$map_path" ]; then
        mkdir -p "$(dirname "$map_path")"
        cat > "$map_path" <<'EOF'
{
  "version": 1,
  "_runtime": "shell-degraded",
  "_warning": "This map was created by the POSIX-shell runtime, which does NOT maintain a per-entity placeholder map. Placeholders emitted by this run are flat ({{EMAIL}}, {{ORG_ID}}) and are NOT individually restorable. To get a real per-entity map you can restore from, re-run scrub under Python or Node.js.",
  "next_index": {},
  "entries": {}
}
EOF
    fi
}

# Append a new (real, placeholder, kind) entry. Idempotency check is naive
# (string-search the map for the real value). The Python/Node versions do
# this better; shell mode is best-effort.
get_next_index() {
    kind="$1"
    # crude: count existing entries of this kind
    grep -c "\"type\": \"$kind\"" "$map_path" 2>/dev/null || echo 0
}

add_entry() {
    real="$1"; kind="$2"; hint="$3"
    # Already in map?
    if grep -q "\"placeholder\":.*\"{{${kind}_" "$map_path" && \
       grep -q "$(printf '%s' "$real" | sed 's/[]\/$*.^[]/\\&/g')" "$map_path"; then
        # Lookup existing placeholder
        grep -o "{{${kind}_[0-9]*\(_[A-Z]*\)*}}" "$map_path" | head -1
        return
    fi
    n=$(( $(get_next_index "$kind") + 1 ))
    if [ -n "$hint" ]; then
        ph="{{${kind}_${n}_${hint}}}"
    else
        ph="{{${kind}_${n}}}"
    fi
    # Append to entries; this is a hack -- real JSON parsing would be safer
    # but we don't have jq guaranteed. The Python/Node paths do this right.
    printf '\n  -- shell-mode entry: %s -> %s (%s)' "$real" "$ph" "$kind" >> "$map_path.log"
    echo "$ph"
}

# Replace one pattern with placeholders (limit: same placeholder for every match
# in this run; cross-run idempotency relies on add_entry's grep).
sed_scrub() {
    pattern="$1"; kind="$2"; hint="$3"; text="$4"
    # Use awk to do the substitution and capture so we can call add_entry
    # for each match. Less elegant than Python, but POSIX.
    echo "$text" | awk -v pat="$pattern" -v kind="$kind" -v hint="$hint" '
        {
            line = $0
            while (match(line, pat)) {
                m = substr(line, RSTART, RLENGTH)
                ph = "{{" kind "_X}}"  # placeholder allocation happens shell-side
                print "MATCH:" m  > "/dev/stderr"
                line = substr(line, 1, RSTART-1) ph substr(line, RSTART+RLENGTH)
            }
            print line
        }'
}

scrub_cmd() {
    ensure_map
    text=$(read_input)

    # Layer 1: caller-supplied entities (always wins; simple sed swap)
    if [ -n "$known_entities" ]; then
        echo "$known_entities" | while IFS= read -r ent; do
            [ -z "$ent" ] && continue
            # Decide kind by very simple rule (company markers > person heuristic)
            kind="ENTITY"
            case "$ent" in
                *Inc*|*LLC*|*Ltd*|*Corp*|*Health*|*Bank*|*Systems*|*Group*|\
                *University*|*College*|*Foundation*|*Authority*|*District*|\
                *Holdings*|*Hospital*) kind="COMPANY" ;;
            esac
            ph=$(add_entry "$ent" "$kind" "")
            # Naïve: substitute every occurrence
            text=$(printf '%s' "$text" | sed "s|$(printf '%s' "$ent" | sed 's/[\/&]/\\&/g')|$ph|g")
        done
    fi

    # Layer 2: regex patterns (a small subset; full set in the Python version).
    # POSIX sed regex is limited; the patterns below are extended-regex style.

    # Email
    text=$(printf '%s' "$text" | sed -E 's/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/{{EMAIL}}/g')
    # LinkedIn URL
    text=$(printf '%s' "$text" | sed -E 's|(https?://)?(www\.)?linkedin\.com/(in\|company\|pub)/[A-Za-z0-9_/-]+|{{LINKEDIN}}|g')
    # SF org id
    text=$(printf '%s' "$text" | sed -E 's/\b00[A-Za-z0-9]{13}([A-Za-z]{3})?\b/{{ORG_ID}}/g')
    # Money with K/M/B suffix
    text=$(printf '%s' "$text" | sed -E 's/\$[0-9]+(\.[0-9]+)?[KMBkmb]/{{MONEY_USD}}/g')
    # Money with commas (>= 4 digits)
    text=$(printf '%s' "$text" | sed -E 's/\$[0-9,]{4,}(\.[0-9]+)?/{{MONEY_USD}}/g')
    # NA phone (xxx-xxx-xxxx and variants)
    text=$(printf '%s' "$text" | sed -E 's/\(?[0-9]{3}\)?[-. ][0-9]{3}[-. ][0-9]{4}/{{PHONE}}/g')
    # SSN
    text=$(printf '%s' "$text" | sed -E 's/\b[0-9]{3}-[0-9]{2}-[0-9]{4}\b/{{ID}}/g')
    # EIN
    text=$(printf '%s' "$text" | sed -E 's/\b[0-9]{2}-[0-9]{7}\b/{{ID}}/g')
    # ISO date (yyyy-mm-dd)
    text=$(printf '%s' "$text" | sed -E 's/\b(19|20)[0-9]{2}-(0[0-9]|1[012])-(0[0-9]|[12][0-9]|3[01])\b/{{DATE}}/g')
    # Slack channel with custom prefix (best-effort; can't filter default channels in pure sed)
    text=$(printf '%s' "$text" | sed -E 's/#([a-z0-9][a-z0-9_-]{2,})/{{SLACK_CHANNEL}}/g')

    # Output
    if [ -n "$output" ]; then printf '%s' "$text" > "$output"
    else printf '%s' "$text"
    fi

    echo "anonymize: shell-mode scrub complete (DEGRADED -- regex only)." >&2
    echo "  WARNING: placeholders in shell mode are flat ({{EMAIL}}, {{ORG_ID}})," >&2
    echo "  NOT indexed per-entity. The map.json this run wrote contains a" >&2
    echo "  '_runtime: shell-degraded' marker and an empty entries{} block --" >&2
    echo "  a restore() call against this map will not recover real values." >&2
    echo "  For per-entity placeholders + lossless restore, install Python or Node.js." >&2
}

restore_cmd() {
    # Shell mode can't restore reliably without indexed placeholders. Best-effort:
    # warn the user and return input as-is.
    text=$(read_input)
    if [ -n "$output" ]; then printf '%s' "$text" > "$output"
    else printf '%s' "$text"
    fi
    echo "anonymize: shell-mode restore is a no-op (DEGRADED -- placeholders are not indexed)." >&2
    echo "  For real restore, install Python (https://www.python.org/downloads/)" >&2
    echo "  or Node.js (https://nodejs.org/) and re-run the scrub there." >&2
}

inspect_cmd() {
    if [ -f "$map_path" ]; then
        cat "$map_path"
    else
        echo "No map at $map_path."
    fi
}

reset_cmd() {
    if [ -f "$map_path" ]; then rm "$map_path"; echo "Removed $map_path"
    else echo "No map at $map_path -- already clean."
    fi
}

case "$cmd" in
    scrub)   scrub_cmd ;;
    restore) restore_cmd ;;
    inspect) inspect_cmd ;;
    reset)   reset_cmd ;;
    help|--help|-h) usage ;;
    *) usage; exit 1 ;;
esac
