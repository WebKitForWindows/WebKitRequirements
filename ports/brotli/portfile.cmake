set(VERSION 1.0.9)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/google/brotli/archive/v${VERSION}.zip"
    FILENAME "brotli-${VERSION}.zip"
    SHA512 42b909a1aa5f99f370fb9e5f9e97b4a5d349aaf6fc5bf0939bbe3ced5ab3c9b6bc76d70ce0819b01f4298d10de22ae311e5d429ac7826b1d8ea107e24178b8fd
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Remove-static-target.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Add-__has_declspec_attribute.patch
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
        -DBROTLI_DISABLE_CLI=ON
        -DBROTLI_DISABLE_TESTS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/brotli RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/brotli/version ${VERSION})
