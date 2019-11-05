include(vcpkg_common_functions)

set(BROTLI_VERSION 1.0.7)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/google/brotli/archive/v${BROTLI_VERSION}.zip"
    FILENAME "brotli-${BROTLI_VERSION}.zip"
    SHA512 8c43bd310c568c5a726a9e8accf6078a756e155b6eb32a4232332aa90f958258ae2b917713314caa33c9488185e8c854abe941fd4c63edfe017bba92240b896c
)

# Patches
set(BROTLI_PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Remove-static-target.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Add-__has_declspec_attribute.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${BROTLI_VERSION}
    PATCHES ${BROTLI_PATCHES}
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
file(WRITE ${CURRENT_PACKAGES_DIR}/share/brotli/version ${BROTLI_VERSION})
