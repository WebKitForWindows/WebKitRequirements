include(vcpkg_common_functions)
include(${CMAKE_CURRENT_LIST_DIR}/psl.cmake)

set(LIBPSL_VERSION 0.21.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/rockdaboot/libpsl/releases/download/libpsl-${LIBPSL_VERSION}/libpsl-${LIBPSL_VERSION}.tar.gz"
    FILENAME "libpsl-${LIBPSL_VERSION}.tar.gz"
    SHA512 165c4f0b0640a813d512bd916e1532e32e43c8c81a5efd048f3a5b07b1b3c9129b4c4b5008b8b11a7c1b3914caea17564321389cd350bf1d687d53a97f2afa4d
)

# Patches
set(LIBPSL_PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-HAVE_LANGINFO_H.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${LIBPSL_VERSION}
    PATCHES ${LIBPSL_PATCHES}
)

# Add CMake sources
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/config.h.cmake DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/cmake DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/src/CMakeLists.txt DESTINATION ${SOURCE_PATH}/src)

# Install Python
vcpkg_find_acquire_program(PYTHON2)
get_filename_component(PYTHON2_EXE_PATH ${PYTHON2} DIRECTORY)
set(ENV{PATH} "$ENV{PATH};${PYTHON2_EXE_PATH}")

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
