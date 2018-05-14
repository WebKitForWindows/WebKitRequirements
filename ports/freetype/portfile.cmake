include(vcpkg_common_functions)

set(FREETYPE_VERSION 2.9.1)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/freetype-${FREETYPE_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "https://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VERSION}.tar.bz2"
    FILENAME "freetype-${FREETYPE_VERSION}.tar.bz2"
    SHA512 856766e1f3f4c7dc8afb2b5ee991138c8b642c6a6e5e007cd2bc04ae58bde827f082557cf41bf541d97e8485f7fd064d10390d1ee597f19d1daed6c152e27708
)
vcpkg_extract_source_archive(${ARCHIVE})

# Apply patches
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Unbreak-CMake-Windows-installation.patch
        ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Adjust-CMake-for-vcpkg.patch
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
