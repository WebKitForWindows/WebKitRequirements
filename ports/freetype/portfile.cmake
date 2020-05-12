include(vcpkg_common_functions)

set(FREETYPE_VERSION 2.10.2)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VERSION}.tar.gz"
    FILENAME "freetype-${FREETYPE_VERSION}.tar.gz"
    SHA512 cbb1b6bb7f99f6ecb473ce6027ec5f2868af939f793dd7b083b23e9823e18c4bcbac0b92483ebe70804ad7f4ef5bf4ea5c6b476e7f631a3e6a1b3e904a41e1a5
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
set(BUILD_OPTIONS
    -DFT_WITH_ZLIB=ON
    -DFT_WITH_BZip2=OFF
    -DFT_WITH_PNG=ON
    -DFT_WITH_HarfBuzz=OFF
)

if (woff2 IN_LIST FEATURES)
    message(STATUS "Enabling woff2")
    set(BUILD_OPTIONS ${BUILD_OPTIONS} -DFT_WITH_BROTLI=ON)
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        ${BUILD_OPTIONS}
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
file(WRITE ${CURRENT_PACKAGES_DIR}/share/freetype/version ${FREETYPE_VERSION})
