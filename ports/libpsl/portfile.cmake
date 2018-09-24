include(vcpkg_common_functions)
include(${CMAKE_CURRENT_LIST_DIR}/psl.cmake)

set(LIBPSL_VERSION 0.20.2)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libpsl-${LIBPSL_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/rockdaboot/libpsl/releases/download/libpsl-${LIBPSL_VERSION}/libpsl-${LIBPSL_VERSION}.tar.gz"
    FILENAME "libpsl-${LIBPSL_VERSION}.tar.gz"
    SHA512 fa9f6f7f0447d9fe00f5dfca5262c56ff26217eea44d0f7fc1e5d982224c41874e753f0aa06dd9e5d7d03d4f04e3dacd4f36034cc8dd0fc6e2c28b49a23e62fe
)
vcpkg_extract_source_archive(${ARCHIVE})

file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/config.h.cmake DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/cmake DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/src/CMakeLists.txt DESTINATION ${SOURCE_PATH}/src)

vcpkg_find_acquire_program(PYTHON2)
get_filename_component(PYTHON2_EXE_PATH ${PYTHON2} DIRECTORY)
set(ENV{PATH} "$ENV{PATH};${PYTHON2_EXE_PATH}")

# Apply patches
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-HAVE_LANGINFO_H.patch
)

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DPSL_SOURCE_PATH=${PSL_SOURCE_PATH}
        -DLIBPSL_VERSION=${LIBPSL_VERSION}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright)
file(INSTALL ${SOURCE_PATH}/src/LICENSE.chromium DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright-chromium)
