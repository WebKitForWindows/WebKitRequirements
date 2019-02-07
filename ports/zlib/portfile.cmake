include(vcpkg_common_functions)

# Get from github commit until a release happens
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Dead2/zlib-ng
    REF a423dd6ea309e2b235ee389c87211c313cfb665b
    SHA512 bc6fe96c16501d2bddd5942886240ff45b73bd7f9603f4194525f2da81068d55c95926ac01aba97d4912e3cb5b877dadc13fef74192f1049fd55f37bd1c66e41
)

# Apply patches
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Remove-static-target.patch
        ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Add-__has_declspec_attribute.patch
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
