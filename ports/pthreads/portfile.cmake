if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
  message(FATAL_ERROR "${PORT} does not currently support UWP")
endif()
if(VCPKG_CMAKE_SYSTEM_NAME)
  set(VCPKG_POLICY_EMPTY_PACKAGE enabled)
  return()
endif()

# The pthread port creates headers that are restricted by vcpkg under normal operation
set(VCPKG_POLICY_ALLOW_RESTRICTED_HEADERS enabled)

set(VERSION 2.9.1)
string(REPLACE "." "-" PTHREADS_TAG ${VERSION})

# Get archive
vcpkg_download_distfile(ARCHIVE
  URLS "https://www.mirrorservice.org/sites/sourceware.org/pub/pthreads-win32/pthreads-w32-${PTHREADS_TAG}-release.tar.gz"
  FILENAME "pthreads-w32-${PTHREADS_TAG}-release.tar.gz"
  SHA512 9c06e85310766834370c3dceb83faafd397da18a32411ca7645c8eb6b9495fea54ca2872f4a3e8d83cb5fdc5dea7f3f0464be5bb9af3222a6534574a184bd551
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Add CMake sources
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

# Run CMake build
vcpkg_configure_cmake(
  SOURCE_PATH ${SOURCE_PATH}
  PREFER_NINJA
  OPTIONS -DPTW32_ARCH=${VCPKG_TARGET_ARCHITECTURE}
  OPTIONS_DEBUG -DDISABLE_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(GLOB HEADERS "${CURRENT_PACKAGES_DIR}/include/*.h")
foreach(HEADER ${HEADERS})
  file(READ "${HEADER}" _contents)
  string(REPLACE "defined(_TIMESPEC_DEFINED)" "1" _contents "${_contents}")
  string(REPLACE "defined(PTW32_RC_MSC)" "1" _contents "${_contents}")
  if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    string(REPLACE "!defined(PTW32_STATIC_LIB)" "0" _contents "${_contents}")
  endif()
  file(WRITE "${HEADER}" "${_contents}")
endforeach()

file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/pthreads RENAME copyright)
file(INSTALL 
    ${CURRENT_PACKAGES_DIR}/lib/pthreadsVC2.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/lib/manual-link
    RENAME pthreads.lib
)
file(INSTALL 
    ${CURRENT_PACKAGES_DIR}/debug/lib/pthreadsVC2d.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/manual-link
    RENAME pthreads.lib
)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/pthreads/version ${VERSION})
