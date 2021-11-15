set(VCPKG_TARGET_ARCHITECTURE x86)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

# The following libraries should always be static
if (PORT MATCHES "highway")
  set(VCPKG_LIBRARY_LINKAGE static)
elseif (PORT MATCHES "libwebp")
  set(VCPKG_LIBRARY_LINKAGE static)
elseif (PORT MATCHES "pixman")
  set(VCPKG_LIBRARY_LINKAGE static)
endif ()
