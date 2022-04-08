include(${CMAKE_CURRENT_LIST_DIR}/psl.cmake)

set(VERSION 0.21.1)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/rockdaboot/libpsl/releases/download/${VERSION}/libpsl-${VERSION}.tar.gz"
    FILENAME "libpsl-${VERSION}.tar.gz"
    SHA512 a5084b9df4ff2a0b1f5074b20972efe0da846473396d27b57967c7f6aa190ab3c910b4bfc4f8f03802f08decbbad5820d850c36ad59610262ae37fe77de0c7f5
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-CMake-platform.patch
    # Can be removed on next libpsl release
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Increase-label-size.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Fix-write-buffer-overflow.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0004-Fix-stack-buffer-overflow.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0005-Avoid-8-bit-overflow.patch
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
