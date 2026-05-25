set(VERSION 1.18.4)

set(FILENAME "cairo-${VERSION}.tar.bz2")
set(URLS "https://gitlab.freedesktop.org/cairo/cairo/-/archive/${VERSION}/${FILENAME}")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 27b98a17510b4d6f0187fcb280fea1b47ae31243f6999081a7ac94f8cf3c789c05fa6eb0fe65844808ef9ac11bcd29a4c3688c871a6950d888667840385acf9b
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

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCAIRO_ENABLE_FONTCONFIG=OFF
        -DCAIRO_ENABLE_FREETYPE=${CAIRO_ENABLE_FREETYPE}
        -DCAIRO_ENABLE_PNG=ON
        -DCAIRO_ENABLE_ZLIB=OFF
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/cairo RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/cairo/version ${VERSION})
