<#
  .Synopsis
  Renames the bin and lib directory to include bits.
  .Details
  Renames 64-bit builds to be bin64/lib64 and 32-bit builds to be bin32/lib64.
  .Parameter Triplet
  The vcpkg triplet to use. Defaults to 'x64-windows'
#>

Param(
  [Parameter()]
  [string] $triplet = 'x64-windows-webkit'
)

if ($triplet.StartsWith('x64')) {
  $suffix = '64';
} else {
  $suffix = '32';
}

Rename-Item -Path ('installed/{0}/bin' -f $triplet) -NewName ('bin{0}' -f $suffix);
Rename-Item -Path ('installed/{0}/lib' -f $triplet) -NewName ('lib{0}' -f $suffix);
