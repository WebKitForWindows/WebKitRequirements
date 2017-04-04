<#
  .Synopsis
  Patches the source code so it can build successfully.
  
  .Details
  The patching process will make any changes necessary to the build
  system to get things working.
  
  .Parameter Root
  The root directory of the source code. Defaults to current directory.
#>

Param(
  [string] $root = '.',
  [string] $patchPath = 'patches'
)

#----------------------------------------------------------------------
# Patch function
#----------------------------------------------------------------------

Function Patch-Requirement {
  Param(
    [Parameter(Mandatory)]
    [string] $name
  )
  
  $sourcePath = Join-Path $patchPath $name;
  $substringLength = $sourcePath.Length + 1;
  $destinationPath = Join-Path $root $name;
  
  $files = Get-ChildItem $sourcePath -Recurse -File;
  
  Write-Host ('Copying files from {0} to {1}' -f $sourcePath, $destinationPath)
  
  foreach ($file in $files) {
    $fileName = $file.FullName;
    $relativePath = $fileName.Substring($substringLength);
    $targetFile = Join-Path $destinationPath $relativePath;

    Write-Host ('Copying {0}' -f $relativePath);

    Copy-Item $fileName -Destination $targetFile;
  }
}

#----------------------------------------------------------------------
# Patch all
#----------------------------------------------------------------------

$root = (Resolve-Path -Path $root).Path;
$patchPath = (Resolve-Path -Path $patchPath).Path;

Patch-Requirement -Name 'libwebp';
Patch-Requirement -Name 'sqlite';
