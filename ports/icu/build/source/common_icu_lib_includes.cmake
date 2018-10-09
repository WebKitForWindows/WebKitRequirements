# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

### Common libraries include directories

# PUBLIC
target_include_directories(${lib_NAME} PUBLIC
  $<INSTALL_INTERFACE:${includedir}>
)
