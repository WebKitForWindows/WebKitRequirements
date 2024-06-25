set(VERSION 1.18.0)

set(FILENAME "cairo-${VERSION}.tar.bz2")
set(URLS "https://gitlab.freedesktop.org/cairo/cairo/-/archive/${VERSION}/${FILENAME}")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 bd702f3b64061f8add954c243c9b59f5d44271adfa76d997941ddab629ff8018c2a1d3368edf2362573e0018c342c61483de58240c63e15e1e6035d2511d3e40
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-CMake-build.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Rename-stat-to-stats.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Run CMake build
if (freetype IN_LIST FEATURES)
    message(STATUS "Enabling freetype support")
    set(CAIRO_ENABLE_FREETYPE ON)
else ()
    set(CAIRO_ENABLE_FREETYPE OFF)
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCAIRO_ENABLE_FONTCONFIG=OFF
        -DCAIRO_ENABLE_FREETYPE=${CAIRO_ENABLE_FREETYPE}
        -DCAIRO_ENABLE_PNG=ON
        -DCAIRO_ENABLE_ZLIB=OFF
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/cairo RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/cairo/version ${VERSION})
