include(vcpkg_common_functions)

set(ZLIB_VERSION 1.2.11)
set(ZLIB_GIT_REF 42aa81beafa2ea14cd780a9acf3359a0a09ca44b)

# Patches
set(ZLIB_PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Remove-static-target.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Add-__has_declspec_attribute.patch
)

# Get from github commit until a release happens
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO zlib-ng/zlib-ng
    REF ${ZLIB_GIT_REF}
    SHA512 6de862a37ee690294e185de6d565c40d2300ab4ab9f71f206b6c36a7f78f9e1792e2c631e129620b5d1d68d3d13fb8235af35ec767893915442544a361f9b00e
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
file(WRITE ${CURRENT_PACKAGES_DIR}/share/zlib/version "${ZLIB_VERSION}-${ZLIB_GIT_REF}")
