set(VERSION 0.42.2)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://www.cairographics.org/releases/pixman-${VERSION}.tar.gz"
    FILENAME "pixman-${VERSION}.tar.gz"
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

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS ${BUILD_OPTIONS}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/pixman RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/pixman/version ${VERSION})
