#!/bin/sh
# download — headless Chrome/Chromium path.
# Uses Chrome's --headless --dump-dom to render JavaScript, then saves the result.
# Works on macOS, Linux, and Windows (Git Bash / WSL).
#
# Usage:
#   sh harvest-chrome.sh [--headless-old] <url> [out-dir]
#
#   --headless-old   Use Chrome's legacy --headless=old instead of the
#                    default --headless=new. Different bot-detection
#                    fingerprint — sometimes bypasses block rules
#                    written for the new headless flag (Akamai,
#                    Cloudflare). Worth trying when --headless=new
#                    returns an Edgesuite "Access Denied" page.
set -u

headless_mode="new"
case "${1:-}" in
  --headless-old) headless_mode="old"; shift ;;
esac

url="${1:-}"
out="${2:-references}"
[ -z "$url" ] && { echo "usage: harvest-chrome.sh [--headless-old] <url> [out-dir]" >&2; exit 1; }

# SAFETY SHORT-CIRCUITS: refuse sign-in-wall hosts and binary installers
# before doing any work so we don't save useless artifacts as citations.
case "$(printf '%s' "$url" | tr '[:upper:]' '[:lower:]')" in
  *://linkedin.com/*|*://www.linkedin.com/*)
    echo "download: skipped $url" >&2
    echo "  reason: LinkedIn URLs sit behind a sign-in wall. Use the focus-group local-files workaround." >&2
    exit 0
    ;;
  *.exe|*.msi|*.dmg|*.pkg|*.appimage)
    echo "download: skipped $url" >&2
    echo "  reason: refusing binary installer -- Safety Rule 3." >&2
    exit 0
    ;;
esac

slug=$(printf '%s' "$url" | sed -e 's#^https\{0,1\}://##' -e 's#[^A-Za-z0-9._-]#-#g' | cut -c1-80)
dir="$out/$slug"
mkdir -p "$dir"
today=$(date +%Y-%m-%d)

# JSON-escape a string for safe inclusion in a "..." value. Covers
# backslash and doublequote (the two ways a URL or title could break
# meta.json). Tabs become \t. Newlines are not preserved -- titles
# and URLs are single-line in practice.
json_esc() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' | tr '\t' ' '
}

# Locate Chrome/Chromium binary. Priority: real Chrome (Chrome.app on
# macOS, chrome.exe on Windows-via-Git-Bash/WSL, google-chrome on Linux)
# > Edge > Chromium > Chromium-derivatives. Real Chrome is much less
# bot-detected than Playwright's bundled Chromium.
CHROME=""
for candidate in \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "$HOME/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/c/Program Files/Google/Chrome/Application/chrome.exe" \
  "/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" \
  "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" \
  "/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" \
  "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
  "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" \
  "/c/Program Files/Microsoft/Edge/Application/msedge.exe" \
  "/Applications/Chromium.app/Contents/MacOS/Chromium" \
  ""; do
  [ -n "$candidate" ] && [ -x "$candidate" ] && { CHROME="$candidate"; break; }
done
if [ -z "$CHROME" ]; then
  for cmd in google-chrome google-chrome-stable chrome chromium chromium-browser msedge brave-browser; do
    command -v "$cmd" >/dev/null 2>&1 && { CHROME="$cmd"; break; }
  done
fi
if [ -z "$CHROME" ]; then
  echo "ERROR: real Chrome / Edge / Chromium not found on this host." >&2
  echo "Looked in macOS /Applications, Windows Program Files (Git Bash + WSL paths), and PATH." >&2
  echo "Fix: install Chrome from https://www.google.com/chrome/ (recommended), or fall back to Playwright via harvest.py / harvest.mjs." >&2
  exit 1
fi

