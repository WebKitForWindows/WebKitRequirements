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
| [brotli](https://github.com/google/brotli) | 1.0.3 | 03-02-2018 |
| [libressl](https://www.libressl.org) | 2.7.2 | 04-01-2018 |
| [nghttp2](https://nghttp2.org) | 1.31.0 | 02-27-2018 |
| [curl](https://curl.haxx.se) | 7.59.0 | 03-14-2018 |
| [libxml2](http://xmlsoft.org/) | 2.9.7 | 11-02-2017 |
| [libxslt](http://xmlsoft.org/libxslt/) | 1.1.32 | 11-02-2017 |
| [libpng](http://www.libpng.org/pub/png/libpng.html) | 1.6.34 | 09-29-2017 |
| [libjpeg-turbo](http://libjpeg-turbo.virtualgl.org) | 1.5.90 | 03-23-2018 |
| [sqlite](http://sqlite.org) | 3.23.0 | 04-02-2018 |
| [freetype](https://www.freetype.org) | 2.9.0 | 01-08-2018 |
| [pixman](http://www.pixman.org) | 0.34.0 | 01-31-2016 |
| [cairo](https://www.cairographics.org) | 1.15.10 | 12-14-2017 |
| [psl](https://publicsuffix.org/) | N/A | 03-28-2018 |
