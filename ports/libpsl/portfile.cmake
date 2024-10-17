include(${CMAKE_CURRENT_LIST_DIR}/psl.cmake)

set(VERSION 0.21.5)

set(FILENAME "libpsl-${VERSION}.tar.gz")
set(URLS "https://github.com/rockdaboot/libpsl/releases/download/${VERSION}/${FILENAME}")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 c14d575cecc0f1693894dd79565b6b9220084ddfa43b908a1cefe16d147cdd5ec47796eb0c2135e2f829a951abaf39d8a371ab5c1352f57b36e610e25adf91f5
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-CMake-platform.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Replace the config.h.in found in the release distribution
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/config.h.in DESTINATION ${SOURCE_PATH})

# Install Python
vcpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_EXE_PATH ${PYTHON3} DIRECTORY)
vcpkg_add_to_path(${PYTHON3_EXE_PATH})

# Run CMake build
vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DPSL_SOURCE_PATH=${PSL_SOURCE_PATH}
        -DLIBPSL_VERSION=${VERSION}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright)
file(INSTALL ${SOURCE_PATH}/src/LICENSE.chromium DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright-chromium)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libpsl/version ${VERSION})
