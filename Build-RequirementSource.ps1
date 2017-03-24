<#
  .Synopsis
  Builds all the source code for required for building WebKit.
  
  .Details
  Invokes the CMake build for all the required projects.
  
  .Parameter Root
  The root directory to download source to. Defaults to current directory.
  
  .Parameter InstallPath
  The directory to install the built files to.
  
  .Parameter BuildType
  The type of build to run.
  
  .Parameter Platform
  The build platform corresponding to CMAKE_SYSTEM_NAME.
#>

Param(
  [string] $root = '.',
  [string] $installPath = 'dist',
  [ValidateSet('Release','Debug')]
  [string] $buildType = 'Release',
  [string] $platform = 'Windows'
)

#----------------------------------------------------------------------
# Build function
#----------------------------------------------------------------------

Function Build-Requirement {
  Param(
    [Parameter(Mandatory)]
    [string] $name,
    [Parameter]
    [string[]] $options
  )
  
  $sourcePath = Join-Path $root $name;
  
  if (!(Test-Path $sourcePath)) {
    Write-Host ('Source code for {0} not present at {1}' -f $name, $destinationPath);
    return;
  }
  
  Invoke-CMakeBuild -Path $sourcePath -BuildType $buildType -InstallPath $installPath -Platform $platform;
}

#----------------------------------------------------------------------
# Build all
#
# Ordered based on dependencies
#----------------------------------------------------------------------

if (!(Test-Path $root)) {
  
  Write-Host ('Creating root directory at {0}' -f $root);
  New-Item $root -Type directory;
}

Write-Host ('Building source code in {0}' -f $root);

Build-Requirement -Name 'zlib';
Build-Requirement -Name 'libressl';
Build-Requirement -Name 'nghttp2';
Build-Requirement -Name 'curl';
Build-Requirement -Name 'libpng';
Build-Requirement -Name 'libjpeg-turbo';
Build-Requirement -Name 'libwebp';
