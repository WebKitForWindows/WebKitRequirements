<#
  .Synopsis
  Builds vcpkg and installs its sources within the repository.
  .Details
  Invokes the build script for vcpkg then copies the executable and the scripts
  used into requirements repository.  
  .Parameter VcpkgPath
  Path to the directory containing the vcpkg source code.
  .Parameter Clone
  Repository to clone vpckg from, defaults to GitHub's microsoft/vcpkg.

  Ignored when a checkout is already present at `VcpkgPath`.
  .Parameter Build
  Whether to build the vcpkg.exe, defaults to `true`.
  .Parameter Update
  Whether to update the checkout of vcpkg.
#>

param(
  [Parameter(Mandatory)]
  [string]$vcpkgPath,
  [Parameter()]
  [string]$clone,
  [Parameter()]
  [switch]$build=[switch]::Present,
  [Parameter()]
  [switch]$update
)

$ErrorActionPreference = 'Stop';

# Save off current location
$currentPath = Get-Location;

# Clone the repository if necessary
if (!(Test-Path $vcpkgPath)) {
  Write-Host ('Repository not found at {0}' -f $vcpkgPath);

  if ($null -eq (Get-Command "git.exe" -ErrorAction SilentlyContinue)) {
    Write-Error 'Unable to clone repository; git not present in path';
    return;
  }

  if (!$clone) {
    $clone = 'https://github.com/microsoft/vcpkg.git';
  }
  $arguments = @('clone',$clone,$vcpkgPath);
  Write-Host ('git {0}' -f ($arguments -join ' '))
  Start-Process -Wait -NoNewWindow `
     -FilePath 'git' `
     -WorkingDirectory $currentPath `
     -ArgumentList $arguments
}

Set-Location $vcpkgPath;

# Update the repository if necessary
if ($update) {
  Write-Host ('Updating repository at {0}' -f $vcpkgPath)

  $arguments = @('pull');
  Write-Host ('git {0}' -f ($arguments -join ' '));
  Start-Process -Wait -NoNewWindow `
     -FilePath 'git' `
     -WorkingDirectory $vcpkgPath `
     -ArgumentList $arguments
}

# Build the repository
if ($build) {
  Invoke-Expression -Command ./scripts/bootstrap.ps1;
}

# Copy files and folders into directory
function Copy-DirectoryStructure {
  param(
    [Parameter(Mandatory)]
    [string]$path,
    [Parameter(Mandatory)]
    [string]$destination
  )

  Write-Host ('Copying directory from {0} to {1}' -f $path,$destination)

  # See if directory needs to be created
  if (!(Test-Path $destination)) {
    New-Item -ItemType Directory -Path $destination -Force | Out-Null;
  }

  # Iterate through directories
  $directories = Get-ChildItem $path -Dir;

  foreach ($dir in $directories) {
    $fromPath = Join-Path $path $dir.Name;
    $toPath = Join-Path $destination $dir.Name;

    Copy-DirectoryStructure -Path $fromPath -Destination $toPath;
  }

  # Iterate through files
  $files = Get-ChildItem $path -File;

  foreach ($file in $files) {
    Copy-Item -Path $file.FullName -Destination $destination;
    Write-Debug ('Copied {0}' -f $file.FullName)
  }
}

Copy-Item 'vcpkg.exe' -Force -Destination $PSScriptRoot;
Copy-Item '.vcpkg-root' -Force -Destination $PSScriptRoot;
Copy-DirectoryStructure `
   -Path (Join-Path $vcpkgPath 'scripts') `
   -Destination (Join-Path $PSScriptRoot 'scripts');
Copy-DirectoryStructure `
   -Path (Join-Path $vcpkgPath -ChildPath 'triplets') `
   -Destination (Join-Path $PSScriptRoot -ChildPath 'triplets');

# Restore location
Set-Location $currentPath;
