include(vcpkg_common_functions)

set(BROTLI_VERSION 1.0.3)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/brotli-${BROTLI_VERSION})

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/google/brotli/archive/v${BROTLI_VERSION}.zip"
    FILENAME "brotli-${BROTLI_VERSION}.zip"
    SHA512 155bb074b494ece12d32fa6c97705367f08105e0f84b1d237b93840e97ca135fe12d2669d0fa9aceb81b76a8d77bcab6bfbb2646f18b26f11af56dff49ef3adc
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
