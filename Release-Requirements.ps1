<#
  .Synopsis
  Creates a WebKitRequirements release.
  .Details
  Calls the individual scripts for preparing a release.
  .Parameter Triplet
  The vcpkg triplet to use.
#>

param(
  [Parameter(Mandatory)]
  [string]$triplet
)

$ErrorActionPreference = 'Stop';

$tripletSplit = $triplet -split '-',3;
$platform = $tripletSplit[1];

if ($platform -eq 'windows') {
  $command = ('Rename-WithBitSuffix.ps1 -triplet {0}' -f $triplet);
  Write-Host $command;
  Invoke-Expression -Command ('{0}/{1}' -f $PSScriptRoot,$command);
} else {
  Write-Error ('Unknown triplet {0}' -f $triplet);
  return;
}

$command = ('Delete-ShareDirectory.ps1 -triplet {0}' -f $triplet)
Write-Host $command;
Invoke-Expression -Command ('{0}/{1}' -f $PSScriptRoot,$command);

$command = ('Package-Requirements.ps1 -triplet {0}' -f $triplet);
Write-Host $command;
Invoke-Expression -Command ('{0}/{1}' -f $PSScriptRoot,$command);
