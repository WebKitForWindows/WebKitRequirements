include(vcpkg_common_functions)

set(HARFBUZZ_VERSION 2.3.1)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/harfbuzz-${HARFBUZZ_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/harfbuzz/harfbuzz/releases/download/${HARFBUZZ_VERSION}/harfbuzz-${HARFBUZZ_VERSION}.tar.bz2"
    FILENAME "harfbuzz-${HARFBUZZ_VERSION}.tar.bz2"
    SHA512 78a8f05bfcc95cfe3fc0f1a595bdc7298c9c1456db6c7ef70914051fda43f37aaff15eac75aa6922eca82d2291baeb8385e02e6aacb44ca05b4873c311a662ac
)
vcpkg_extract_source_archive(${ARCHIVE})

# Apply patches
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Adjust-CMake-for-vcpkg.patch
        ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Add-harfbuzz-icu-library.patch
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
