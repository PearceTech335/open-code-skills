param([Parameter(Mandatory = $true)][string]$Path)

# Pre-publish README check: heading hierarchy, image alt text, local link targets.
$issues = @()
$prevLevel = 0
$lineNo = 0
foreach ($line in Get-Content -Path $Path) {
    $lineNo++
    if ($line -match '^(#{1,6})\s+\S') {
        $level = $Matches[1].Length
        if ($prevLevel -gt 0 -and $level -gt $prevLevel + 1) {
            $issues += "line ${lineNo}: heading jumps H$prevLevel -> H$level (skipped level)"
        }
        $prevLevel = $level
    }
}

$raw = Get-Content -Path $Path -Raw
$baseDir = Split-Path -Path $Path -Parent

foreach ($m in [regex]::Matches($raw, '!\[([^\]]*)\]\(([^)\s]+)\)')) {
    if ([string]::IsNullOrWhiteSpace($m.Groups[1].Value)) {
        $issues += "image missing alt text: $($m.Groups[2].Value)"
    }
}

foreach ($m in [regex]::Matches($raw, '(?<!!)\[[^\]]*\]\(([^)\s]+)\)')) {
    $target = $m.Groups[1].Value
    if ($target -match '^(https?://|mailto:|#)') { continue }
    $filePart = ($target -split '#')[0]
    if ([string]::IsNullOrWhiteSpace($filePart)) { continue }
    $resolved = if ([System.IO.Path]::IsPathRooted($filePart)) { $filePart } else { Join-Path $baseDir $filePart }
    if (-not (Test-Path -Path $resolved)) {
        $issues += "broken local link: $target"
    }
}

if ($issues.Count -gt 0) {
    $issues | ForEach-Object { "FAIL: $_" }
    exit 1
}
"PASS: heading hierarchy, alt text, and local links OK"
exit 0
