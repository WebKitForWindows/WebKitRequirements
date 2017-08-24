<#
  .Synopsis
  Packages a release of the binaries of the libraries meeting the requirements of building WebKit.

  .Details
  Cleans up any unused files in
  Downloads source code releases and stages them within the directory
  structure. From there they can be built out.

  .Parameter Root
  The root directory to package the sources at. Defaults to current directory.

  .Parameter Suffix
  The suffix to apply to the bin and lib directories
#>

Param(
  [string] $output = 'WinCairoRequirements.zip',
  [string] $root = '.',
  [string] $suffix = '64'
)

$binDirectory = Join-Path $root 'bin'
$libDirectory = Join-Path $root 'lib'
$docDirectory = Join-Path $root 'doc'
$shareDirectory = Join-Path $root 'share'

#----------------------------------------------------------------------
# Clean directory
#----------------------------------------------------------------------

Function Clean-Directory {
  Param(
    [Parameter(Mandatory)]
    [string] $name,
    [Parameter(Mandatory)]
    [string] $extension
  )

  $directory = Join-Path $root $name;

  Write-Host ('Cleaning {0} of any files that are not {1}s' -f $directory, $extension)

  $files = Get-ChildItem -Path $directory

  ForEach ($file in $files) {
    if ($extension -ne $file.Extension) {
      Write-Host ('Removing {0}' -f $file.FullName)
      Remove-Item -Path $file.FullName -Recurse
    }
  }
}

#----------------------------------------------------------------------
# Remove unused directories
#----------------------------------------------------------------------

if (Test-Path $docDirectory) {
  Write-Host ('Removing doc directory at {0}' -f $docDirectory)
  Remove-Item -Path $docDirectory -Recurse
}

if (Test-Path $shareDirectory) {
  Write-Host ('Removing share directory at {0}' -f $shareDirectory)
  Remove-Item -Path $shareDirectory -Recurse
}

#----------------------------------------------------------------------
# Move dll files into bin
#
# Some libraries output dll into lib instead of bin
#----------------------------------------------------------------------

# Move any dlls into bin
Write-Host ('Moving dlls in {0}' -f $libDirectory)
$dlls = Get-ChildItem -Path $libDirectory -Filter '*.dll'

ForEach ($dll in $dlls) {
  Write-Host ('Move {0} into bin directory' -f $dll.Name)
  Move-Item $dll.FullName (Join-Path $binDirectory $dll.Name)
}

#----------------------------------------------------------------------
# Clean directories
#----------------------------------------------------------------------

Clean-Directory -Name 'bin' -Extension '.dll'
Clean-Directory -Name 'lib' -Extension '.lib'

#----------------------------------------------------------------------
# Rename the bin and lib directories to include the bits
#----------------------------------------------------------------------

$binRename = ('bin{0}' -f $suffix)
Write-Host ('Renaming {0} to {1}' -f $binDirectory, $binRename)
Rename-Item $binDirectory $binRename

$libRename = ('lib{0}' -f $suffix)
Write-Host ('Renaming {0} to {1}' -f $libDirectory, $libRename)
Rename-Item $libDirectory $libRename

#----------------------------------------------------------------------
# Zip files
#----------------------------------------------------------------------

Write-Host ('Creating archive at {0}' -f $output)
Compress-7Zip -ArchiveFileName $output -Path $root
