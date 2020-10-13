include(vcpkg_common_functions)

set(VERSION 2.10.3)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://download.savannah.gnu.org/releases/freetype/freetype-${VERSION}.tar.gz"
    FILENAME "freetype-${VERSION}.tar.gz"
    SHA512 0ee157d4a0ee2cc02b6273b022704919d2eba05b44c16f53051f892faad0566006a6e0aae43c88307fd47aa5a2100b67cb4fc2803068d0f2b1bd7c3a17b1d8de
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
    -DFT_WITH_ZLIB=ON
    -DFT_WITH_BZip2=OFF
    -DFT_WITH_PNG=ON
    -DFT_WITH_HarfBuzz=OFF

    # Use CMAKE_DISABLE_FIND_PACKAGE_XXX=TRUE to disable dependencies in FreeType
    # Otherwise FreeType will attempt to use it if available
    -DCMAKE_DISABLE_FIND_PACKAGE_BZip2=TRUE
    -DCMAKE_DISABLE_FIND_PACKAGE_HarfBuzz=TRUE
)

if (woff2 IN_LIST FEATURES)
    message(STATUS "Enabling woff2")
    set(BUILD_OPTIONS ${BUILD_OPTIONS} -DFT_WITH_BROTLI=ON)
else ()
    set(BUILD_OPTIONS ${BUILD_OPTIONS} -DFT_WITH_BROTLI=OFF -DCMAKE_DISABLE_FIND_PACKAGE_BrotliDec=TRUE)
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
file(WRITE ${CURRENT_PACKAGES_DIR}/share/freetype/version ${VERSION})
