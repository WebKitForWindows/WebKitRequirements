<#
  .Synopsis
  Packages the requirements into a zip file.
  .Parameter Triplet
  The vcpkg triplet to use. Defaults to 'x64-windows-webkit'
  .Parameter Output
  The filename to output to. Defaults to 'WinCairoRequirements.zip'.
#>

param(
  [Parameter(Mandatory)]
  [string]$triplet,
  [Parameter()]
  [string]$output
)

$ErrorActionPreference = 'Stop';

if (!$ouput) {
  $tripletSplit = $triplet -split '-',3;
  $arch = $tripletSplit[0];
  $platform = $tripletSplit[1];
  $linkage = $tripletSplit[2];

  if ($platform -eq 'windows') {
    if ($arch -eq 'x64') {
      $suffix = 'Win64';
    } else {
      $suffix = 'Win32';
    }
  } else {

  }

  $output = ('WebKitRequirements{0}.zip' -f $suffix);
}

Write-Host ('Creating archive {0}' -f $output)
Compress-7Zip -ArchiveFileName $output -Path ('{0}/installed/{1}' -f $PSScriptRoot,$triplet)
