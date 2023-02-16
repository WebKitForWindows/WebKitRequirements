<#
  .Synopsis
  Deletes pthread headers.
  .Details
  Removes pthread headers from the distribution.
  .Parameter Triplet
  The vcpkg triplet to use.
#>

param(
  [Parameter()]
  [string]$triplet
)

$ErrorActionPreference = 'Stop';

$tripletSplit = $triplet -split '-',3;
$platform = $tripletSplit[1];

if ($platform -ne 'windows') {
  Write-Error ('Script is only for Windows triplets, not {0}' -f $triplet);
}

Remove-Item -Path ('{0}/installed/{1}/include/pthread.h' -f $PSScriptRoot,$triplet);
Remove-Item -Path ('{0}/installed/{1}/include/sched.h' -f $PSScriptRoot,$triplet);
Remove-Item -Path ('{0}/installed/{1}/include/semaphore.h' -f $PSScriptRoot,$triplet);
