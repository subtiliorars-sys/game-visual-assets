# Bulk-fetch Kenney CC0 packs. Verifies zip URL from each asset page.
# Usage: pwsh bulk-fetch-kenney.ps1 -Lib visual|audio|3d -Slugs slug1,slug2,...

param(
  [Parameter(Mandatory)][ValidateSet('visual','audio','3d')][string]$Lib,
  [Parameter(Mandatory)][string]$SlugsCsv
)
$Slugs = $SlugsCsv -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }

$ErrorActionPreference = 'Stop'
$map = @{
  visual = 'C:\Users\hrmread\work\game-visual-assets'
  audio  = 'C:\Users\hrmread\work\game-audio-assets'
  '3d'   = 'C:\Users\hrmread\work\game-3d-assets'
}
$repo = $map[$Lib]
$dl = "C:\Users\hrmread\work\_asset-dl-$Lib"
New-Item -ItemType Directory -Force -Path $dl | Out-Null
Add-Type -AssemblyName System.IO.Compression.FileSystem

$results = @()
foreach ($Slug in $Slugs) {
  $dest = Join-Path $repo "vendor\kenney\$Slug"
  if (Test-Path $dest) {
    $n = (Get-ChildItem $dest -Recurse -File -ErrorAction SilentlyContinue | Measure-Object).Count
    if ($n -gt 5) {
      Write-Host "SKIP $Slug (already vendored, $n files)"
      $results += [pscustomobject]@{ Slug=$Slug; Status='SKIP'; Count=$n }
      continue
    }
  }
  try {
    Write-Host "RESOLVE $Slug ..."
    $page = "https://kenney.nl/assets/$Slug"
    $html = (Invoke-WebRequest -Uri $page -UseBasicParsing -Headers @{ 'User-Agent'='Mozilla/5.0 asset-lib' }).Content
    $m = [regex]::Match($html, 'https://kenney\.nl/media/pages/assets/[^\"\s<>]+\.zip')
    if (-not $m.Success) { throw "No zip URL on page" }
    $url = $m.Value.TrimEnd("'")
    $zip = Join-Path $dl "$Slug.zip"
    Write-Host "  DL $url"
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing -Headers @{ 'User-Agent'='Mozilla/5.0 asset-lib' }
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $dest)
    $count = (Get-ChildItem $dest -Recurse -File | Measure-Object).Count
    $mb = [math]::Round((Get-Item $zip).Length / 1MB, 2)
    Write-Host "  OK $count files ($mb MB)"
    $results += [pscustomobject]@{ Slug=$Slug; Status='OK'; Count=$count; MB=$mb; Url=$url }
  } catch {
    Write-Host "  FAIL $Slug : $($_.Exception.Message)"
    $results += [pscustomobject]@{ Slug=$Slug; Status='FAIL'; Count=0; Error=$_.Exception.Message }
  }
}
$results | Format-Table -AutoSize
$results | Export-Csv (Join-Path $dl 'fetch-results.csv') -NoTypeInformation
$results
