include(vcpkg_common_functions)

set(LIBPSL_VERSION 0.20.2)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libpsl-${LIBPSL_VERSION})

# Download PSL
vcpkg_from_github(
    OUT_SOURCE_PATH PSL_SOURCE_PATH
    REPO publicsuffix/list
    REF 8977945f11f21c23ccfdd5660ac173a87bceb025
    SHA512 626a5e1617048b1285e1c1d4001203c225eb255be4d7f951e9d5c31a9f484cd213811608955a991237c74909e215682b1c8a9202dc9855b72bf1796a57b018e0
    HEAD_REF master
)

file(INSTALL ${PSL_SOURCE_PATH}/public_suffix_list.dat DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl)
file(INSTALL ${PSL_SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright)

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/rockdaboot/libpsl/releases/download/libpsl-${LIBPSL_VERSION}/libpsl-${LIBPSL_VERSION}.tar.gz"
    FILENAME "libpsl-${LIBPSL_VERSION}.tar.gz"
    SHA512 fa9f6f7f0447d9fe00f5dfca5262c56ff26217eea44d0f7fc1e5d982224c41874e753f0aa06dd9e5d7d03d4f04e3dacd4f36034cc8dd0fc6e2c28b49a23e62fe
)
vcpkg_extract_source_archive(${ARCHIVE})

file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/src/CMakeLists.txt DESTINATION ${SOURCE_PATH}/src)

vcpkg_find_acquire_program(PYTHON2)
get_filename_component(PYTHON2_EXE_PATH ${PYTHON2} DIRECTORY)
set(ENV{PATH} "$ENV{PATH};${PYTHON2_EXE_PATH}")

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/patch-001.patch
)

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DPSL_SOURCE_PATH=${PSL_SOURCE_PATH}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
#file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/harfbuzz RENAME copyright)
