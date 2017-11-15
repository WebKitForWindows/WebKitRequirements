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

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

#----------------------------------------------------------------------
# Compression
#----------------------------------------------------------------------

$zlibVersion = '1.2.11';
$zlibUrl = ('https://github.com/madler/zlib/archive/v{0}.zip' -f $zlibVersion);

#----------------------------------------------------------------------
# Networking
#----------------------------------------------------------------------

$libreSSLVersion = '2.6.2';
$libreSSLUrl = ('http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-{0}.tar.gz' -f $libreSSLVersion);

$nghttp2Version = '1.26.0';
$nghttp2Url = ('https://github.com/nghttp2/nghttp2/archive/v{0}.zip' -f $nghttp2Version);

$curlVersion = '7.56.0';
$curlUrl = ('https://curl.haxx.se/download/curl-{0}.tar.gz' -f $curlVersion);

#----------------------------------------------------------------------
# Internationalization
#----------------------------------------------------------------------

$icuVersion = '59.1'
$icuUrl = ('http://download.icu-project.org/files/icu4c/{0}/icu4c-{1}-src.tgz' -f $icuVersion, $icuVersion.Replace(".", "_"))

#----------------------------------------------------------------------
# XML
#----------------------------------------------------------------------

$libxml2Version = '2.9.4';
$libxml2Url = ('ftp://xmlsoft.org/libxml2/libxml2-{0}.tar.gz' -f $libxml2Version);

#----------------------------------------------------------------------
# Database
#----------------------------------------------------------------------

$sqliteVersion = '3.21.00'
$sqliteUrl = ('https://sqlite.org/2017/sqlite-amalgamation-{0}00.zip' -f $sqliteVersion.Replace(".", ""))

#----------------------------------------------------------------------
# Image formats
#----------------------------------------------------------------------

$libPngVersion = '1.6.34';
$libPngUrl = ('https://downloads.sourceforge.net/project/libpng/libpng16/{0}/libpng-{0}.tar.gz' -f $libPngVersion);

$libJpegTurboVersion = '1.5.2';
$libJpegTurboUrl = ('https://github.com/libjpeg-turbo/libjpeg-turbo/archive/{0}.zip' -f $libJpegTurboVersion);

$libWebPVersion = '0.6.0';
$libWebPUrl = ('https://github.com/webmproject/libwebp/archive/v{0}.zip' -f $libWebPVersion);

#----------------------------------------------------------------------
# Fonts
#----------------------------------------------------------------------

$freetypeVersion = '2.8';
$freetypeUrl = ('https://sourceforge.net/projects/freetype/files/freetype2/{0}/freetype-{0}.tar.bz2' -f $freetypeVersion);

#----------------------------------------------------------------------
# Rendering
#----------------------------------------------------------------------

$pixmanVersion = '0.34.0';
$pixmanUrl = ('https://www.cairographics.org/releases/pixman-{0}.tar.gz' -f $pixmanVersion);

$cairoVersion = '1.14.10';
$cairoUrl = ('https://www.cairographics.org/releases/cairo-{0}.tar.xz' -f $cairoVersion);

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
  
  Get-SourceCodeRelease -Name $name -Url $url -DestinationPath $destinationPath;
}

#----------------------------------------------------------------------
# Download all
#----------------------------------------------------------------------

if (!(Test-Path $root)) {
  Write-Host ('Creating root directory at {0}' -f $root);
  New-Item $root -Type directory;
}

$root = (Resolve-Path -Path $root).Path;
Write-Host ('Downloading source code to {0}' -f $root);

Get-Requirement -Name 'zlib' -Url $zlibUrl;
Get-Requirement -Name 'libressl' -Url $libreSSLUrl;
Get-Requirement -Name 'nghttp2' -Url $nghttp2Url;
Get-Requirement -Name 'curl' -Url $curlUrl;
Get-Requirement -Name 'icu' -Url $icuUrl;
Get-Requirement -Name 'libxml2' -Url $libxml2Url;
Get-Requirement -Name 'libpng' -Url $libPngUrl;
Get-Requirement -Name 'libjpeg-turbo' -Url $libJpegTurboUrl;
Get-Requirement -Name 'libwebp' -Url $libWebPUrl;
Get-Requirement -Name 'sqlite' -Url $sqliteUrl;
Get-Requirement -Name 'freetype' -Url $freetypeUrl;
Get-Requirement -Name 'pixman' -Url $pixmanUrl;
Get-Requirement -Name 'cairo' -Url $cairoUrl;
