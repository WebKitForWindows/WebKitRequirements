set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

# The following libraries should always be static
if (PORT STREQUAL "highway")
    set(VCPKG_LIBRARY_LINKAGE static)
elseif (PORT STREQUAL "pixman")
    set(VCPKG_LIBRARY_LINKAGE static)
endif ()

# Turn on zlib compatibility
if (PORT STREQUAL "zlib-ng")
    set(ZLIB_COMPAT ON)
endif ()
