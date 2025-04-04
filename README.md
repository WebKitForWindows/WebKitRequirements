# WebKitRequirements
> Third party packages required for building the open source WebKit port for Windows.

The WebKitRequirements repository is a
[vcpkg registry](https://learn.microsoft.com/en-us/vcpkg/concepts/registries)
which contains
[overlay ports](https://learn.microsoft.com/en-us/vcpkg/concepts/overlay-ports)
of third party libraries used in the Windows port of WebKit.

## Overlay ports

| Library | Version | Release Date | Reason for Overlay |
|---|:---:|:---:|---|
| [icu](http://site.icu-project.org) | 77.1 | 2025-03-13 | CMake port. Upstream pinned to 74.1 |
| [zlib](https://github.com/zlib-ng/zlib-ng) | zlib-ng | N/A | Map zlib to zlib-ng |
| [curl](https://curl.se) | 8.13.0 | 2025-04-02 | Customization of build options, and release candidates |
| [cairo](https://gitlab.freedesktop.org/cairo/cairo) | 1.18.2 | 2024-09-01 | CMake port. Will remove when cairo taken out of WebKit |
