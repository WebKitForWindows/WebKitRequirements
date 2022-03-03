set(VERSION 2.11.1)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://download.savannah.gnu.org/releases/freetype/freetype-${VERSION}.tar.gz"
    FILENAME "freetype-${VERSION}.tar.gz"
    SHA512 610f2377e28cfa4b40db6155bec02b911a93171f0b37efc7d544787468e3e8193c588a381b4743c2206ffee74ea6cdd42ed949f1d7c474e3b123900d23db69e0
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Adjust-CMake-for-vcpkg.patch
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
    -DFT_DISABLE_BZIP2=ON
    -DFT_DISABLE_HARFBUZZ=ON
    -DFT_REQUIRE_PNG=ON
    -DFT_REQUIRE_ZLIB=ON
)

if (woff2 IN_LIST FEATURES)
    message(STATUS "Enabling woff2")
    set(BUILD_OPTIONS ${BUILD_OPTIONS} -DFT_REQUIRE_BROTLI=ON)
else ()
    set(BUILD_OPTIONS ${BUILD_OPTIONS} -DFT_DISABLE_BROTLI=ON)
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
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/freetype RENAME copyright)
file(INSTALL 
    ${SOURCE_PATH}/docs/FTL.txt
    ${SOURCE_PATH}/docs/GPLv2.txt
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/freetype
)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/freetype/version ${VERSION})
