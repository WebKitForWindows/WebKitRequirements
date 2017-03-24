# Building the Distribution



## CMake Gotchas

The following issues were found with the current CMake setup. Sections will be
updated and removed as they are resolved.

### LibreSSL

CMake version 3.7.1 is not able to detect a LibreSSL build on Windows. If SSL
support for CURL is not detected then update the `FindOpenSSL.cmake` to this
[revision](https://gitlab.kitware.com/cmake/cmake/blob/9b78dca3a909ce3161d235718f935bf2fb9b7f64/Modules/FindOpenSSL.cmake).

This should be fixed with the 3.8.x release.

### libwebp

The CMake files for the 0.6.0 release does not contain an `install` step.
This is currently fixed in the 
[repository](https://github.com/webmproject/libwebp/commit/5f62487189ad5ce0cfcf63831b9451229c160f12).

This should be fixed with a later release.
