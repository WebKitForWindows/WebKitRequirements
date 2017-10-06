# Building the Distribution



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
