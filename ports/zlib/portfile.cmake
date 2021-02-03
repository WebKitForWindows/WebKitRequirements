set(VERSION 2.0.0-RC2)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/zlib-ng/zlib-ng/archive/v${VERSION}.zip"
    FILENAME "zlib-ng-${VERSION}.zip"
    SHA512 9463d239f9db9bdb1648a02c1268a7828c52420636c9bb137549bfd4b59d7759e06ca53b207bc19ac47a45bea43d097d94f50f05509881ba03b15af1c4067c2c
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
