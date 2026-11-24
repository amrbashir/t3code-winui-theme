# Builds winui.json from src/theme.json and src/theme.css.
$ErrorActionPreference = 'Stop'

function Read-Source([string] $Name) {
    $path = Join-Path (Join-Path $PSScriptRoot 'src') $Name
    [IO.File]::ReadAllText($path).Replace("`r", '').TrimEnd("`n")
}

# theme.json without its closing brace, ready for one more property
$theme = (Read-Source 'theme.json') -replace '\n\}$', ','
$css = (Read-Source 'theme.css') + "`n"
$css = $css.Replace('\', '\\').Replace('"', '\"').Replace("`t", '\t').Replace("`n", '\n')

$json = $theme + "`n" + '  "css": "' + $css + '"' + "`n}`n"
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'winui.json'), $json, (New-Object Text.UTF8Encoding $false))

Write-Host 'Built winui.json'
