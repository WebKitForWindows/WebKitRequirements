# WinCairoRequirements
> Third party packages required for build the WinCairo port of WebKit.

[![Build Status](https://internal.cloud.drone.ci/api/badges/WebKitForWindows/WinCairoRequirements/status.svg)](https://internal.cloud.drone.ci/WebKitForWindows/WinCairoRequirements)

## Building

1. Install `vckpg` by following [its installation instructions](https://github.com/Microsoft/vcpkg)
2. Copy the following files and folders from the `vcpkg` root into this repository
    1. `.vcpkg-root`
    2. `vcpkg.exe`
    2. `scripts/`
3. Run `vcpkg install <name>` for any packages under the port directory


## Current Versions

| Library | Version | Release Date |
|---|:---:|:---:|
| [icu](http://site.icu-project.org) | 63.1 | 10-15-2018 |
| [zlib](https://github.com/Dead2/zlib-ng) | N/A | 04-01-2019 |
| [brotli](https://github.com/google/brotli) | 1.0.7 | 10-23-2018 |
| [libressl](https://www.libressl.org) | 2.9.2 | 05-20-2018 |
| [nghttp2](https://nghttp2.org) | 1.39.2 | 08-19-2019 |
| [curl](https://curl.haxx.se) | 7.65.3 | 07-19-2019 |
| [libxml2](http://xmlsoft.org/) | 2.9.9 | 01-03-2019 |
| [libxslt](http://xmlsoft.org/libxslt) | 1.1.33 | 01-03-2019 |
| [libpng](http://www.libpng.org/pub/png/libpng.html) | 1.6.37 | 04-15-2019 |
| [libjpeg-turbo](http://libjpeg-turbo.virtualgl.org) | 2.0.2 | 02-13-2019 |
| [libwebp](https://github.com/webmproject/libwebp) | 1.0.3 | 07-13-2019 |
| [openjpeg](https://www.openjpeg.org/) | 2.3.1 | 04-02-2019 |
| [sqlite](http://sqlite.org) | 3.29.0 | 07-10-2019 |
| [freetype](https://www.freetype.org) | 2.10.1 | 07-01-2019 |
| [harbuzz](https://www.freedesktop.org/wiki/Software/HarfBuzz) | 2.5.3 | 06-26-2019 |
| [pixman](http://www.pixman.org) | 0.38.4 | 04-10-2019 |
| [cairo](https://www.cairographics.org) | 1.16.0 | 10-18-2018 |
| [libpsl](https://github.com/rockdaboot/libpsl) | 0.21.0 | 04-16-2019 |
| [pthreads-win32](https://sourceforge.net/projects/pthreads4w/) | 2.9.1 | 07-12-2012 |
| [OpenCFLite](https://github.com/fujii/OpenCFLite) | 0.0.2 | 12-11-2017 |
