include(vcpkg_common_functions)

set(BROTLI_VERSION 1.0.6)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/brotli-${BROTLI_VERSION})

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/google/brotli/archive/v${BROTLI_VERSION}.zip"
    FILENAME "brotli-${BROTLI_VERSION}.zip"
    SHA512 dff7d1d274808c340bce9f0224c1a479a31e3f94eda125f9b66cb072cbd8d27d0e281440040a59a3103f08cb37c86592600dc7a387a5aed95353bf9cd1f4dbce
)
vcpkg_extract_source_archive(${ARCHIVE})

# Apply patches
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Remove-static-target.patch
        ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Add-__has_declspec_attribute.patch
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

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/brotli RENAME copyright)
