set(VERSION 2.16)

set(FILENAME "lcms2-${VERSION}.tar.gz")
set(URLS "https://github.com/mm2/Little-CMS/releases/download/lcms${VERSION}/${FILENAME}")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 638dd6ad6787456c8145510d18b2d0727bd0a446a13ac2934aabc9531d1156eca2a2c0fd780a453823fbd35a1895f9d8de5dc4b3cab505459dd3f0535b4e837d
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
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/lcms RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/lcms/version ${VERSION})
