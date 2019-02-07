include(vcpkg_common_functions)

set(CAIRO_VERSION 1.17.2)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/cairo-${CAIRO_VERSION})

# Cairo uses even numbered minor numbers for releases and odd minor numbers for
# development snapshots
#set(RELEASE_DIR releases)
set(RELEASE_DIR snapshots)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://cairographics.org/${RELEASE_DIR}/cairo-${CAIRO_VERSION}.tar.xz"
    FILENAME "cairo-${CAIRO_VERSION}.tar.xz"
    SHA512 7219833039f001cb6fca390b68771041a572ff450b4b18e309fa11d1b4d949a7d57d74d7a7d7ff7f2188cbd3188f00b5cdb2ffe4fd5b1ec33a56cfb3aea952de
)
vcpkg_extract_source_archive(${ARCHIVE})

# Apply patches
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Rename-stat-to-stats.patch
)

# Add CMake sources
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/Configure_config.cmake DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/Configure_features.cmake DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/config.h.cmake DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/features.h.cmake DESTINATION ${SOURCE_PATH})

file(MAKE_DIRECTORY ${SOURCE_PATH}/cmake)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/cmake/FindFontconfig.cmake DESTINATION ${SOURCE_PATH}/cmake)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/cmake/FindPixman.cmake DESTINATION ${SOURCE_PATH}/cmake)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/src/CMakeLists.txt DESTINATION ${SOURCE_PATH}/src)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/src/sources.cmake DESTINATION ${SOURCE_PATH}/src)

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/cairo RENAME copyright)
