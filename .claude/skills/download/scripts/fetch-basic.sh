#!/bin/sh
# No-JavaScript fallback fetcher: downloads static HTML or a PDF with curl/wget.
# Usage:  sh fetch-basic.sh <url> [out-dir]
# Limitation: does NOT run JavaScript — JS-rendered pages may come back partial.
set -u

url="${1:-}"
out="${2:-references}"
[ -z "$url" ] && { echo "usage: fetch-basic.sh <url> [out-dir]" >&2; exit 1; }

# SAFETY SHORT-CIRCUITS: refuse sign-in-wall hosts and binary installers.
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

# JSON-escape for safe inclusion in a "..." value (backslash + doublequote).
json_esc() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' | tr '\t' ' '
}

if command -v curl >/dev/null 2>&1; then GET="curl -fsSL"; HEAD="curl -fsSLI"
elif command -v wget >/dev/null 2>&1; then GET="wget -qO-"; HEAD="wget -qS --spider"
else echo "ERROR: neither curl nor wget is available." >&2; exit 1; fi

# Direct PDF? (url ends .pdf, or the server reports application/pdf)
is_pdf=0
case "$url" in *.pdf|*.PDF) is_pdf=1 ;; esac
if [ "$is_pdf" = "0" ] && command -v curl >/dev/null 2>&1; then
  $HEAD "$url" 2>/dev/null | grep -iq 'content-type:.*application/pdf' && is_pdf=1
fi

if [ "$is_pdf" = "1" ]; then
  if command -v curl >/dev/null 2>&1; then curl -fsSL "$url" -o "$dir/document.pdf"
  else wget -q "$url" -O "$dir/document.pdf"; fi
  echo "saved PDF: $dir/document.pdf"
  body_file="document.pdf"
  doc_type="pdf"
else
  $GET "$url" > "$dir/page.html" 2>/dev/null || { echo "ERROR: fetch failed for $url" >&2; exit 1; }
  echo "saved HTML: $dir/page.html"
  echo "NOTE: JavaScript was NOT executed — review page.html for completeness."
  body_file="page.html"
  doc_type="html"
fi

bytes=$(wc -c < "$dir/$body_file" 2>/dev/null | tr -d ' ')
# Extract a title from HTML if we can; PDFs leave it blank.
title=""
if [ "$doc_type" = "html" ]; then
  title=$(sed -n 's/.*<title>\([^<]*\)<\/title>.*/\1/p' "$dir/page.html" | head -1)
fi
url_e=$(json_esc "$url")
title_e=$(json_esc "$title")
cat > "$dir/meta.json" <<EOF
{"url":"$url_e","title":"$title_e","retrieved":"$today","type":"$doc_type","method":"fetch-basic (no JavaScript)","bytes":${bytes:-0}}
EOF
echo "saved meta: $dir/meta.json   (retrieved $today)"
