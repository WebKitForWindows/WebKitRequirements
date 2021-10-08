include(${CMAKE_CURRENT_LIST_DIR}/psl.cmake)

set(VERSION 0.21.1)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/rockdaboot/libpsl/releases/download/${VERSION}/libpsl-${VERSION}.tar.gz"
    FILENAME "libpsl-${VERSION}.tar.gz"
    SHA512 a5084b9df4ff2a0b1f5074b20972efe0da846473396d27b57967c7f6aa190ab3c910b4bfc4f8f03802f08decbbad5820d850c36ad59610262ae37fe77de0c7f5
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
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
        -DLIBPSL_VERSION=${VERSION}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright)
file(INSTALL ${SOURCE_PATH}/src/LICENSE.chromium DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright-chromium)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libpsl/version ${VERSION})
