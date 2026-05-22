# anonymize.ps1 -- PowerShell port of /anonymize (DEGRADED: Layer 1 + Layer 2 only).
#
# Used on Windows when neither Python nor Node.js is installed.
# Same CLI shape as anonymize.py (scrub / restore / inspect / reset).
# Same map.json format on disk -- compatible with the Python/Node versions
# so if a user later installs Python, their existing scrubs stay restorable.
#
# DEGRADED means: no heuristic proper-noun detection (Layer 3). The user
# must pass --scrub <entity> for any name that isn't caught by the regex
# patterns. The skill's SKILL.md tells the agent to do this.

[CmdletBinding()]
param(
    [Parameter(Position=0, Mandatory=$true)]
    [ValidateSet('scrub','restore','inspect','reset','help','--help','-h')]
    [string]$Command,

    [string]$InputPath,
    [string]$Output,
    [string]$Map,
    [string[]]$Scrub
)

$ErrorActionPreference = "Stop"

# Default map path
if (-not $Map) { $Map = Join-Path ".anonymize" "map.json" }

function Load-Map {
    param([string]$Path)
    if (Test-Path $Path) {
        try { return (Get-Content -Raw -Path $Path -Encoding UTF8 | ConvertFrom-Json) }
        catch { }
    }
    return [pscustomobject]@{ version = 1; next_index = @{}; entries = @{} }
}
function Save-Map {
    param([string]$Path, [pscustomobject]$M)
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $tmp = "$Path.tmp"
    $M | ConvertTo-Json -Depth 10 | Set-Content -Path $tmp -Encoding utf8
    Move-Item -Force -Path $tmp -Destination $Path
}

# Convert PSCustomObject -> hashtable (recursive) for mutable updates
function To-Hashtable {
    param($obj)
    if ($obj -is [hashtable]) { return $obj }
    $h = @{}
    foreach ($p in $obj.PSObject.Properties) {
        if ($p.Value -is [System.Management.Automation.PSCustomObject]) {
            $h[$p.Name] = To-Hashtable $p.Value
        } else {
            $h[$p.Name] = $p.Value
        }
    }
    return $h
}

function Allocate {
    param($M, [string]$Kind, [string]$Hint)
    if (-not $M.next_index.ContainsKey($Kind)) { $M.next_index[$Kind] = 0 }
    $M.next_index[$Kind] = [int]$M.next_index[$Kind] + 1
    $n = $M.next_index[$Kind]
    if ($Hint) { return "{{${Kind}_${n}_${Hint}}}" }
    return "{{${Kind}_${n}}}"
}
function Get-OrCreate {
    param($M, [string]$Real, [string]$Kind, [string]$Hint)
    if ($M.entries.ContainsKey($Real)) { return $M.entries[$Real].placeholder }
    $ph = Allocate -M $M -Kind $Kind -Hint $Hint
    $entry = @{ placeholder = $ph; type = $Kind }
    if ($Hint) { $entry.hint = $Hint }
    $M.entries[$Real] = $entry
    return $ph
}

# Regex patterns (Layer 2)
$RX = @{
    EMAIL        = '\b[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}\b'
    PHONE_INTL   = '\+\d{1,3}[\s.\-]?\(?\d{1,4}\)?[\s.\-]?\d{1,4}[\s.\-]?\d{1,9}'
    PHONE_NA     = '\(?\b\d{3}\)?[\s.\-]\d{3}[\s.\-]\d{4}\b'
    SF_ORG_ID    = '\b00[A-Za-z0-9]{13}(?:[A-Za-z]{3})?\b'
    LINKEDIN     = '(?i)(?:https?://)?(?:www\.)?linkedin\.com/(?:in|company|pub)/[A-Za-z0-9_\-/]+'
    SLACK_URL    = '(?i)https?://[a-z0-9\-]+\.slack\.com(?:/[^\s)]*)?'
    SLACK_CHAN   = '#([a-z0-9][a-z0-9_\-]{2,})'
    MONEY_COMMA  = '\$[\d,]{4,}(?:\.\d+)?(?:\s?[KMBkmb])?'
    MONEY_SUFFIX = '\$\d+(?:\.\d+)?\s?[KMBkmb](?:i?l)?(?:lion)?\b'
    REVENUE      = '(?i)\b\d+(?:\.\d+)?\s?[KMBkmb]?\s?(?:ARR|MRR|TCV|ACV|GMV)\b'
    SSN          = '\b\d{3}-\d{2}-\d{4}\b'
    EIN          = '\b\d{2}-\d{7}\b'
    CASE_ID      = '\b(?:OCC|FTC|SEC|EEOC|DOL|HHS|CFPB|FDIC|CMS)\s?(?:[A-Z]+\-)?\d{2,4}\-\d+\b'
    DATE_ISO     = '\b(?:19|20)\d{2}-(?:0\d|1[012])-(?:0\d|[12]\d|3[01])\b'
    HEADCOUNT    = '(?i)\b(\d{1,3}(?:,\d{3})*)\s?(?:employees?|FTEs?|staff)\b'
}

