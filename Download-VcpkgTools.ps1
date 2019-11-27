<#
  .Synopsis
  Downloads tools required by vcpkg.
  .Details
  At this time the `vcpkg` executable uses the system proxy settings, not the
  values contained in the proxy environment variables. This script is a 
  workaround until that is resolved
  .Parameter ToolsPath
  The XML file containing the tool listing.
#>

param(
  [Parameter(Mandatory)]
  [string]$toolsPath
)

$ErrorActionPreference = 'Stop';

$downloads = @(
  'powershell-core',
  '7zip'
);

[xml]$document = Get-Content $toolsPath;
$tools = $document.SelectNodes('//tool');

Write-Host $document;
$downloadPath = Join-Path $PSScriptRoot 'downloads';
$toolsPath = Join-Path $downloadPath 'tools';

if (!(Test-Path $downloadPath)) {
  New-Item -ItemType 'directory' -Path $downloadPath;
}

foreach ($tool in $tools) {
  if ($tool.os -eq 'windows') {
    foreach ($download in $downloads) {
      if ($tool.Name -eq $download) {
        $toolName = $tool.name;
        
        # Download the tool
        Write-Host ('Downloading {0} from {1}' -f $toolName, $tool.url);
        $downloadTo = (Join-Path $downloadPath $tool.archiveName);
        Invoke-WebFileRequest -url $tool.url -DestinationPath $downloadTo;
        Write-Host('Downloaded {0} to {1}' -f $toolName, $downloadTo);
        
        # Extract the tool
        $extractTo = (Join-Path $toolsPath ('{0}-{1}-windows' -f $toolName, $tool.version));
        if ($toolName -eq '7zip') {
           $extractTo = Join-Path $extractTo ($tool.exeRelativePath -split '\\')[0];
        }
        Write-Host('Extracting {0} from {1}' -f $toolName, $downloadTo);
        Expand-7Zip -ArchiveFileName $downloadTo -TargetPath $extractTo;
        Write-Host('Extracted {0} to {1}' -f $toolName, $extractTo);
      }
    }
  }
}
