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
| [icu](http://site.icu-project.org) | 69.1 | 2021-03-18 |
| [zlib](https://github.com/zlib-ng/zlib-ng) | 2.0.2 | 2021-03-23 |
| [brotli](https://github.com/google/brotli) | 1.0.9 | 2020-08-27 |
| [libressl](https://www.libressl.org) | 3.3.3 | 2021-05-03 |
| [nghttp2](https://nghttp2.org) | 1.43.0 | 2021-02-02 |
| [c-ares](https://c-ares.haxx.se) | 1.17.1 | 2020-11-19 |
| [curl](https://curl.se) | 7.76.1 | 2021-04-14 |
| [libxml2](http://xmlsoft.org/) | 2.9.10 | 2019-10-30 |
| [libxslt](http://xmlsoft.org/libxslt) | 1.1.34 | 2019-10-30 |
| [libpng](http://www.libpng.org/pub/png/libpng.html) | 1.6.37 | 2019-04-15 |
| [libjpeg-turbo](http://libjpeg-turbo.virtualgl.org) | 2.1.0 | 2021-04-23 |
| [libwebp](https://github.com/webmproject/libwebp) | 1.2.0 | 2021-01-29 |
| [openjpeg](https://www.openjpeg.org/) | 2.4.0 | 2020-12-28 |
| [sqlite](http://sqlite.org) | 3.35.5 | 2021-04-19 |
| [woff2](https://github.com/google/woff2) | 1.0.2 | 2017-11-13 |
| [freetype](https://www.freetype.org) | 2.10.4 | 2020-10-20 |
| [harfbuzz](https://github.com/harfbuzz/harfbuzz) | 2.8.0 | 2021-03-16 |
| [pixman](http://www.pixman.org) | 0.40.0 | 2020-04-19 |
| [cairo](https://www.cairographics.org) | 1.17.4 | 2020-11-27 |
| [libpsl](https://github.com/rockdaboot/libpsl) | 0.21.1 | 2020-07-18 |
| [pthreads-win32](https://sourceforge.net/projects/pthreads4w/) | 2.9.1 | 2012-07-12 |
| [OpenCFLite](https://github.com/fujii/OpenCFLite) | 0.0.2 | 2017-12-11 |