$DEFAULT_CHANNELS = @('general','random','announcements','help','introductions')
$COMPANY_MARKERS = @('Inc','Inc.','LLC','Ltd','Corp','Hospital','Health','Bank','Systems','Group','University','College','Foundation','Authority','District','Trust','Holdings')

function Replace-WithPlaceholder {
    param([string]$Text, [string]$Pattern, $M, [string]$Kind, [scriptblock]$HintFn)
    return [regex]::Replace($Text, $Pattern, {
        param($match)
        $val = $match.Value
        $hint = if ($HintFn) { & $HintFn $val } else { $null }
        Get-OrCreate -M $M -Real $val -Kind $Kind -Hint $hint
    })
}

function Magnitude-Hint {
    param([string]$s)
    $u = $s.ToUpper()
    if ($u -match 'B') { return 'BIL' }
    if ($u -match 'M') { return 'MIL' }
    if ($u -match 'K') { return 'K' }
    return $null
}
function Revenue-Hint {
    param([string]$s)
    $u = $s.ToUpper()
    foreach ($t in @('ARR','MRR','TCV','ACV','GMV')) { if ($u -match $t) { return $t } }
    return $null
}

function Invoke-Scrub {
    param([string]$Text, [string[]]$Known, [string]$MapPath)

    $raw = Load-Map -Path $MapPath
    $M = @{
        version = $raw.version
        next_index = (To-Hashtable $raw.next_index)
        entries = (To-Hashtable $raw.entries)
    }

    # Layer 1: caller-supplied
    foreach ($ent in $Known) {
        if (-not $ent) { continue }
        $kind = 'ENTITY'
        $words = $ent -split '\s+'
        if ($words | Where-Object { $COMPANY_MARKERS -contains $_ }) { $kind = 'COMPANY' }
        elseif ($ent -match '^[A-Z][a-z]+\s+[A-Z][a-z]+(?:\s+[A-Z][a-z]+)?$') { $kind = 'PERSON' }
        $ph = Get-OrCreate -M $M -Real $ent -Kind $kind
        $Text = $Text.Replace($ent, $ph)
    }

    # Layer 2: regex
    $Text = Replace-WithPlaceholder -Text $Text -Pattern $RX.EMAIL        -M $M -Kind 'EMAIL'
    $Text = Replace-WithPlaceholder -Text $Text -Pattern $RX.LINKEDIN     -M $M -Kind 'LINKEDIN'
    $Text = Replace-WithPlaceholder -Text $Text -Pattern $RX.SLACK_URL    -M $M -Kind 'URL'
    $Text = Replace-WithPlaceholder -Text $Text -Pattern $RX.SF_ORG_ID    -M $M -Kind 'ORG_ID'
    $Text = Replace-WithPlaceholder -Text $Text -Pattern $RX.PHONE_INTL   -M $M -Kind 'PHONE'
    $Text = Replace-WithPlaceholder -Text $Text -Pattern $RX.PHONE_NA     -M $M -Kind 'PHONE'
    $Text = Replace-WithPlaceholder -Text $Text -Pattern $RX.SSN          -M $M -Kind 'ID'
    $Text = Replace-WithPlaceholder -Text $Text -Pattern $RX.EIN          -M $M -Kind 'ID'
    $Text = Replace-WithPlaceholder -Text $Text -Pattern $RX.REVENUE      -M $M -Kind 'REVENUE'     -HintFn { Revenue-Hint $args[0] }
    $Text = Replace-WithPlaceholder -Text $Text -Pattern $RX.MONEY_SUFFIX -M $M -Kind 'MONEY_USD' -HintFn { Magnitude-Hint $args[0] }
    $Text = Replace-WithPlaceholder -Text $Text -Pattern $RX.MONEY_COMMA  -M $M -Kind 'MONEY_USD' -HintFn { Magnitude-Hint $args[0] }
    $Text = Replace-WithPlaceholder -Text $Text -Pattern $RX.CASE_ID      -M $M -Kind 'CASE_ID'
    $Text = Replace-WithPlaceholder -Text $Text -Pattern $RX.DATE_ISO     -M $M -Kind 'DATE'

    # Headcount: preserve round buckets
    $round = @(1, 25, 100, 250, 500, 1000, 2500, 5000, 10000, 25000, 50000, 100000)
    $Text = [regex]::Replace($Text, $RX.HEADCOUNT, {
        param($mat)
        $num = $mat.Groups[1].Value
        $n = [int]($num -replace ',', '')
        if ($round -contains $n) { return $mat.Value }
        $noun = $mat.Value.Substring($num.Length).TrimStart()
        return (Get-OrCreate -M $M -Real $num -Kind 'HEADCOUNT') + " $noun"
    })

    # Slack channels (custom prefix only)
    $Text = [regex]::Replace($Text, $RX.SLACK_CHAN, {
        param($mat)
        $name = $mat.Groups[1].Value
        if ($DEFAULT_CHANNELS -contains $name.ToLower()) { return $mat.Value }
        return Get-OrCreate -M $M -Real $mat.Value -Kind 'SLACK_CHANNEL'
    })

    # Save and return
    Save-Map -Path $MapPath -M ([pscustomobject]$M)
    return @{ Text = $Text; Entries = $M.entries }
}

