set(VERSION 2.13.1)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/mm2/Little-CMS/releases/download/lcms${VERSION}/lcms2-${VERSION}.tar.gz"
    FILENAME "lcms2-${VERSION}.tar.gz"
    SHA512 214ec63fa086b580a6507d493a54ccf5faf02c40e149d71e41f9fc8510efdb16554621c96d91cc886f09682c9631b10aa194b4b67eb6ffcc871d5d4666b05617
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-CMake-build.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/lcms RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/lcms/version ${VERSION})
