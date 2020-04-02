<#
  .Synopsis
  Deletes 'share' directory
  .Details
  Removes 'share' directory from the distribution.
  .Parameter Triplet
  The vcpkg triplet to use.
#>

param(
  [Parameter()]
  [string]$triplet
)

$ErrorActionPreference = 'Stop';

Remove-Item -Path (Join-Path $PSScriptRoot "installed\${triplet}\share") -Recurse
