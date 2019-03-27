include(vcpkg_common_functions)

set(FREETYPE_VERSION 2.10.0)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/freetype-${FREETYPE_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "https://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VERSION}.tar.bz2"
    FILENAME "freetype-${FREETYPE_VERSION}.tar.bz2"
    SHA512 dfad66f419ea9577f09932e0730c0c887bdcbdbc8152fa7477a0c39d69a5b68476761deed6864ddcc5cf18d100a7a3f728049768e24afcb04b1a74b25b6acf7e
)
vcpkg_extract_source_archive(${ARCHIVE})

# Apply patches
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Adjust-CMake-for-vcpkg.patch
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
