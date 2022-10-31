set(VERSION 1.17.6)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/cairo-${VERSION})

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://gitlab.freedesktop.org/cairo/cairo/-/archive/${VERSION}/cairo-${VERSION}.tar.bz2"
    FILENAME "cairo-${VERSION}.tar.bz2"
    SHA512 1537b34ca49b853f4f60a7ceac0c1b878e7e2874f1ca3a37ab6ccbb704a37872314447016ad07b82312b302bb6df86b71265232a802ccdb9fb8cd18f211ff185
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-CMake-build.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Rename-stat-to-stats.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-win32-font-Ignore-GetGlyphOutlineW-failure.patch
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
