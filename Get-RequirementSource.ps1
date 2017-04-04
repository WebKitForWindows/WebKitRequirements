<#
  .Synopsis
  Gets all the source code for meeting the requirements of building WebKit.
  
  .Details
  Downloads source code releases and stages them within the directory
  structure. From there they can be built out.
  
  .Parameter Root
  The root directory to download source to. Defaults to current directory.
#>

Param(
  [string] $root = '.'
)

#----------------------------------------------------------------------
# Compression
#----------------------------------------------------------------------

$zlibVersion = '1.2.11';
$zlibUrl = ('https://github.com/madler/zlib/archive/v{0}.zip' -f $zlibVersion);

#----------------------------------------------------------------------
# Networking
#----------------------------------------------------------------------

$libreSSLVersion = '2.5.2';
$libreSSLUrl = ('http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-{0}.tar.gz' -f $libreSSLVersion);

$nghttp2Version = '1.21.0';
$nghttp2Url = ('https://github.com/nghttp2/nghttp2/archive/v{0}.zip' -f $nghttp2Version);

$curlVersion = '7.53.1';
$curlUrl = ('https://curl.haxx.se/download/curl-{0}.tar.gz' -f $curlVersion);

#----------------------------------------------------------------------
# Image formats
#----------------------------------------------------------------------

$libPngVersion = '1.6.29';
$libPngUrl = ('https://downloads.sourceforge.net/project/libpng/libpng16/{0}/libpng-{0}.tar.gz' -f $libPngVersion);

$libJpegTurboVersion = '1.5.1';
$libJpegTurboUrl = ('https://github.com/libjpeg-turbo/libjpeg-turbo/archive/{0}.zip' -f $libJpegTurboVersion);

$libWebPVersion = '0.6.0';
$libWebPUrl = ('https://github.com/webmproject/libwebp/archive/v{0}.zip' -f $libWebPVersion);

#----------------------------------------------------------------------
# Download function
#----------------------------------------------------------------------

Function Get-Requirement {
  Param(
    [Parameter(Mandatory)]
    [string] $name,
    [Parameter(Mandatory)]
    [string] $url
  )
  
  $destinationPath = Join-Path $root $name;
  
  if (Test-Path $destinationPath) {
    Write-Host ('Source code for {0} already present at {1}' -f $name, $destinationPath);
    return;
  }
  
  Get-SourceCodeRelease -Name $name -Path $url -DestinationPath $destinationPath;
}

#----------------------------------------------------------------------
# Download all
#----------------------------------------------------------------------

$root = (Resolve-Path -Path $root).Path;

if (!(Test-Path $root)) {
  Write-Host ('Creating root directory at {0}' -f $root);
  New-Item $root -Type directory;
}

Write-Host ('Downloading source code to {0}' -f $root);

Get-Requirement -Name 'zlib' -Url $zlibUrl;
Get-Requirement -Name 'libressl' -Url $libreSSLUrl;
Get-Requirement -Name 'nghttp2' -Url $nghttp2Url;
Get-Requirement -Name 'curl' -Url $curlUrl;
Get-Requirement -Name 'libpng' -Url $libPngUrl;
Get-Requirement -Name 'libjpeg-turbo' -Url $libJpegTurboUrl;
Get-Requirement -Name 'libwebp' -Url $libWebPUrl;
