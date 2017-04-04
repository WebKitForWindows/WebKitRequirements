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
  [Parameter()]
  [string] $root = '.',
  [Parameter()]
  [string] $installPath = 'dist',
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
# nghttp2 options
#----------------------------------------------------------------------

$nghttp2Options = @(
  # ENABLE options
  '-DENABLE_APP=OFF',
  '-DENABLE_ASIO_LIB=OFF',
  '-DENABLE_EXAMPLES=OFF',
  '-DENABLE_FAILMALLOC=OFF',
  '-DENABLE_HPACK_TOOLS=OFF',
  '-DENABLE_PYTHON_BINDINGS=OFF',
  '-DENABLE_THREADS=OFF',
  '-DENABLE_WERROR=OFF',
  # WITH options
  '-DWITH_JEMALLOC=OFF',
  '-DWITH_LIBXML2=OFF',
  '-DWITH_MRUBY=OFF',
  '-DWITH_NEVERBLEED=OFF',
  '-DWITH_SPDYLAY=OFF'
);

#----------------------------------------------------------------------
# curl options
#----------------------------------------------------------------------

$curlOptions = @(
  # BUILD options
  '-DBUILD_CURL_EXE=OFF',
  '-DBUILD_TESTING=OFF',
  # CMAKE options
  '-DCMAKE_USE_GSSAPI=OFF',
  '-DCMAKE_USE_LIBSSH2=OFF',
  '-DCMAKE_USE_OPENLDAP=OFF',
  '-DCMAKE_USE_OPENSSL=ON',
  # CURL options
  '-DCURL_DISABLE_COOKIES=ON',
  '-DCURL_DISABLE_CRYPTO_AUTH=OFF',
  '-DCURL_DISABLE_DIST=ON',
  '-DCURL_DISABLE_FILE=OFF',
  '-DCURL_DISABLE_FTP=ON',
  '-DCURL_DISABLE_GOPHER=ON',
  '-DCURL_DISABLE_HTTP=OFF',
  '-DCURL_DISABLE_IMAP=ON',
  '-DCURL_DISABLE_LDAP=ON',
  '-DCURL_DISABLE_LDAPS=ON',
  '-DCURL_DISABLE_POP3=ON',
  '-DCURL_DISABLE_PROXY=OFF',
  '-DCURL_DISABLE_RTSP=ON',
  '-DCURL_DISABLE_SMTP=ON',
  '-DCURL_DISABLE_TELNET=ON',
  '-DCURL_DISABLE_TFTP=ON',
  # ENABLE options
  '-DENABLE_ARES=OFF',
  '-DENABLE_IPV6=OFF',
  '-DENABLE_MANUAL=OFF',
  '-DENABLE_THREADED_RESOLVER=ON',
  # USE options
  '-DUSE_NGHTTP2=ON',
  '-DUSE_WIN32_LDAP=OFF'
);

#----------------------------------------------------------------------
# Build function
#----------------------------------------------------------------------

Function Build-Requirement {
  Param(
    [Parameter(Mandatory)]
    [string] $name,
    [Parameter()]
    [string[]] $options = @()
  )
  
  $sourcePath = Join-Path $root $name;
  
  if (!(Test-Path $sourcePath)) {
    Write-Host ('Source code for {0} not present at {1}' -f $name, $destinationPath);
    return;
  }
  
  $args = @{
    Path = $sourcePath;
    Generator = $generator;
    BuildType = $buildType;
    InstallPath = $installPath;
    Options = $options;
  }
  
  Invoke-CMakeBuild @args;
}

#----------------------------------------------------------------------
# Build all
#
# Ordered based on dependencies
#----------------------------------------------------------------------

$root = (Resolve-Path -Path $root).Path;

if (!(Test-Path $root)) {
  Write-Host ('Creating root directory at {0}' -f $root);
  New-Item $root -Type directory;
}

Write-Host ('Building source code in {0}' -f $root);

Build-Requirement -Name 'zlib';
Build-Requirement -Name 'libressl';
Build-Requirement -Name 'nghttp2' -Options $nghttp2Options;
Build-Requirement -Name 'curl' -Options $curlOptions;
Build-Requirement -Name 'libpng';
Build-Requirement -Name 'libjpeg-turbo';
Build-Requirement -Name 'libwebp';
Build-Requirement -Name 'sqlite';
Build-Requirement -Name 'freetype';
