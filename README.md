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
| [brotli](https://github.com/google/brotli) | 1.0.3 | 03-02-2018 |
| [nghttp2](https://nghttp2.org) | 1.31.0 | 02-27-2018 |
