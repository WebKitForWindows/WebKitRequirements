<#
  .Synopsis
  Deletes pthread headers.
  .Details
  Removes pthread headers from the distribution.
  .Parameter Triplet
  The vcpkg triplet to use. Defaults to 'x64-windows-webkit'
#>

Param(
  [Parameter()]
  [string] $triplet = 'x64-windows-webkit'
)

Remove-Item -Path ('{0}/installed/{1}/include/pthread.h' -f $PSScriptRoot, $triplet);
Remove-Item -Path ('{0}/installed/{1}/include/sched.h' -f $PSScriptRoot, $triplet);
Remove-Item -Path ('{0}/installed/{1}/include/semaphore.h' -f $PSScriptRoot, $triplet);
