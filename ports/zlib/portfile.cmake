set(VERSION 2.1.2)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/${VERSION}.zip"
    FILENAME "zlib-ng-${VERSION}.zip"
    SHA512 eddc9bc04bf8711b976edb922eb7a3116a0d0bff4cef87306482fa5c5bcd802257d507f37354c70d6c8f4f1308ba191e852d8f183f478ad33cf569b5778f25b9
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
        -DZLIB_ENABLE_TESTS=OFF
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/zlib RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/zlib/version "${VERSION}")
