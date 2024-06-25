set(VERSION 2.2.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/${VERSION}.zip"
    FILENAME "zlib-ng-${VERSION}.zip"
    SHA512 9a5b5c66093703b6eb21da04984d7b5a90278063ac4703b02172fc55e1c7f2dd62b37b3ce18577eb995ef0fb02d9b2dedb6b6854252fadb7a75d2c101ef6819b
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
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/ZLIB)
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/zlib RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/zlib/version "${VERSION}")
