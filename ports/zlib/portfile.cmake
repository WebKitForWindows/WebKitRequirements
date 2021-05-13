include(vcpkg_common_functions)

set(VERSION 2.0.3)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/${VERSION}.zip"
    FILENAME "zlib-ng-${VERSION}.zip"
    SHA512 ae4bf7772e08f30a164f357d77c142ca4068cb0dd8b01bd2dcfef46de807584939b88140a608d18f59c9c7e17e5859ed9ab78e5ace3f3b2a9eac56381619e633
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Remove-static-target.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DZLIB_COMPAT=ON
        -DSKIP_INSTALL_FILES=ON
        -DZLIB_ENABLE_TESTS=OFF
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/zlib RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/zlib/version "${VERSION}")
