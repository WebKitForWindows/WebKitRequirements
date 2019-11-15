<#
  .Synopsis
  Renames the bin and lib directory to include bits.
  .Details
  Renames 64-bit builds to be bin64/lib64 and 32-bit builds to be bin32/lib64.
  .Parameter Triplet
  The vcpkg triplet to use.
#>

param(
  [Parameter(Mandatory)]
  [string]$triplet
)

$ErrorActionPreference = 'Stop';

$tripletSplit = $triplet -split '-',3;
$arch = $tripletSplit[0];
$platform = $tripletSplit[1];

if ($platform -ne 'windows') {
  Write-Error ('Script is only for Windows triplets, not {0}' -f $triplet);
}

if ($arch -eq 'x64') {
  $suffix = '64';
} else {
  $suffix = '32';
}

Rename-Item -Path ('{0}/installed/{1}/bin' -f $PSScriptRoot,$triplet) -NewName ('bin{0}' -f $suffix);
Rename-Item -Path ('{0}/installed/{1}/lib' -f $PSScriptRoot,$triplet) -NewName ('lib{0}' -f $suffix);

Rename-Item -Path ('{0}/installed/{1}/debug/bin' -f $PSScriptRoot,$triplet) -NewName ('bin{0}' -f $suffix);
Rename-Item -Path ('{0}/installed/{1}/debug/lib' -f $PSScriptRoot,$triplet) -NewName ('lib{0}' -f $suffix);
