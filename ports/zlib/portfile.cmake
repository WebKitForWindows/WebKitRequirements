include(vcpkg_common_functions)

set(ZLIB_VERSION 1.2.11)
set(ZLIB_GIT_REF 098f73a45e1e346b7634b6caa15675095f764dfc)

# Patches
set(ZLIB_PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Remove-static-target.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Add-__has_declspec_attribute.patch
)

# Get from github commit until a release happens
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO zlib-ng/zlib-ng
    REF 098f73a45e1e346b7634b6caa15675095f764dfc
    SHA512 7a7e04b84de6a9ecc9d61e6b73f03a99148c76a95ff4efc9e00e73ffc42fab89f5c8ec882ddc64345e993c4046d9caca3fbf94ac0d9af080a59904134b860b9f
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
