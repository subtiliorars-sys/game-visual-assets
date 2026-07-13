# Fetch Poly Haven CC0 textures (1k JPG maps) into vendor/polyhaven/
# License: CC0 — https://polyhaven.com/license
param(
  [int]$Count = 25,
  [string]$Repo = 'C:\Users\hrmread\work\game-visual-assets'
)

$ErrorActionPreference = 'Stop'
$ua = @{ 'User-Agent' = 'Mozilla/5.0 JimmyTheHat-asset-lib/1.0 (CC0 mirror)' }
$root = Join-Path $Repo 'vendor\polyhaven'
New-Item -ItemType Directory -Force -Path $root | Out-Null

$assets = Invoke-RestMethod -Uri 'https://api.polyhaven.com/assets?t=textures' -Headers $ua
# Prefer higher download_count
$ranked = $assets.PSObject.Properties | ForEach-Object {
  [pscustomobject]@{
    Id = $_.Name
    Downloads = [int]($_.Value.download_count)
    Categories = @($_.Value.categories)
  }
} | Sort-Object Downloads -Descending

# Prioritize useful game categories
$wantedCats = @('outdoor','indoor','terrain','nature','floor','wall','metal','wood','rock','brick','concrete','street','gravel','sand','grass','dirt')
$picked = [System.Collections.Generic.List[string]]::new()
foreach ($row in $ranked) {
  $hit = $false
  foreach ($c in $row.Categories) { if ($wantedCats -contains $c) { $hit = $true; break } }
  if (-not $hit -and $picked.Count -gt 10) { continue }
  if ($picked.Contains($row.Id)) { continue }
  $picked.Add($row.Id) | Out-Null
  if ($picked.Count -ge $Count) { break }
}

Write-Host "Picked $($picked.Count) Poly Haven textures"
$mapKinds = @('Diffuse','nor_gl','Rough','AO','Displacement')
$ledger = @()
foreach ($id in $picked) {
  $folder = Join-Path $root $id
  if ((Test-Path $folder) -and (Get-ChildItem $folder -File -EA SilentlyContinue).Count -ge 2) {
    Write-Host "SKIP $id"; $ledger += [pscustomobject]@{Id=$id;Status='SKIP'}; continue
  }
  try {
    New-Item -ItemType Directory -Force -Path $folder | Out-Null
    $files = Invoke-RestMethod -Uri "https://api.polyhaven.com/files/$id" -Headers $ua
    $got = 0
    foreach ($kind in $mapKinds) {
      $node = $files.$kind
      if (-not $node) { continue }
      $jpg = $null
      if ($node.'1k' -and $node.'1k'.jpg) { $jpg = $node.'1k'.jpg.url }
      elseif ($node.'1k' -and $node.'1k'.png) { $jpg = $node.'1k'.png.url }
      if (-not $jpg) { continue }
      $ext = [IO.Path]::GetExtension(([Uri]$jpg).AbsolutePath)
      $out = Join-Path $folder ("{0}_{1}_1k{2}" -f $id, ($kind.ToLower()), $ext)
      Write-Host "  $id $kind"
      Invoke-WebRequest -Uri $jpg -OutFile $out -UseBasicParsing -Headers $ua
      $got++
    }
    if ($got -eq 0) { throw 'no maps downloaded' }
    $ledger += [pscustomobject]@{ Id=$id; Status='OK'; Maps=$got; Url="https://polyhaven.com/a/$id" }
  } catch {
    Write-Host "FAIL $id $($_.Exception.Message)"
    $ledger += [pscustomobject]@{ Id=$id; Status='FAIL'; Error=$_.Exception.Message }
  }
}
$ledger | Format-Table -AutoSize
$ledger | Export-Csv C:\Users\hrmread\work\_asset-dl-polyhaven.csv -NoTypeInformation
Write-Host "DONE $(($ledger|? Status -eq 'OK').Count) ok"
