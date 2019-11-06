include(vcpkg_common_functions)

set(ZLIB_VERSION 1.2.11)
set(ZLIB_GIT_REF 5bd3c582908503135fd8d6326ca0e2a6a947b44f)

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
    SHA512 0aeaa4e84f65e9bb23d7e6bebe1338e2b5eb231d2e023f738f55785d54b477e0dee4e930906660bbac914d4387d444584d73564415f271f82cd743d76a10c7cb
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
