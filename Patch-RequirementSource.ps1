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
  
  $items = Get-ChildItem $sourcePath -Recurse;
  
  Write-Host ('Copying files from {0} to {1}' -f $sourcePath, $destinationPath)
  
  foreach ($item in $items) {
    $itemName = $item.FullName;
    $relativePath = $itemName.Substring($substringLength);
    $target = Join-Path $destinationPath $relativePath;

    if (!($item -is [System.IO.DirectoryInfo])) {
      Write-Host ('Copying {0}' -f $relativePath);
      Copy-Item $itemName -Destination $target;
    } elseif (!(Test-Path $target)) {
      Write-Host ('Creating directory {0}' -f $relativePath);
      New-Item $target -Type Directory
    }
  }
}

#----------------------------------------------------------------------
# Patch all
#----------------------------------------------------------------------

$root = (Resolve-Path -Path $root).Path;
$patchPath = (Resolve-Path -Path $patchPath).Path;

Patch-Requirement -Name 'libwebp';
Patch-Requirement -Name 'sqlite';
Patch-Requirement -Name 'libxml2';
Patch-Requirement -Name 'libxslt';
Patch-Requirement -Name 'pixman';
Patch-Requirement -Name 'cairo';
Patch-Requirement -Name 'icu';
