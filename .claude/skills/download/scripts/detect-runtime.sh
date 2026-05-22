#!/bin/sh
# Probe the host for runtimes the download skill can use.
# Pure POSIX sh — needs nothing installed. Prints a human + AI readable report.
set -u

have() { command -v "$1" >/dev/null 2>&1; }
mark() { if [ "$1" = "1" ]; then printf '  [ yes ] %s\n' "$2"; else printf '  [  no ] %s\n' "$2"; fi; }

py=0; pyplay=0; node=0; nodeplay=0; ps=0; edge=0; chrome=0; curlw=0

if have python3; then PY=python3; py=1; elif have python; then PY=python; py=1; fi
if [ "$py" = "1" ]; then
  "$PY" -c "import playwright" >/dev/null 2>&1 && pyplay=1
fi
if have node; then
  node=1
  node -e "require.resolve('playwright')" >/dev/null 2>&1 && nodeplay=1
  [ "$nodeplay" = "0" ] && { node -e "require.resolve('puppeteer')" >/dev/null 2>&1 && nodeplay=1; }
fi
if have pwsh || have powershell; then ps=1; fi
if have msedge || [ -x "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" ]; then edge=1; fi
if have google-chrome || have chromium || have chrome; then chrome=1
elif [ -x "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]; then chrome=1
elif [ -x "$HOME/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]; then chrome=1
elif [ -x "/Applications/Chromium.app/Contents/MacOS/Chromium" ]; then chrome=1
fi
if have curl || have wget; then curlw=1; fi

echo "download — runtime probe"
echo "-------------------------"
mark "$py"       "Python 3"
mark "$pyplay"   "  + Playwright (python -m pip install playwright)"
mark "$node"     "Node.js"
mark "$nodeplay" "  + Playwright or Puppeteer"
mark "$ps"       "PowerShell"
mark "$edge"     "Microsoft Edge (headless-capable)"
mark "$chrome"   "Chrome / Chromium"
mark "$curlw"    "curl or wget"
echo "-----------------------------------"

# Priority order: prefer the user's REAL Chrome/Edge over Playwright's
# bundled Chromium. Real browsers (Chrome.app on macOS, msedge.exe on
# Windows, google-chrome on Linux) are far less likely to be bot-blocked
# by Akamai / Cloudflare / Google captcha than headless Chromium, which
# advertises itself as headless via well-known fingerprints. They are
# usually already installed, so this is also the zero-install path for
# most users.
if   [ "$chrome" = "1" ]; then
     echo "RECOMMENDED PATH: scripts/harvest-chrome.sh  (real Chrome --headless=new --dump-dom)"
     echo "REASON: real Chrome dodges most bot-detection that blocks Playwright's Chromium."
elif [ "$edge" = "1" ] && [ "$ps" = "1" ]; then
     echo "RECOMMENDED PATH: scripts/harvest.ps1  (real Microsoft Edge headless)"
     echo "REASON: real Edge dodges most bot-detection that blocks Playwright's Chromium."
elif [ "$pyplay"   = "1" ]; then echo "RECOMMENDED PATH: scripts/harvest.py   (Python + Playwright)"
elif [ "$nodeplay" = "1" ]; then echo "RECOMMENDED PATH: scripts/harvest.mjs  (Node.js headless browser)"
elif [ "$curlw" = "1" ]; then
     echo "RECOMMENDED PATH: scripts/fetch-basic.sh  (no JavaScript rendering)"
     echo "NOTE: JS-rendered pages may be incomplete. See README.md to add a headless browser."
else
     echo "NO USABLE PATH FOUND. Install one of the options in README.md."
fi
