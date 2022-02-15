set(VERSION 2.13)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/mm2/Little-CMS/releases/download/lcms${VERSION}/lcms2-${VERSION}.tar.gz"
    FILENAME "lcms2-${VERSION}.tar.gz"
    SHA512 28cc5310b54b6254447c04ec8072878eb59e539095c400c05a15975b636f2f49daa2e5fa9021a3f9886a1b50e6c85bd950cefa8f171e3f4ee3be269a8dadc4d2
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
