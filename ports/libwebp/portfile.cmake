set(VERSION 1.2.4)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/webmproject/libwebp/archive/v${VERSION}.zip"
    FILENAME "libwebp-${VERSION}.zip"
    SHA512 9b7a0ad06128aba67471bff60b35f544ad3d6cc74b82178b970f49bd741b6c531068fe3a8907805e9f03a039d6f5156f6da60b1e0184e7301ab610c3ad70ed58
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-declspec-for-exporting-as-a-shared-library.patch
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
    OPTIONS
        -DWEBP_BUILD_ANIM_UTILS=OFF
        -DWEBP_BUILD_CWEBP=OFF
        -DWEBP_BUILD_DWEBP=OFF
        -DWEBP_BUILD_GIF2WEBP=OFF
        -DWEBP_BUILD_IMG2WEBP=OFF
        -DWEBP_BUILD_VWEBP=OFF
        -DWEBP_BUILD_WEBPINFO=OFF
        -DWEBP_BUILD_WEBPMUX=OFF
        -DWEBP_BUILD_EXTRAS=OFF
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Handle copyright
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libwebp RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libwebp/version ${VERSION})
