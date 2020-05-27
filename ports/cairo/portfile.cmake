include(vcpkg_common_functions)

set(VERSION 1.16.0)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/cairo-${VERSION})

# Cairo uses even numbered minor numbers for releases and odd minor numbers for
# development snapshots
set(RELEASE_DIR releases)
#set(RELEASE_DIR snapshots)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://cairographics.org/${RELEASE_DIR}/cairo-${VERSION}.tar.xz"
    FILENAME "cairo-${VERSION}.tar.xz"
    SHA512 9eb27c4cf01c0b8b56f2e15e651f6d4e52c99d0005875546405b64f1132aed12fbf84727273f493d84056a13105e065009d89e94a8bfaf2be2649e232b82377f
)

# Patches
set(CAIRO_PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Rename-stat-to-stats.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${CAIRO_PATCHES}
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
file(WRITE ${CURRENT_PACKAGES_DIR}/share/cairo/version ${VERSION})
