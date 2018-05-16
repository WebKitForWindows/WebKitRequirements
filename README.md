# WinCairoRequirements
> Third party packages required for build the WinCairo port of WebKit. 

## Building

1. Install `vckpg` by following [its installation instructions](https://github.com/Microsoft/vcpkg)
2. Copy the following files and folders from the `vcpkg` root into this repository
    1. `.vcpkg-root`
    2. `vcpkg.exe`
    2. `scripts/`
    3. `triplets/`
3. Run `vcpkg install <name>` for any packages under the port directory


## Current Versions

| Library | Version | Release Date |
|---|:---:|:---:|
| [icu](http://site.icu-project.org) | 61.1 | 03-26-2018 |
| [zlib](https://github.com/Dead2/zlib-ng) | N/A | 03-04-2018 |
| [brotli](https://github.com/google/brotli) | 1.0.4 | 04-10-2018 |
| [libressl](https://www.libressl.org) | 2.7.3 | 05-05-2018 |
| [nghttp2](https://nghttp2.org) | 1.32.0 | 05-08-2018 |
| [curl](https://curl.haxx.se) | 7.60.0 | 05-16-2018 |
| [libxml2](http://xmlsoft.org/) | 2.9.7 | 11-02-2017 |
| [libxslt](http://xmlsoft.org/libxslt/) | 1.1.32 | 11-02-2017 |
| [libpng](http://www.libpng.org/pub/png/libpng.html) | 1.6.34 | 09-29-2017 |
| [libjpeg-turbo](http://libjpeg-turbo.virtualgl.org) | 1.5.90 | 03-23-2018 |
| [libwebp](https://github.com/webmproject/libwebp) | 1.0.0 | 4-02-2018 |
| [sqlite](http://sqlite.org) | 3.23.1 | 04-10-2018 |
| [freetype](https://www.freetype.org) | 2.9.1 | 05-02-2018 |
| [harbuzz](https://www.freedesktop.org/wiki/Software/HarfBuzz) | 1.7.6 | 03-07-2018 | 
| [pixman](http://www.pixman.org) | 0.34.0 | 01-31-2016 |
| [cairo](https://www.cairographics.org) | 1.15.12 | 04-04-2017 |
| [psl](https://publicsuffix.org/) | N/A | 03-28-2018 |
| [pthreads-win32](https://sourceforge.net/projects/pthreads4w/) | 2.9.1 | 07-12-2012 |
| [OpenCFLite](https://github.com/fujii/OpenCFLite) | 0.0.2 | 12-11-2017 |
