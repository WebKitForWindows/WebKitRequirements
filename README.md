# WebKitRequirements
> Third party packages required for building the open source WebKit port for Windows.

## Setup

WebKitRequirements uses [vcpkg](https://github.com/microsoft/vcpkg) to drive
building the libraries. A helper script, `Install-Vcpkg.ps1`, configures
`vcpkg` to be able to build the repository.

```powershell
> Install-Vcpkg.ps1 -vcpkgPath <path-to-vcpkg> [-update]
```

The script clones `vcpkg` at the given location if it is not already there. If
the `vcpkg` repository was already checked out at that location the script does
not automatically update the sources. An optional flag, `-update`, is required
to trigger a `git pull`.

After the repository is ready the script will copy over any resources from the
`vcpkg` checkout that are required to do the build. View the
[Install-Vcpkg.ps1](Install-Vcpkg.ps1) script for additional options.

## Building

After installing `vcpkg` the requirements can be fully built using the
`Install-Requirements` script, which is just a wrapper around `vcpkg` which
builds the listed ports. A default is chosen based on the triplet, for windows
[WindowsRequirements.json](WindowsRequirements.json) is used.

```powershell
> Install-Requirements.ps1 -triplet <triplet-file>
```

After the script runs the requirements will be built in the expected manner for
use within WebKit. View the
[Install-Requirements.ps1](Install-Requirements.ps1) script for additional
options.

Ports can be manually built using `vcpkg` directly. The
`Install-Requirements.ps1` is just provided as a convenience for fully building
the requirements.

```powershell
> vcpkg.exe install <port> --triplet <triplet>
```

## Current Versions

| Library | Version | Release Date |
|---|:---:|:---:|
| [icu](http://site.icu-project.org) | 76.1 | 2024-10-24 |
| [zlib](https://github.com/zlib-ng/zlib-ng) | 2.2.2 | 2024-09-17 |
| [brotli](https://github.com/google/brotli) | 1.1.0 | 2023-08-31 |
| [libressl](https://www.libressl.org) | 4.0.0 | 2024-10-14 |
| [nghttp2](https://nghttp2.org) | 1.64.0 | 2024-10-21 |
| [nghttp3](https://github.com/ngtcp2/nghttp3) | 1.6.0 | 2024-10-05 |
| [ngtcp2](https://github.com/ngtcp2/ngtcp2) | 1.8.1 | 2024-10-17 |
| [c-ares](https://c-ares.org) | 1.33.0 | 2024-08-02 |
| [curl](https://curl.se) | 8.10.1 | 2024-09-17 |
| [libxml2](http://xmlsoft.org) | 2.13.4 | 2024-09-18 |
| [libxslt](http://xmlsoft.org/libxslt) | 1.1.42 | 2024-07-04 |
| [lcms](https://www.littlecms.com/) | 2.16.0 | 2023-12-03 |
| [highway](https://github.com/google/highway) | 1.2.0 | 2024-05-31 |
| [libpng](http://www.libpng.org/pub/png/libpng.html) | 1.6.44 | 2024-09-12 |
| [libjpeg-turbo](http://libjpeg-turbo.virtualgl.org) | 3.0.3 | 2024-05-08 |
| [libwebp](https://github.com/webmproject/libwebp) | 1.4.0 | 2024-04-12 |
| [libjxl](https://github.com/libjxl/libjxl) | 0.11.0 | 2024-09-13 |
| [sqlite](http://sqlite.org) | 3.47.0 | 2024-10-21 |
| [woff2](https://github.com/google/woff2) | 1.0.2 | 2017-11-13 |
| [freetype](https://www.freetype.org) | 2.13.3 | 2024-08-12 |
| [harfbuzz](https://github.com/harfbuzz/harfbuzz) | 10.0.1 | 2024-09-24 |
| [pixman](http://www.pixman.org) | 0.42.2 | 2022-11-02 |
| [cairo](https://gitlab.freedesktop.org/cairo/cairo) | 1.18.0 | 2023-09-23 |
| [libpsl](https://github.com/rockdaboot/libpsl) | 0.21.5 | 2024-01-13 |
