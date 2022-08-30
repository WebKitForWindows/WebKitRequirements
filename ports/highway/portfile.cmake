set(VERSION 1.0.1)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/google/highway/archive/refs/tags/${VERSION}.tar.gz"
    FILENAME "highway-${VERSION}.tar.gz"
    SHA512 35b6287579b6248966b0d36fda1522fd6338523934b079e94e857f9de08354f20b99739c99d53249a3a6c583519da0e0ac5e06dfbe6e3a89262f627c75b59dd8
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Make-hwy_test-library-optional.patch
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
    -DHWY_ENABLE_TEST=OFF

    -DHWY_ENABLE_EXAMPLES=OFF
    -DHWY_ENABLE_INSTALL=ON
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
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/highway RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/highway/version ${VERSION})