# Direct PDF check.
is_pdf=0
case "$url" in *.pdf|*.PDF) is_pdf=1 ;; esac
if [ "$is_pdf" = "1" ]; then
  if command -v curl >/dev/null 2>&1; then curl -fsSL "$url" -o "$dir/document.pdf"
  elif command -v wget >/dev/null 2>&1; then wget -q "$url" -O "$dir/document.pdf"
  else echo "ERROR: curl/wget needed for PDF download" >&2; exit 1; fi
  pdf_bytes=$(wc -c < "$dir/document.pdf" 2>/dev/null | tr -d ' ')
  url_e=$(json_esc "$url")
  cat > "$dir/meta.json" <<EOF
{"url":"$url_e","title":"","retrieved":"$today","type":"pdf","method":"direct-pdf","bytes":${pdf_bytes:-0}}
EOF
  echo "saved PDF: $dir/document.pdf"
  exit 0
fi

# Render with real Chrome in an isolated, temporary user-data-dir.
# Why: if the user already has Chrome running on their default profile,
# Chrome holds an exclusive lock on that profile dir and a fresh
# invocation either fails outright or shares state in unintended ways.
# An isolated profile also prevents the user's logged-in session
# cookies from leaking to the harvest target, and gives every harvest
# a clean fingerprint.
if command -v mktemp >/dev/null 2>&1; then
  profile_dir=$(mktemp -d -t chrome-harvest-XXXXXX 2>/dev/null || mktemp -d)
else
  profile_dir="${TMPDIR:-/tmp}/chrome-harvest-$$-$(date +%s)"
  mkdir -p "$profile_dir"
fi
trap 'rm -rf "$profile_dir" 2>/dev/null' EXIT INT TERM
# When Chrome is a Windows .exe (Git Bash), pass it a Windows-style path.
case "$CHROME" in
  *.exe)
    if command -v cygpath >/dev/null 2>&1; then
      profile_dir_native=$(cygpath -w "$profile_dir")
    else
      profile_dir_native="$profile_dir"
    fi
    ;;
  *) profile_dir_native="$profile_dir" ;;
esac

# Headless mode with --dump-dom. headless_mode is "new" (default) or
# "old" — different bot-detection fingerprints; --headless-old can
# sometimes slip past block rules written for the new flag.
#
# --virtual-time-budget caps Chrome's internal clock at 20 seconds so
# bot-block challenge pages with infinite-redirect or
# wait-for-JS-to-finish loops can't hang the script. The shell-level
# kill below is a backstop — if Chrome ignores the budget (some block
# pages do), we kill the process tree after a wall-clock timeout.
"$CHROME" --headless="$headless_mode" --disable-gpu --no-first-run \
          --user-data-dir="$profile_dir_native" \
          --no-default-browser-check \
          --virtual-time-budget=20000 \
          --dump-dom "$url" > "$dir/.dump-dom.tmp" 2>/dev/null &
chrome_pid=$!
# Wall-clock timeout: if Chrome is still running after 30s, kill it.
( sleep 30; kill -TERM "$chrome_pid" 2>/dev/null; sleep 2; kill -KILL "$chrome_pid" 2>/dev/null ) &
watchdog_pid=$!
wait "$chrome_pid" 2>/dev/null
chrome_exit=$?
# Cancel the watchdog if Chrome finished on its own.
kill "$watchdog_pid" 2>/dev/null
wait "$watchdog_pid" 2>/dev/null

if [ -s "$dir/.dump-dom.tmp" ]; then
  html=$(cat "$dir/.dump-dom.tmp")
  rm -f "$dir/.dump-dom.tmp"
else
  rm -f "$dir/.dump-dom.tmp"
  html=""
fi
if [ -z "$html" ]; then
  echo "ERROR: Chrome --dump-dom returned empty output for $url" >&2
  if [ "$headless_mode" = "new" ]; then
    echo "Hint: if this page bot-blocks --headless=new (Akamai/Cloudflare)," >&2
    echo "      retry with: sh harvest-chrome.sh --headless-old $url $out" >&2
  fi
  echo "Falling back to static fetch..."
  if command -v curl >/dev/null 2>&1; then curl -fsSL "$url" > "$dir/page.html"
  elif command -v wget >/dev/null 2>&1; then wget -qO- "$url" > "$dir/page.html"
  else echo "ERROR: no fetch tool available" >&2; exit 1; fi
  method="static (Chrome failed)"
