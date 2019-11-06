include(vcpkg_common_functions)

set(HARFBUZZ_VERSION 2.6.4)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/harfbuzz/harfbuzz/releases/download/${HARFBUZZ_VERSION}/harfbuzz-${HARFBUZZ_VERSION}.tar.xz"
    FILENAME "harfbuzz-${HARFBUZZ_VERSION}.tar.xz"
    SHA512 d8664bb64fda11ff7646693070637e3827f8b3d1de50e11ecf108ce4d19c878b26b2ba4cff278da6e6cc0cb431e1630d9eaa7c32a9bebb9655a7aa8dabf7114f
)

# Patches
set(HARFBUZZ_PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-cmake-Add-harfbuzz-icu-library.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Use-find_package-for-ICU.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Adjust-CMake-for-vcpkg.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${HARFBUZZ_VERSION}
    PATCHES ${HARFBUZZ_PATCHES}
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
        -DHB_BUILD_TESTS=OFF
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/harfbuzz RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/harfbuzz/version ${HARFBUZZ_VERSION})
