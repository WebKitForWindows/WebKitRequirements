# Building the Distribution

The following section describes how to create the WinCairoRequirements release.

Powershell is required to build WinCairoRequirements.

## Environment setup

Developers can either setup their own local development environment or can use Docker to
build the WinCairoRequirements distribution.

### Local development

The following Powershell modules are required to build.
* [WebKitDev Powershell Module](https://www.powershellgallery.com/packages/WebKitDev/)
* [7Zip4PowerShell](https://www.powershellgallery.com/packages/7Zip4Powershell/)

To install run the following commands.

```powershell
Install-Module -Name 7Zip4Powershell
Install-Module -Name 
```

### Docker development
* [WebKit Build Docker Image](https://hub.docker.com/r/webkitdev/msbuild/) - Use VS2015 build tools

```powershell
# Pulls the latest image
docker pull webkitdev/msbuild:2015

# Runs an interactive shell which will remove itself when completed
docker run --name build --rm -it --cpu-count=X --memory=Yg webkitdev/msbuild:2015 powershell
````

## Building

Creating a release build requires running the following commands.

_Currently VS2015 is the preferred method. This will change once WebKit Windows
builds require VS2017_

```powershell
Select-VSEnvironment -Version vs2015
Run-All.ps1
```

The script does the following.
* Downloads the source code releases
* Patches the CMake environment for the library if applicable
* Builds the library
* Packages the built libraries into a zip file.

Once complete the zip file can be tested locally within a WebKit WinCairo
build to verify.

## CMake Gotchas

The following issues were found with the current CMake setup. Sections will be
updated and removed as they are resolved.

### LibreSSL

LibreSSL currently makes both static and dynamic builds of its libraries. CMake
will find the static ones but will not find the dynamic. The CMake files are
patched so `crypto` becomes `libeay32` and `ssl` becomes `ssleay32`. These
are consistent with the filenames OpenSSL uses on Windows.

CMake should be patched to find the names LibreSSL uses for dynamic libraries.

### libwebp

The CMake files for the 0.6.0 release does not contain an `install` step.
This is currently fixed in the 
[repository](https://github.com/webmproject/libwebp/commit/5f62487189ad5ce0cfcf63831b9451229c160f12).

This should be fixed with a later release.
