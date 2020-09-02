include(vcpkg_common_functions)

set(VERSION 1.2.11)
set(REF 52eb835d0b6c049a93bc690e2fc05c34cb7dfae8)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Remove-static-target.patch
)

# Get from github commit until a release happens
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO zlib-ng/zlib-ng
    REF ${REF}
    SHA512 c4811748482dfc503a0e2ed41b90392bee6750ea3818098f1332638187cf0035eea9da63e0b9a832513e9a6c9f24ebcb79c37406b99e6fbcbc8bb2c4ae1ee421
    PATCHES ${PATCHES}
)

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DZLIB_COMPAT=ON
        -DSKIP_INSTALL_FILES=ON
        -DZLIB_ENABLE_TESTS=OFF
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/zlib RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/zlib/version "${VERSION}-${REF}")
