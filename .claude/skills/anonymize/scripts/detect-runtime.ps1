# detect-runtime.ps1 -- Windows-native runtime probe for /anonymize.
#
# Same contract as detect-runtime.sh: prints a single-token recommendation
# on stdout, a human-readable report on stderr.
#
# Output token (stdout, one of):
#   python      -> use scripts/anonymize.py
#   node        -> use scripts/anonymize.mjs
#   powershell  -> use scripts/anonymize.ps1 (DEGRADED -- L1 + L2 only)
#   shell       -> use scripts/anonymize.sh  (DEGRADED -- L1 + L2 only;
#                                              requires Git Bash / WSL on Windows)
#   none        -> nothing usable; surface the install offer

$ErrorActionPreference = "SilentlyContinue"

$found_python    = $null
$found_node      = $null
$found_pwsh      = $false
$found_shell     = $null

# Python 3
foreach ($p in @("python3", "python", "py")) {
    $cmd = Get-Command $p -ErrorAction SilentlyContinue
    if ($cmd) {
        $ver = & $p -c "import sys; print(sys.version_info[0])" 2>$null
        if ($ver -eq "3") { $found_python = $p; break }
    }
}

# Node.js
$cmd = Get-Command node -ErrorAction SilentlyContinue
if ($cmd) {
    $v = & node --version 2>$null
    if ($LASTEXITCODE -eq 0) { $found_node = "node" }
}

# PowerShell (we're running it -- always true here, but record it)
$found_pwsh = $true

# POSIX shell (Git Bash / WSL)
$cmd = Get-Command sh -ErrorAction SilentlyContinue
if ($cmd) { $found_shell = "shell" }

# Report
[Console]::Error.WriteLine("anonymize runtime probe (Windows):")
if ($found_python) { [Console]::Error.WriteLine("  python3    : found ($found_python)") }
else               { [Console]::Error.WriteLine("  python3    : NOT FOUND") }
if ($found_node)   { [Console]::Error.WriteLine("  node       : found") }
else               { [Console]::Error.WriteLine("  node       : NOT FOUND") }
if ($found_pwsh)   { [Console]::Error.WriteLine("  powershell : found (this shell)") }
if ($found_shell)  { [Console]::Error.WriteLine("  POSIX sh   : found (Git Bash / WSL)") }
else               { [Console]::Error.WriteLine("  POSIX sh   : NOT FOUND") }

# Pick the best (Python > Node > PowerShell > POSIX sh)
if ($found_python) {
    Write-Output "python"
} elseif ($found_node) {
    Write-Output "node"
} elseif ($found_pwsh) {
    Write-Output "powershell"
    [Console]::Error.WriteLine("")
    [Console]::Error.WriteLine("WARNING: only PowerShell available. Anonymize will use DEGRADED mode --")
    [Console]::Error.WriteLine("  Layer 1 (caller-supplied entities) + Layer 2 (regex patterns) only.")
    [Console]::Error.WriteLine("  Layer 3 (heuristic proper-noun detection) is NOT available in this mode.")
    [Console]::Error.WriteLine("  For full coverage, install Python 3 or Node.js:")
    [Console]::Error.WriteLine("    Python:   https://www.python.org/downloads/   (about 3 minutes)")
    [Console]::Error.WriteLine("    Node.js:  https://nodejs.org/                  (about 3 minutes)")
} elseif ($found_shell) {
    Write-Output "shell"
} else {
    Write-Output "none"
}
