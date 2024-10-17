set(VERSION 1.2.0)

set(FILENAME "highway-${VERSION}.tar.gz")
set(URLS "https://github.com/google/highway/releases/download/${VERSION}/${FILENAME}")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 34b2204eafaec8e092d970831881d757c4131288db4fac12d6f0e6cf7c0a36ca8c029ce888118803dd196831fe8c26d54c7c4bfc4c6d177220f50f67e63d0d87
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Run CMake build
set(BUILD_OPTIONS
    -DHWY_ENABLE_CONTRIB=OFF
    -DHWY_ENABLE_EXAMPLES=OFF
    -DHWY_ENABLE_INSTALL=ON
    -DHWY_ENABLE_TESTS=OFF

    -DBUILD_TESTING=OFF
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS 
        ${BUILD_OPTIONS}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/hwy)
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/highway RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/highway/version ${VERSION})
