# Fetch popular ambientCG CC0 PBR materials (1K-JPG) into vendor/ambientcg/
# License: CC0 1.0 Universal — https://ambientcg.com/license
param(
  [int]$Count = 40,
  [string]$Repo = 'C:\Users\hrmread\work\game-visual-assets',
  [string]$Resolution = '1K-JPG'
)

$ErrorActionPreference = 'Stop'
$ua = @{ 'User-Agent' = 'Mozilla/5.0 JimmyTheHat-asset-lib/1.0 (CC0 mirror; commercial OK)' }
$destRoot = Join-Path $repo 'vendor\ambientcg'
$dl = 'C:\Users\hrmread\work\_asset-dl-ambientcg'
New-Item -ItemType Directory -Force -Path $destRoot, $dl | Out-Null
Add-Type -AssemblyName System.IO.Compression.FileSystem

# Curated category keywords to cover game needs (popular within each)
$queries = @(
  @{ q = 'wood'; n = 5 },
  @{ q = 'stone'; n = 5 },
  @{ q = 'brick'; n = 4 },
  @{ q = 'concrete'; n = 4 },
  @{ q = 'dirt'; n = 3 },
  @{ q = 'grass'; n = 3 },
  @{ q = 'sand'; n = 3 },
  @{ q = 'metal'; n = 4 },
  @{ q = 'roof'; n = 2 },
  @{ q = 'tile'; n = 4 },
  @{ q = 'rock'; n = 3 }
)

$picked = [System.Collections.Generic.List[string]]::new()
foreach ($query in $queries) {
  $api = "https://ambientCG.com/api/v3/assets?type=material&q=$($query.q)&sort=popular&limit=$($query.n)&include=downloads,title"
  Write-Host "QUERY $($query.q) ..."
  $page = Invoke-RestMethod -Uri $api -Headers $ua
  foreach ($a in $page.assets) {
    if ($picked.Contains($a.id)) { continue }
    $picked.Add($a.id) | Out-Null
    if ($picked.Count -ge $Count) { break }
  }
  if ($picked.Count -ge $Count) { break }
}

# Also top overall popular
if ($picked.Count -lt $Count) {
  $api = "https://ambientCG.com/api/v3/assets?type=material&sort=popular&limit=$Count&include=downloads,title"
  $page = Invoke-RestMethod -Uri $api -Headers $ua
  foreach ($a in $page.assets) {
    if ($picked.Contains($a.id)) { continue }
    $picked.Add($a.id) | Out-Null
    if ($picked.Count -ge $Count) { break }
  }
}

Write-Host "Selected $($picked.Count) materials"
$ledger = @()
foreach ($id in $picked) {
  $folder = Join-Path $destRoot $id
  if ((Test-Path $folder) -and (Get-ChildItem $folder -Recurse -File -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
    Write-Host "SKIP $id"
    $ledger += [pscustomobject]@{ Id=$id; Status='SKIP' }
    continue
  }
  try {
    $meta = Invoke-RestMethod -Uri "https://ambientCG.com/api/v3/assets?id=$id&include=downloads,title" -Headers $ua
    $asset = $meta.assets[0]
    $dlInfo = $asset.downloads | Where-Object { $_.attributes -eq $Resolution } | Select-Object -First 1
    if (-not $dlInfo) { $dlInfo = $asset.downloads | Where-Object { $_.attributes -like '1K*' } | Select-Object -First 1 }
    if (-not $dlInfo) { throw "No 1K download for $id" }
    $zip = Join-Path $dl "$id.zip"
    Write-Host "DL $id ($([math]::Round($dlInfo.size/1MB,2)) MB) ..."
    Invoke-WebRequest -Uri $dlInfo.url -OutFile $zip -UseBasicParsing -Headers $ua
    if (Test-Path $folder) { Remove-Item -Recurse -Force $folder }
    New-Item -ItemType Directory -Force -Path $folder | Out-Null
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $folder)
    $n = (Get-ChildItem $folder -Recurse -File).Count
    $ledger += [pscustomobject]@{ Id=$id; Status='OK'; Files=$n; Title=$asset.title; Url="https://ambientcg.com/a/$id" }
    Write-Host "  OK $n files"
  } catch {
    Write-Host "  FAIL $id : $($_.Exception.Message)"
    $ledger += [pscustomobject]@{ Id=$id; Status='FAIL'; Error=$_.Exception.Message }
  }
}

$ledger | Format-Table -AutoSize
$ledger | Export-Csv (Join-Path $dl 'ledger.csv') -NoTypeInformation
$ok = ($ledger | Where-Object Status -eq 'OK').Count
Write-Host "DONE ok=$ok / $($ledger.Count)"
