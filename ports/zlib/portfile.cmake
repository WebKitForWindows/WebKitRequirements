include(vcpkg_common_functions)

set(VERSION 2.0.2)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/${VERSION}.zip"
    FILENAME "zlib-ng-${VERSION}.zip"
    SHA512 eb2e68c492d080e9d1a46f1617908bac0b0bb47a1ff7779ac2b24d149988c8a4862a8342912e1ee42fa01abd4bc88fb70398be3e5c57c7f36064f7bc6f4a193e
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
