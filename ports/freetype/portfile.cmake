include(vcpkg_common_functions)

set(FREETYPE_VERSION 2.9)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/freetype-${FREETYPE_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "https://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VERSION}.tar.bz2"
    FILENAME "freetype-${FREETYPE_VERSION}.tar.bz2"
    SHA512 28465f3453baf9a187529432118389de8f1b85273c9fb787d2c8f0feee8ab64b387ddd936b4e67ec58dcf71e33884e7e25f01169b737824221ab143839a9161a
)
vcpkg_extract_source_archive(${ARCHIVE})

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DWITH_ZLIB=ON
        -DWITH_BZip2=OFF
        -DWITH_PNG=ON
        -DWITH_HarfBuzz=OFF
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
