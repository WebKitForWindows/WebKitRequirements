<#
  .Synopsis
  Deletes pthread headers.
  .Details
  Removes pthread headers from the distribution.
  .Parameter Triplet
  The vcpkg triplet to use. Defaults to 'x64-windows'
#>

Param(
  [Parameter()]
  [string] $triplet = 'x64-windows-webkit'
)

Remove-Item -Path ('installed/{0}/include/pthread.h' -f $triplet);
Remove-Item -Path ('installed/{0}/include/sched.h' -f $triplet);
Remove-Item -Path ('installed/{0}/include/semaphore.h' -f $triplet);
