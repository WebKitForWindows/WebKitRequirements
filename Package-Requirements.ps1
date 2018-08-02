<#
  .Synopsis
  Packages the requirements into a zip file.
  .Parameter Triplet
  The vcpkg triplet to use. Defaults to 'x64-windows-webkit'
  .Parameter Output
  The filename to output to. Defaults to 'WinCairoRequirements.zip'.
#>

Param(
  [Parameter()]
  [string] $triplet = 'x64-windows-webkit',
  [Parameter()]
  [string] $output = 'WinCairoRequirements.zip'
)

Write-Host ('Creating archive {0}' -f $output)
Compress-7Zip -ArchiveFileName $output -Path ('installed/{0}' -f $triplet)
