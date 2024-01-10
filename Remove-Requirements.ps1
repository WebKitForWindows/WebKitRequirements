<#
  .Synopsis
  Removes all the source code required for building WebKit.
  .Details
  Invokes vcpkg remove to clean all the libraries.
  .Parameter Triplet
  The vcpkg triplet to use.
  .Parameter Libraries
  Path to a JSON file containing the list of libraries.

  If the value is not provided then the script will guess at the value based on
  the triplet.
#>

param(
  [Parameter(Mandatory)]
  [string]$triplet,
  [Parameter()]
  [string]$libraries = ''
)

$ErrorActionPreference = 'Stop';

if (!$libraries) {
  $tripletSplit = $triplet -split '-',3;
  $platform = $tripletSplit[1];

  if ($platform -eq 'windows') {
    $jsonName = 'WindowsRequirements.json';
  } else {
    Write-Error ('Unknown triplet {0}' -f $libraries);
  }

  $libraries = Join-Path $PSScriptRoot $jsonName;
}

$json = Get-Content -Raw -Path $libraries | ConvertFrom-Json

$arguments = @('remove')
foreach ($value in $json) {
  $arguments += ($value -split '\[')[0];
}
$arguments += '--triplet'
$arguments += $triplet

Write-Host ('vcpkg {0}' -f ($arguments -join ' '))

Start-Process -Wait -NoNewWindow `
  -FilePath (Join-Path $PSScriptRoot 'vcpkg.exe') `
  -WorkingDirectory $PSScriptRoot `
  -ArgumentList $arguments
