set(VERSION 1.1.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/google/highway/archive/refs/tags/${VERSION}.tar.gz"
    FILENAME "highway-${VERSION}.tar.gz"
    SHA512 513718873ca5d1be5c781f92ef943432da4677582e15d25a247c1d3def087fdbd3fe787608d76f32a9b4f9253df88b40bd8ea570159f8106c338ba37e8a50a8d
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

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS 
        ${BUILD_OPTIONS}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/hwy)
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/highway RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/highway/version ${VERSION})
