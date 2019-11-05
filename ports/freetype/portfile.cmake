include(vcpkg_common_functions)

set(FREETYPE_VERSION 2.10.1)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VERSION}.tar.gz"
    FILENAME "freetype-${FREETYPE_VERSION}.tar.gz"
    SHA512 346c682744bcf06ca9d71265c108a242ad7d78443eff20142454b72eef47ba6d76671a6e931ed4c4c9091dd8f8515ebdd71202d94b073d77931345ff93cfeaa7
)

# Patches
set(FREETYPE_PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Adjust-CMake-for-vcpkg.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${FREETYPE_VERSION}
    PATCHES ${FREETYPE_PATCHES}
)

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DFT_WITH_ZLIB=ON
        -DFT_WITH_BZip2=OFF
        -DFT_WITH_PNG=ON
        -DFT_WITH_HarfBuzz=OFF
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/docs/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/freetype RENAME copyright)
file(INSTALL 
    ${SOURCE_PATH}/docs/FTL.txt
    ${SOURCE_PATH}/docs/GPLv2.txt
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/freetype
)
