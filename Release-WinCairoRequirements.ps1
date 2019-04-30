<#
  .Synopsis
  Creates a WinCairoRequirements release.
  .Details
  Calls the individual scripts for preparing a release.
  .Parameter Triplet
  The vcpkg triplet to use. Defaults to 'x64-windows-webkit'
#>

Param(
  [Parameter()]
  [string] $triplet = 'x64-windows-webkit'
)

$ErrorActionPreference = 'Stop';

$command = ('Delete-PthreadHeaders.ps1 -triplet {0}' -f $triplet)
Write-Host $command;
Invoke-Expression -Command ('{0}/{1}' -f $PSScriptRoot, $command);

$command = ('Rename-WithBitSuffix.ps1 -triplet {0}' -f $triplet);
Write-Host $command;
Invoke-Expression -Command ('{0}/{1}' -f $PSScriptRoot, $command);

if ($triplet.StartsWith('x64')) {
  $suffix = '';
} else {
  $suffix = '32';
}

$command = ('Package-Requirements.ps1 -triplet {0} -Output WinCairoRequirements{1}.zip' -f $triplet, $suffix);
Write-Host $command;
Invoke-Expression -Command ('{0}/{1}' -f $PSScriptRoot, $command);
