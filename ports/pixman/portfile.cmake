include(vcpkg_common_functions)

set(PIXMAN_VERSION 0.34.0)
set(PIXMAN_HASH 81caca5b71582b53aaac473bc37145bd66ba9acebb4773fa8cdb51f4ed7fbcb6954790d8633aad85b2826dd276bcce725e26e37997a517760e9edd72e2669a6d)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/pixman-${PIXMAN_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "https://www.cairographics.org/releases/pixman-${PIXMAN_VERSION}.tar.gz"
    FILENAME "pixman-${PIXMAN_VERSION}.tar.gz"
    SHA512 ${PIXMAN_HASH}
)
vcpkg_extract_source_archive(${ARCHIVE})

# Apply patches
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-__has_declspec_attribute.patch
)

# Add CMake sources
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/cmake DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/pixman/CMakeLists.txt DESTINATION ${SOURCE_PATH}/pixman)

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

if (NOT VCPKG_CMAKE_SYSTEM_NAME)
    set(VCPKG_CMAKE_SYSTEM_NAME Windows)
endif ()

if (VCPKG_CRT_LINKAGE STREQUAL dynamic AND VCPKG_CMAKE_SYSTEM_NAME MATCHES "^Windows")
    list(APPEND BUILD_OPTIONS -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON)
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS ${BUILD_OPTIONS}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/pixman RENAME copyright)
