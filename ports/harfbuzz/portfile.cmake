set(VERSION 10.1.0)

set(FILENAME "harfbuzz-${VERSION}.tar.xz")
set(URLS "https://github.com/harfbuzz/harfbuzz/releases/download/${VERSION}/${FILENAME}")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 14b0e8fd417af9c78f36e532e3737c163902b85837be1028a8fd569508639b87afeb56f70a2313ba2f0f6d4b72bb6cee0bf50fb333dfc503c713e4d9cd86e9c3
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Remove-icu-uc-from-pkgconfig.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Run CMake build
vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DHB_HAVE_FREETYPE=ON
        -DHB_HAVE_ICU=ON
        -DHB_BUILD_UTILS=OFF
        -DHB_BUILD_SUBSET=OFF
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/harfbuzz)
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/harfbuzz RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/harfbuzz/version ${VERSION})
