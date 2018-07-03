include(vcpkg_common_functions)

set(BROTLI_VERSION 1.0.5)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/brotli-${BROTLI_VERSION})

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/google/brotli/archive/v${BROTLI_VERSION}.zip"
    FILENAME "brotli-${BROTLI_VERSION}.zip"
    SHA512 a2ec27cf405d66953470c1f5c411aa15935a65a8f19ee10277cf8dcbe65d7447c370e57fce69d38327c1be90b442458d4229b155154849cf95b47bc25aa2c3e7
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