function Invoke-Restore {
    param([string]$Text, [string]$MapPath)
    $raw = Load-Map -Path $MapPath
    $reverse = @{}
    if ($raw.entries) {
        foreach ($p in $raw.entries.PSObject.Properties) {
            $reverse[$p.Value.placeholder] = $p.Name
        }
    }
    $found = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($m in [regex]::Matches($Text, '\{\{[A-Z][A-Z0-9_=]*\}\}')) {
        [void]$found.Add($m.Value)
    }
    $unknown = $found | Where-Object { -not $reverse.ContainsKey($_) } | Sort-Object
    foreach ($ph in ($reverse.Keys | Sort-Object -Property Length -Descending)) {
        $Text = $Text.Replace($ph, $reverse[$ph])
    }
    return @{ Text = $Text; Unknown = $unknown }
}

function Read-Input {
    # NOTE: parameter is $InputPath (not $Input) because $Input is a PowerShell
    # automatic variable bound to the pipeline enumerator; using it as a script
    # parameter caused the function to block waiting for stdin forever.
    if ($InputPath -eq '-' -or (-not $InputPath -and -not [Console]::IsInputRedirected)) {
        # No input
        return $null
    }
    if ($InputPath -eq '-' -or [Console]::IsInputRedirected) {
        return [Console]::In.ReadToEnd()
    }
    if ($InputPath) { return Get-Content -Raw -Path $InputPath -Encoding UTF8 }
    return $null
}

function Summarize {
    param($Entries)
    $counts = @{}
    foreach ($p in $Entries.PSObject.Properties) {
        $t = $p.Value.type
        $counts[$t] = if ($counts.ContainsKey($t)) { $counts[$t] + 1 } else { 1 }
    }
    if ($counts.Count -eq 0) { return "anonymize: scrubbed 0 entities" }
    $parts = ($counts.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object { "$($_.Value) $($_.Key)" }) -join ', '
    $total = ($counts.Values | Measure-Object -Sum).Sum
    return "anonymize: scrubbed $total entities -- $parts"
}

switch ($Command) {
    { @('help','--help','-h') -contains $_ } {
        [Console]::Error.WriteLine("usage: anonymize.ps1 {scrub|restore|inspect|reset} [-InputPath <f>] [-Output <f>] [-Map <f>] [-Scrub <ent>...]")
        [Console]::Error.WriteLine("")
        [Console]::Error.WriteLine("DEGRADED mode: Layer 1 (caller-supplied) + Layer 2 (regex) only.")
        [Console]::Error.WriteLine("For full coverage (Layer 3 heuristic proper-noun detection), install Python or Node.js.")
        exit 0
    }
    'scrub' {
        $text = Read-Input
        if ($null -eq $text) { [Console]::Error.WriteLine("error: no input. Pass -InputPath <file>, '-' for stdin, or pipe."); exit 1 }
        $r = Invoke-Scrub -Text $text -Known $Scrub -MapPath $Map
        if ($Output) { Set-Content -Path $Output -Value $r.Text -Encoding utf8 }
        else { [Console]::Out.Write($r.Text) }
        [Console]::Error.WriteLine((Summarize -Entries ([pscustomobject]$r.Entries)))
    }
    'restore' {
        $text = Read-Input
        if ($null -eq $text) { [Console]::Error.WriteLine("error: no input."); exit 1 }
        $r = Invoke-Restore -Text $text -MapPath $Map
        if ($Output) { Set-Content -Path $Output -Value $r.Text -Encoding utf8 }
        else { [Console]::Out.Write($r.Text) }
        if ($r.Unknown.Count -gt 0) {
            [Console]::Error.WriteLine("anonymize: $($r.Unknown.Count) unknown placeholder(s) left in place: $(($r.Unknown[0..([Math]::Min(9, $r.Unknown.Count-1))]) -join ', ')$(if($r.Unknown.Count -gt 10){'...'})")
        }
    }
    'inspect' {
        if (-not (Test-Path $Map)) { Write-Output "No map at $Map -- nothing scrubbed yet."; exit 0 }
        $m = Load-Map -Path $Map
        Write-Output "Map: $Map"
        Write-Output "Entries: $(($m.entries.PSObject.Properties | Measure-Object).Count)"
        Write-Output ""
        Write-Output ("{0,-35} {1,-14} {2}" -f 'Placeholder','Type','Real value')
        Write-Output ('-' * 80)
        $rows = $m.entries.PSObject.Properties | Sort-Object { $_.Value.placeholder }
        foreach ($p in $rows) {
            $display = if ($p.Name.Length -le 30) { $p.Name } else { $p.Name.Substring(0,27) + '...' }
            Write-Output ("{0,-35} {1,-14} {2}" -f $p.Value.placeholder, $p.Value.type, $display)
        }
    }
    'reset' {
        if (Test-Path $Map) { Remove-Item $Map; Write-Output "Removed $Map" }
        else { Write-Output "No map at $Map -- already clean." }
    }
    default {
        [Console]::Error.WriteLine("unknown subcommand: $Command"); exit 1
    }
}
