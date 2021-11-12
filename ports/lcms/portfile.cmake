set(VERSION 2.12)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/mm2/Little-CMS/releases/download/lcms${VERSION}/lcms2-${VERSION}.tar.gz"
    FILENAME "lcms2-${VERSION}.tar.gz"
    SHA512 967e8ac9a1d1aa3be45dc82362b9bc71c555e8577441efda57dc12d0bf84ed9188460c52eb8542d399ce9ab43bd4191988ed22b254ef34c6c1877bbb935952ed
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
