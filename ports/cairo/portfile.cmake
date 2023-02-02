set(VERSION 1.17.8)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/cairo-${VERSION})

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://gitlab.freedesktop.org/cairo/cairo/-/archive/${VERSION}/cairo-${VERSION}.tar.bz2"
    FILENAME "cairo-${VERSION}.tar.bz2"
    SHA512 86d59c60c0436dde1cced60f11774e08bc483b3310faa066f9cb1cd60e64c4b7d61a27d1f5d4781187b1a3839c7b3e490a7503d09f25dbdcd5be21290f066cf8
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
