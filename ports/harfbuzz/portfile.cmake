include(vcpkg_common_functions)

set(HARFBUZZ_VERSION 1.7.6)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/harfbuzz-${HARFBUZZ_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/harfbuzz/harfbuzz/releases/download/${HARFBUZZ_VERSION}/harfbuzz-${HARFBUZZ_VERSION}.tar.bz2"
    FILENAME "harfbuzz-${HARFBUZZ_VERSION}.tar.bz2"
    SHA512 259656574b1ec2916ada951b759a591f45c11c5c639fa29831e06320312bf951f4f5ef6306f9ffc373abf0d40dbf944db918d4c54aca3bd7eab2c3a886db7a68
)
vcpkg_extract_source_archive(${ARCHIVE})

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DHB_HAVE_FREETYPE=ON
        -DHB_HAVE_ICU=ON
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/harfbuzz RENAME copyright)