else
  printf '%s' "$html" > "$dir/page.html"
  method="chrome-headless-$headless_mode"
fi

# Extract title and save text version.
title=$(printf '%s' "$html" | sed -n 's/.*<title>\([^<]*\)<\/title>.*/\1/p' | head -1)
text=$(printf '%s' "$html" | sed -e 's/<[Ss][Cc][Rr][Ii][Pp][Tt][^>]*>.*<\/[Ss][Cc][Rr][Ii][Pp][Tt]>//g' \
  -e 's/<[Ss][Tt][Yy][Ll][Ee][^>]*>.*<\/[Ss][Tt][Yy][Ll][Ee]>//g' \
  -e 's/<[^>]*>/ /g' -e 's/&nbsp;/ /g' -e 's/&amp;/\&/g' \
  -e 's/[ \t][ \t]*/ /g')

cat > "$dir/page.md" <<EOF
# ${title:-$url}

Source: $url
Retrieved: $today

$text
EOF

html_bytes=$(wc -c < "$dir/page.html" 2>/dev/null | tr -d ' ')
url_e=$(json_esc "$url")
title_e=$(json_esc "${title:-}")
method_e=$(json_esc "$method")

# Detect a bot-block page so callers don't treat an Akamai/Cloudflare
# "Access Denied" shell as a valid citation. Three signatures:
#   1. Akamai Edgesuite reference codes (errors.edgesuite.net or
#      "Reference #18.<hex>" pattern in the body).
#   2. Cloudflare's "Just a moment..." or challenge title.
#   3. Tiny page with a bot-block keyword in the title.
blocked=0
if printf '%s' "$title" | grep -i -E "Access Denied|Just a moment|Attention Required|Pardon Our Interruption|Are you a robot" >/dev/null 2>&1; then
  blocked=1
elif grep -i -E "errors\.edgesuite\.net|Reference #18\.|Cloudflare Ray ID|cf-error-details" "$dir/page.html" >/dev/null 2>&1; then
  blocked=1
fi

if [ "$blocked" = "1" ]; then
  method="$method (bot-blocked)"
fi
method_e=$(json_esc "$method")
cat > "$dir/meta.json" <<EOF
{"url":"$url_e","title":"$title_e","retrieved":"$today","type":"html","method":"$method_e","bytes":${html_bytes:-0},"bot_blocked":${blocked:-0}}
EOF

if [ "$blocked" = "1" ]; then
  echo "saved: $dir/page.html and page.md (method: $method)"
  echo "" >&2
  echo "** Bot-block detected ** the page came back as an Access Denied / challenge shell." >&2
  echo "  What I did: saved the block page so you can see what was returned, and tagged" >&2
  echo "  meta.json with bot_blocked: 1 so /focus-group won't cite it." >&2
  if [ "$headless_mode" = "new" ]; then
    echo "  What you could do (cheapest first):" >&2
    echo "    1. Retry with a different fingerprint:" >&2
    echo "         sh harvest-chrome.sh --headless-old \"$url\" $out" >&2
    echo "    2. If that also gets blocked, the site is fingerprinting at the network" >&2
    echo "       edge (egress IP, no warmed cookies). Open the URL in your normal" >&2
    echo "       browser, save the page (File → Save As → Webpage Complete) into" >&2
    echo "       $dir/, and re-run whatever called /download." >&2
  else
    echo "  What you could do: the site is fingerprinting at the network edge." >&2
    echo "  Open the URL in your normal browser, save the page (File → Save As →" >&2
    echo "  Webpage Complete) into $dir/, and re-run whatever called /download." >&2
  fi
  echo "  If you'd like, paste the screen you see and I'll translate it." >&2
else
  echo "saved: $dir/page.html and page.md (method: $method)"
fi
