
Param (
  # Common options
  [Parameter()]
  [string] $sourcePath = 'src',
  [Parameter()]
  [string] $buildPath = 'build',
  [Parameter()]
  [string] $installationPath = 'dist',

  # Build-RequirementSource options
  [Parameter()]
  [ValidateSet('Release','Debug')]
  [string] $buildType = 'Release',
  [Parameter()]
  [ValidateSet('ninja','vs2015','vs2017')]
  [string] $generator = 'ninja',
  [Parameter()]
  [string] $platform = 'Windows'
)

#----------------------------------------------------------------------
# Get
#----------------------------------------------------------------------

# TODO: Remove CFLite https://github.com/WebKitForWindows/WinCairoRequirements/issues/9
& (Join-Path $PSScriptRoot Get-CFLite) -Root $installationPath;
& (Join-Path $PSScriptRoot Get-RequirementSource.ps1) -Root $sourcePath;

#----------------------------------------------------------------------
# Patch
#----------------------------------------------------------------------

& (Join-Path $PSScriptRoot Patch-RequirementSource.ps1) -Root $sourcePath;

#----------------------------------------------------------------------
# Build
#----------------------------------------------------------------------

$args = @{
  Root = $sourcePath;
  InstallPath = $installationPath;
  BuildPath = $buildPath;
  BuildType = $buildType;
  Generator = $generator;
  Platform = $platform;
}

& (Join-Path $PSScriptRoot Build-RequirementSource) @args

#----------------------------------------------------------------------
# Package
#----------------------------------------------------------------------

& (Join-Path $PSScriptRoot Package-RequirementSource.ps1) -Root $installationPath;
