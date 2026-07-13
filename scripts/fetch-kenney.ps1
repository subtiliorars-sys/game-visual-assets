# Fetch additional Kenney CC0 packs into vendor/kenney/<slug>/
# Usage: pwsh scripts/fetch-kenney.ps1 -Slug pixel-ui-pack
# Discovers zip URL from the Kenney asset page HTML.

param(
  [Parameter(Mandatory = $true)][string]$Slug,
  [string]$Kind = 'visual' # visual | audio — chooses which repo root this script lives in
)

$ErrorActionPreference = 'Stop'
$page = "https://kenney.nl/assets/$Slug"
Write-Host "Resolving $page ..."
$html = (Invoke-WebRequest -Uri $page -UseBasicParsing -Headers @{ 'User-Agent' = 'Mozilla/5.0 asset-lib' }).Content
$m = [regex]::Match($html, 'https://kenney\.nl/media/pages/assets/[^\"\s<>]+\.zip')
if (-not $m.Success) { throw "No zip URL found for $Slug" }
$url = $m.Value.TrimEnd("'")
Write-Host "ZIP $url"
$root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
# when script lives in repo: scripts/ -> repo root
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$dest = Join-Path $repoRoot "vendor\kenney\$Slug"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
$zip = Join-Path $env:TEMP "kenney-$Slug.zip"
Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing -Headers @{ 'User-Agent' = 'Mozilla/5.0 asset-lib' }
Expand-Archive -Path $zip -DestinationPath $dest -Force
Write-Host "Extracted to $dest — update ATTRIBUTION.md before commit."
