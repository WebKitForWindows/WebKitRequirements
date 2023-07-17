set(VERSION 8.0.1)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/harfbuzz/harfbuzz/releases/download/${VERSION}/harfbuzz-${VERSION}.tar.xz"
    FILENAME "harfbuzz-${VERSION}.tar.xz"
    SHA512 e1292f059b07a5aa2f3fbf345b893209cac895c461b4abf30b8b76bcd03c79dd09f911450293403070e1a0bb08496a7f37693ba5a62a9d423dd6ba55e744444d
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Use-find_package-for-ICU.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Adjust-CMake-for-vcpkg.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Remove-icu-uc-from-pkgconfig.patch
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
        -DHB_HAVE_FREETYPE=ON
        -DHB_HAVE_ICU=ON
        -DHB_BUILD_UTILS=OFF
        -DHB_BUILD_SUBSET=OFF
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/harfbuzz RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/harfbuzz/version ${VERSION})
