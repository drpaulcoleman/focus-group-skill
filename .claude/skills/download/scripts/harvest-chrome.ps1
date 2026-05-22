<#
  download - real Chrome (Windows-native PowerShell path).

  Renders a URL with REAL Google Chrome via --headless=new --dump-dom and
  saves the rendered HTML, a markdown text extract, and meta.json.
  Real Chrome is preferred over Edge (this script's sibling harvest.ps1)
  and over Playwright's bundled Chromium because real Chrome dodges most
  bot-detection (Akamai, Cloudflare, Google captcha) that blocks
  headless Chromium fingerprints.

  Usage:
    powershell -File harvest-chrome.ps1 -Url <url> [-Out references] [-HeadlessOld]

    -HeadlessOld : Use Chrome's legacy --headless=old instead of the
                   default --headless=new. Different bot-detection
                   fingerprint — sometimes bypasses block rules
                   written for the new headless flag (Akamai,
                   Cloudflare). Worth trying when --headless=new
                   returns an Edgesuite "Access Denied" page.
#>
param(
  [Parameter(Mandatory = $true)][string]$Url,
  [string]$Out = "references",
  [switch]$HeadlessOld
)
$headlessMode = if ($HeadlessOld) { "old" } else { "new" }
$ErrorActionPreference = "Stop"
$today = (Get-Date).ToString("yyyy-MM-dd")

# SAFETY SHORT-CIRCUITS: matches harvest.ps1 / harvest-chrome.sh.
$lowUrl = $Url.ToLower()
$signInHosts = @('linkedin.com')
$blockedExt  = @('.exe', '.msi', '.dmg', '.pkg', '.appimage')
foreach ($h in $signInHosts) {
  if ($lowUrl.Contains('://' + $h) -or $lowUrl.Contains('://www.' + $h)) {
    [Console]::Error.WriteLine("download: skipped $Url`n  reason: LinkedIn URLs sit behind a sign-in wall; use the focus-group local-files workaround.")
    exit 0
  }
}
foreach ($ext in $blockedExt) {
  if ($lowUrl.EndsWith($ext)) {
    [Console]::Error.WriteLine("download: skipped $Url`n  reason: refusing $ext binary -- Safety Rule 3.")
    exit 0
  }
}

function Get-Slug([string]$s) {
  $x = ($s -replace '^https?://', '' -replace '[^A-Za-z0-9._-]+', '-').Trim('-')
  if ($x.Length -gt 80) { $x = $x.Substring(0, 80) }
  if ([string]::IsNullOrEmpty($x)) { $x = "item" }
  return $x
}

$dir = Join-Path $Out (Get-Slug $Url)
New-Item -ItemType Directory -Force -Path $dir | Out-Null
function Save-Meta($o) {
  $o | ConvertTo-Json | Set-Content -Encoding utf8 (Join-Path $dir "meta.json")
}

# Direct PDF.
if ($Url -match '\.pdf($|\?)') {
  Invoke-WebRequest -Uri $Url -OutFile (Join-Path $dir "document.pdf") -UseBasicParsing
  Save-Meta @{ url = $Url; retrieved = $today; type = "pdf"; method = "direct-pdf" }
  Write-Output "saved PDF: $(Join-Path $dir 'document.pdf')"
  exit 0
}

# Locate REAL Chrome (preferred over Edge or Chromium).
$chrome = $null
foreach ($p in @(
    "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "${env:LOCALAPPDATA}\Google\Chrome\Application\chrome.exe")) {
  if ($p -and (Test-Path $p)) { $chrome = $p; break }
}
if (-not $chrome) {
  $c = Get-Command chrome -ErrorAction SilentlyContinue
  if ($c) { $chrome = $c.Source }
}
if (-not $chrome) {
  [Console]::Error.WriteLine("ERROR: real Google Chrome not found at the standard install paths.`nFix: install Chrome from https://www.google.com/chrome/, or use harvest.ps1 for Edge instead.")
  exit 1
}

# Render with real Chrome in an isolated, temporary user-data-dir.
# Why: if the user already has Chrome running on their default profile,
# Chrome holds an exclusive lock on that profile dir and a fresh
# invocation either fails outright or shares state in unintended ways.
# An isolated profile also prevents the user's logged-in session
# cookies from leaking to the harvest target, and gives every harvest
# a clean fingerprint.
$profileDir = Join-Path $env:TEMP ("chrome-harvest-" + [Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $profileDir | Out-Null

$tmp = Join-Path $env:TEMP ("rh-" + [Guid]::NewGuid().ToString("N") + ".html")
try {
  # Headless mode with --dump-dom. headlessMode is "new" (default) or
  # "old" — different bot-detection fingerprints; --headless=old can
  # sometimes slip past block rules written for the new flag.
  #
  # --virtual-time-budget caps Chrome's internal clock at 20s so
  # block-page redirect loops can't hang the script. The 30s
  # wall-clock kill below is a backstop for pages where Chrome
  # ignores the budget.
  $proc = Start-Process -FilePath $chrome -ArgumentList @(
    "--headless=$headlessMode",
    "--disable-gpu",
    "--no-first-run",
    "--user-data-dir=$profileDir",
    "--no-default-browser-check",
    "--virtual-time-budget=20000",
    "--dump-dom",
    $Url
  ) -RedirectStandardOutput $tmp -RedirectStandardError $null -PassThru -NoNewWindow
  if (-not $proc.WaitForExit(30000)) {
    # Chrome is hung on a block-page challenge — kill it.
    try { $proc.Kill() } catch {}
    Start-Sleep -Milliseconds 500
  }
  $html = $null
  if ((Test-Path $tmp) -and (Get-Item $tmp).Length -gt 0) {
    $html = Get-Content -Raw $tmp
    Remove-Item $tmp -Force
  }
}
finally {
  Remove-Item -Recurse -Force -Path $profileDir -ErrorAction SilentlyContinue
}

if (-not $html) {
  [Console]::Error.WriteLine("ERROR: real Chrome --dump-dom returned empty output for $Url")
  if ($headlessMode -eq "new") {
    [Console]::Error.WriteLine("Hint: if this page bot-blocks --headless=new (Akamai/Cloudflare),")
    [Console]::Error.WriteLine("      retry with: powershell -File harvest-chrome.ps1 -Url $Url -HeadlessOld")
  }
  exit 1
}

$html | Set-Content -Encoding utf8 (Join-Path $dir "page.html")
$text = $html -replace '(?is)<(script|style|noscript)[^>]*>.*?</\1>', ' ' `
              -replace '<[^>]+>', ' ' -replace '&nbsp;', ' ' -replace '[ \t]+', ' '
$title = ([regex]::Match($html, '(?is)<title>(.*?)</title>').Groups[1].Value).Trim()
"# $title`n`nSource: $Url`nRetrieved: $today`n`n$text" |
  Set-Content -Encoding utf8 (Join-Path $dir "page.md")

# Detect a bot-block page so callers don't treat an Akamai/Cloudflare
# "Access Denied" shell as a valid citation. Three signatures:
#   1. Akamai Edgesuite reference codes (errors.edgesuite.net or
#      "Reference #18.<hex>" pattern in the body).
#   2. Cloudflare's "Just a moment..." or challenge title.
#   3. Tiny page with a bot-block keyword in the title.
$blocked = $false
if ($title -match '(?i)Access Denied|Just a moment|Attention Required|Pardon Our Interruption|Are you a robot') {
  $blocked = $true
}
elseif ($html -match 'errors\.edgesuite\.net|Reference #18\.|Cloudflare Ray ID|cf-error-details') {
  $blocked = $true
}

$method = "chrome-headless-$headlessMode"
if ($blocked) { $method = "$method (bot-blocked)" }
Save-Meta @{ url = $Url; title = $title; retrieved = $today; type = "html"; method = $method; bot_blocked = [int]$blocked }

if ($blocked) {
  Write-Output "saved: $(Join-Path $dir 'page.html') and page.md (method: $method)"
  [Console]::Error.WriteLine("")
  [Console]::Error.WriteLine("** Bot-block detected ** the page came back as an Access Denied / challenge shell.")
  [Console]::Error.WriteLine("  What I did: saved the block page so you can see what was returned, and tagged")
  [Console]::Error.WriteLine("  meta.json with bot_blocked: 1 so /focus-group won't cite it.")
  if ($headlessMode -eq "new") {
    [Console]::Error.WriteLine("  What you could do (cheapest first):")
    [Console]::Error.WriteLine("    1. Retry with a different fingerprint:")
    [Console]::Error.WriteLine("         powershell -File harvest-chrome.ps1 -Url `"$Url`" -HeadlessOld")
    [Console]::Error.WriteLine("    2. If that also gets blocked, the site is fingerprinting at the network")
    [Console]::Error.WriteLine("       edge (egress IP, no warmed cookies). Open the URL in your normal")
    [Console]::Error.WriteLine("       browser, save the page (File -> Save As -> Webpage Complete) into")
    [Console]::Error.WriteLine("       $dir\, and re-run whatever called /download.")
  } else {
    [Console]::Error.WriteLine("  What you could do: the site is fingerprinting at the network edge.")
    [Console]::Error.WriteLine("  Open the URL in your normal browser, save the page (File -> Save As ->")
    [Console]::Error.WriteLine("  Webpage Complete) into $dir\, and re-run whatever called /download.")
  }
  [Console]::Error.WriteLine("  If you'd like, paste the screen you see and I'll translate it.")
} else {
  Write-Output "saved: $(Join-Path $dir 'page.html') and page.md (method: $method)"
}
