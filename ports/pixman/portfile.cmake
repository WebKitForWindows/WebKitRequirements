set(VERSION 0.42.2)

set(FILENAME "pixman-${VERSION}.tar.gz")
set(URLS "https://www.cairographics.org/releases/${FILENAME}")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 0a4e327aef89c25f8cb474fbd01de834fd2a1b13fdf7db11ab72072082e45881cd16060673b59d02054b1711ae69c6e2395f6ae9214225ee7153939efcd2fa5d
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-__has_declspec_attribute.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Add CMake sources
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/cmake DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/pixman/CMakeLists.txt DESTINATION ${SOURCE_PATH}/pixman)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/test/CMakeLists.txt DESTINATION ${SOURCE_PATH}/test)

# Run CMake build
if (VCPKG_TARGET_ARCHITECTURE STREQUAL x86 OR VCPKG_TARGET_ARCHITECTURE STREQUAL x64)
    set(BUILD_OPTIONS
        -DX86_MMX=OFF
        -DX86_SSE2=ON
        -DX86_SSSE3=ON
    )
elseif (VCPKG_TARGET_ARCHITECTURE MATCHES "^arm")
    set(BUILD_OPTIONS
        -DARM_IWMMXT=OFF
        -DARM_NEON=ON
        -DARM_SIMD=OFF
    )
endif ()

# Check for testing feature
if (testing IN_LIST FEATURES)
    message(STATUS "Enabling Tests")
    set(BUILD_OPTIONS ${BUILD_OPTIONS} -DBUILD_TESTS=ON)
else ()
    set(BUILD_OPTIONS ${BUILD_OPTIONS} -DBUILD_TESTS=OFF)
endif ()

if (NOT VCPKG_CMAKE_SYSTEM_NAME)
    set(VCPKG_CMAKE_SYSTEM_NAME Windows)
endif ()

if (VCPKG_CRT_LINKAGE STREQUAL dynamic AND VCPKG_CMAKE_SYSTEM_NAME MATCHES "^Windows")
    list(APPEND BUILD_OPTIONS -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON)
endif ()

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS ${BUILD_OPTIONS}
    MAYBE_UNUSED_VARIABLES
        CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/pixman RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/pixman/version ${VERSION})
