# WebKitRequirements
> Third party packages required for building the open source WebKit port for Windows.

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
| [icu](http://site.icu-project.org) | 70.1 | 2021-10-27 |
| [zlib](https://github.com/zlib-ng/zlib-ng) | 2.0.5 | 2021-06-25 |
| [brotli](https://github.com/google/brotli) | 1.0.9 | 2020-08-27 |
| [libressl](https://www.libressl.org) | 3.4.1 | 2021-10-14 |
| [nghttp2](https://nghttp2.org) | 1.46.0 | 2021-10-19 |
| [c-ares](https://c-ares.org) | 1.18.1 | 2021-10-27 |
| [curl](https://curl.se) | 7.79.1 | 2021-09-22 |
| [libxml2](http://xmlsoft.org/) | 2.9.11 | 2021-05-13 |
| [libxslt](http://xmlsoft.org/libxslt) | 1.1.34 | 2019-10-30 |
| [libpng](http://www.libpng.org/pub/png/libpng.html) | 1.6.37 | 2019-04-15 |
| [libjpeg-turbo](http://libjpeg-turbo.virtualgl.org) | 2.1.1 | 2021-08-09 |
| [libwebp](https://github.com/webmproject/libwebp) | 1.2.1 | 2021-08-13 |
| [openjpeg](https://www.openjpeg.org/) | 2.4.0 | 2020-12-28 |
| [sqlite](http://sqlite.org) | 3.36.0 | 2021-06-18 |
| [woff2](https://github.com/google/woff2) | 1.0.2 | 2017-11-13 |
| [freetype](https://www.freetype.org) | 2.11.0 | 2021-07-19 |
| [harfbuzz](https://github.com/harfbuzz/harfbuzz) | 3.0.0 | 2021-09-17 |
| [pixman](http://www.pixman.org) | 0.40.0 | 2020-04-19 |
| [cairo](https://www.cairographics.org) | 1.17.4 | 2020-11-27 |
| [libpsl](https://github.com/rockdaboot/libpsl) | 0.21.1 | 2020-07-18 |
| [pthreads-win32](https://sourceforge.net/projects/pthreads4w/) | 2.9.1 | 2012-07-12 |
| [OpenCFLite](https://github.com/fujii/OpenCFLite) | 0.0.2 | 2017-12-11 |
