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
| [zlib](https://github.com/Dead2/zlib-ng) | N/A | 03-04-2018 |
| [brotli](https://github.com/google/brotli) | 1.0.3 | 03-02-2018 |
| [libressl](https://www.libressl.org) | 2.7.0 | 03-21-2018 |
| [nghttp2](https://nghttp2.org) | 1.31.0 | 02-27-2018 |
| [libpng](http://www.libpng.org/pub/png/libpng.html) | 1.6.34 | 09-29-2017 |
| [pixman](http://www.pixman.org) | 0.34.0 | 01-31-2016 |
