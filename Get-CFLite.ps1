<#
  .Synopsis
  Gets the CFLite requirement.
  
  .Details
  Downloads the CFLite distribution.
  
  .Parameter Root
  The root directory to download source to. Defaults to current directory.
#>

Param(
  [string] $root = '.'
)

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

$url = 'https://github.com/WebKitForWindows/WinCairoRequirements/releases/download/cflitev2017.04.05/CFLite.zip';
$extension = [System.IO.Path]::GetExtension($url);
$fileName = [System.IO.Path]::GetTempFileName() | Rename-Item -NewName { $_ -replace '.tmp$', $extension } -PassThru;

Write-Host ('Downloading CFLite distribution from {0} ...' -f $url);
Write-Host $fileName;
(New-Object System.Net.WebClient).DownloadFile($url, $fileName);
Write-Host ('Downloaded {0} bytes' -f (Get-Item $fileName).Length);
Expand-7Zip -ArchiveFileName $fileName -TargetPath $root;

Remove-Item $fileName -Force;
