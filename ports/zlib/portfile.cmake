include(vcpkg_common_functions)

set(ZLIB_VERSION 1.2.11)
set(ZLIB_GIT_REF 641491adedec68079d728728a1e9b2c76c2fae1d)

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
    SHA512 bd2af682a80fea01ab3f7d1843e1944da69a524fb983522716883f74efb430d1ceb578bab1c70b945715850ca5722896c84fdc886c2d4e736987e98139fac188
    PATCHES ${ZLIB_PATCHES}
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
