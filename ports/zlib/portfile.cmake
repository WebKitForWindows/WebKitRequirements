include(vcpkg_common_functions)

set(VERSION 1.2.11)
set(REF 0ebe2fafdda0470d0a11aa0e5b84f8b6c500d584)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Remove-static-target.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Add-__has_declspec_attribute.patch
)

# Get from github commit until a release happens
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO zlib-ng/zlib-ng
    REF ${REF}
    SHA512 0b18e92f1d2231140dde7dc3a934542d8a27990ea9007e13ec674205b7532d0ebf3e81f3a00e771d0ada8f8b9e05e7dec08938bfbeee7f9af9a9fc45d4ccce36
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
