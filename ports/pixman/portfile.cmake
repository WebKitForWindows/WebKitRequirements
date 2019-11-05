include(vcpkg_common_functions)

set(PIXMAN_VERSION 0.38.4)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://www.cairographics.org/releases/pixman-${PIXMAN_VERSION}.tar.gz"
    FILENAME "pixman-${PIXMAN_VERSION}.tar.gz"
    SHA512 b66dc23c0bc7327cb90085cbc14ccf96ad58001a927f23af24e0258ca13f32d4255535862f1efcf00e9e723410aa9f51edf26fb01c8cde49379d1225acf7b5af
)

# Patches
set(PIXMAN_PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-__has_declspec_attribute.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${PIXMAN_VERSION}
    PATCHES ${PIXMAN_PATCHES}
)

# Add CMake sources
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/cmake DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/pixman/CMakeLists.txt DESTINATION ${SOURCE_PATH}/pixman)

# Run CMake build
if (VCPKG_TARGET_ARCHITECTURE STREQUAL x86 OR VCPKG_TARGET_ARCHITECTURE STREQUAL x64)
    set(BUILD_OPTIONS
        -DX86_MMX=OFF
        -DX86_SSE2=ON
        -DX86_SSSE3=ON
    )
elseif (VCPKG_TARGET_ARCHITECTURE MATCHES "^arm")
    set(BUILD_OPTIONS
        -DARM_IWMMXT=OFF
        -DARM_NEON=ON
        -DARM_SIMD=OFF
    )
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS ${BUILD_OPTIONS}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/pixman RENAME copyright)
