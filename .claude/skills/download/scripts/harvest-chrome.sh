#!/bin/sh
# download — headless Chrome/Chromium path.
# Uses Chrome's --headless --dump-dom to render JavaScript, then saves the result.
# Works on macOS, Linux, and Windows (Git Bash / WSL).
#
# Usage:  sh harvest-chrome.sh <url> [out-dir]
set -u

url="${1:-}"
out="${2:-references}"
[ -z "$url" ] && { echo "usage: harvest-chrome.sh <url> [out-dir]" >&2; exit 1; }

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

# Locate Chrome/Chromium binary.
CHROME=""
for candidate in \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "$HOME/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/Applications/Chromium.app/Contents/MacOS/Chromium" \
  ""; do
  [ -n "$candidate" ] && [ -x "$candidate" ] && { CHROME="$candidate"; break; }
done
if [ -z "$CHROME" ]; then
  for cmd in google-chrome chromium chrome chromium-browser; do
    command -v "$cmd" >/dev/null 2>&1 && { CHROME="$cmd"; break; }
  done
fi
if [ -z "$CHROME" ]; then
  echo "ERROR: Chrome/Chromium not found." >&2
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

# Render with headless Chrome.
html=$("$CHROME" --headless=new --disable-gpu --no-first-run --dump-dom "$url" 2>/dev/null)
if [ -z "$html" ]; then
  echo "ERROR: Chrome --dump-dom returned empty output for $url" >&2
  echo "Falling back to static fetch..."
  if command -v curl >/dev/null 2>&1; then curl -fsSL "$url" > "$dir/page.html"
  elif command -v wget >/dev/null 2>&1; then wget -qO- "$url" > "$dir/page.html"
  else echo "ERROR: no fetch tool available" >&2; exit 1; fi
  method="static (Chrome failed)"
else
  printf '%s' "$html" > "$dir/page.html"
  method="chrome-headless"
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
cat > "$dir/meta.json" <<EOF
{"url":"$url_e","title":"$title_e","retrieved":"$today","type":"html","method":"$method_e","bytes":${html_bytes:-0}}
EOF
echo "saved: $dir/page.html and page.md (method: $method)"
