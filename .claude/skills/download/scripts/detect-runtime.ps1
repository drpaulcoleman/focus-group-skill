<#
  download - PowerShell runtime probe (Windows-native, no Git Bash needed).

  Mirror of detect-runtime.sh. Same priority order: REAL Chrome / Edge are
  preferred over Playwright's bundled Chromium because real browsers dodge
  most bot-detection (Akamai, Cloudflare, Google captcha) that blocks
  headless Chromium fingerprints.

  Usage:  powershell -File detect-runtime.ps1
#>
$ErrorActionPreference = "Continue"

function Test-Cmd([string]$name) {
  $null = Get-Command $name -ErrorAction SilentlyContinue
  return $?
}

function Mark($ok, $label) {
  if ($ok) { Write-Output ("  [ yes ] {0}" -f $label) }
  else     { Write-Output ("  [  no ] {0}" -f $label) }
}

# Probe targets.
$py        = Test-Cmd python; if (-not $py) { $py = Test-Cmd python3 }
$pyplay    = $false
if ($py) {
  $cmd = if (Test-Cmd python) { "python" } else { "python3" }
  & $cmd -c "import playwright" 2>$null | Out-Null
  $pyplay = ($LASTEXITCODE -eq 0)
}
$node      = Test-Cmd node
$nodeplay  = $false
if ($node) {
  & node -e "require.resolve('playwright')" 2>$null | Out-Null
  $nodeplay = ($LASTEXITCODE -eq 0)
  if (-not $nodeplay) {
    & node -e "require.resolve('puppeteer')" 2>$null | Out-Null
    $nodeplay = ($LASTEXITCODE -eq 0)
  }
}

# Real Chrome (preferred over Edge — wider compat and identical bot-evasion).
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

# Real Edge (Windows 11 default).
$edge = $null
foreach ($p in @(
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
    "${env:ProgramFiles}\Microsoft\Edge\Application\msedge.exe")) {
  if ($p -and (Test-Path $p)) { $edge = $p; break }
}
if (-not $edge) {
  $c = Get-Command msedge -ErrorAction SilentlyContinue
  if ($c) { $edge = $c.Source }
}

$curlw = (Test-Cmd curl) -or (Test-Cmd wget)

Write-Output "download - runtime probe"
Write-Output "-------------------------"
Mark $py        "Python 3"
Mark $pyplay    "  + Playwright (python -m pip install playwright)"
Mark $node      "Node.js"
Mark $nodeplay  "  + Playwright or Puppeteer"
Mark ($chrome -ne $null) "Real Google Chrome"
Mark ($edge -ne $null)   "Real Microsoft Edge"
Mark $curlw     "curl / wget / Invoke-WebRequest"
Write-Output "-----------------------------------"

# Priority: real Chrome > real Edge > Playwright > static fetch.
if ($chrome) {
  Write-Output "RECOMMENDED PATH: scripts\harvest-chrome.ps1  (real Chrome --headless=new --dump-dom)"
  Write-Output "REASON: real Chrome dodges most bot-detection that blocks Playwright's Chromium."
}
elseif ($edge) {
  Write-Output "RECOMMENDED PATH: scripts\harvest.ps1  (real Edge headless)"
  Write-Output "REASON: real Edge dodges most bot-detection that blocks Playwright's Chromium."
}
elseif ($pyplay) {
  Write-Output "RECOMMENDED PATH: scripts\harvest.py  (Python + Playwright)"
}
elseif ($nodeplay) {
  Write-Output "RECOMMENDED PATH: scripts\harvest.mjs  (Node.js headless browser)"
}
elseif ($curlw -or $true) {
  Write-Output "RECOMMENDED PATH: scripts\harvest.ps1 -NoJs  (Invoke-WebRequest, no JavaScript)"
  Write-Output "NOTE: JS-rendered pages may be incomplete. See README.md to add a headless browser."
}
else {
  Write-Output "NO USABLE PATH FOUND. Install Chrome from https://www.google.com/chrome/ -- recommended."
}
