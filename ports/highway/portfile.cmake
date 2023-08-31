set(VERSION 1.0.7)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/google/highway/archive/refs/tags/${VERSION}.tar.gz"
    FILENAME "highway-${VERSION}.tar.gz"
    SHA512 6ee5007ec13ac20b5d816b38a1b31c31a06678ca6d2ea090dd75e364f04cb2cf7ad8a82d1bdfff51079efa54b9a95fb554d62e6cc1bbf7d7e794cb272032d8f5
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Adjust-CMake-for-vcpkg.patch
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
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/highway RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/highway/version ${VERSION})
