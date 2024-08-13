set(VERSION 2.13.3)

set(FILENAME "freetype-${VERSION}.tar.xz")
set(URLS
    "https://download.savannah.gnu.org/releases/freetype/${FILENAME}"
    "https://downloads.sourceforge.net/project/freetype/freetype2/${VERSION}/${FILENAME}"
)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 600828d7756c8cfa974448ef34ee0db573fb8cfdb2dc1e0358b63c44a03bfd7e3d4384424b9cc5e4749034f60231a550c4b7fcb46694fcacea218787ce305504
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Run CMake build
set(BUILD_OPTIONS
    # No BZIP support
    -DFT_DISABLE_BZIP2=ON
    -DFT_REQUIRE_BZIP2=OFF
    # No Harfbuzz support
    -DFT_DISABLE_HARFBUZZ=ON
    -DFT_REQUIRE_HARFBUZZ=OFF
)

if (png IN_LIST FEATURES)
    message(STATUS "Enabling libpng")
    list(APPEND BUILD_OPTIONS -DFT_DISABLE_PNG=OFF -DFT_REQUIRE_PNG=ON)
else ()
    list(APPEND BUILD_OPTIONS -DFT_DISABLE_PNG=ON -DFT_REQUIRE_PNG=OFF)
endif ()

if (woff2 IN_LIST FEATURES)
    message(STATUS "Enabling woff2")
    list(APPEND BUILD_OPTIONS -DFT_DISABLE_BROTLI=OFF -DFT_REQUIRE_BROTLI=ON)
else ()
    list(APPEND BUILD_OPTIONS -DFT_DISABLE_BROTLI=ON -DFT_REQUIRE_BROTLI=OFF)
endif ()

if (zlib IN_LIST FEATURES)
    message(STATUS "Enabling system zlib")
    list(APPEND BUILD_OPTIONS -DFT_DISABLE_ZLIB=OFF -DFT_REQUIRE_ZLIB=ON)
else ()
    list(APPEND BUILD_OPTIONS -DFT_DISABLE_ZLIB=ON -DFT_REQUIRE_ZLIB=OFF)
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        ${BUILD_OPTIONS}
        -DDISABLE_FORCE_DEBUG_POSTFIX=ON
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/freetype)
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE.TXT DESTINATION ${CURRENT_PACKAGES_DIR}/share/freetype RENAME copyright)
file(INSTALL 
    ${SOURCE_PATH}/docs/FTL.TXT
    ${SOURCE_PATH}/docs/GPLv2.TXT
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/freetype
)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/freetype/version ${VERSION})
