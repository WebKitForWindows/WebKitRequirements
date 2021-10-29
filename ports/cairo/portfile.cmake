set(VERSION 1.17.4)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/cairo-${VERSION})

# Cairo uses even numbered minor numbers for releases and odd minor numbers for
# development snapshots
#set(RELEASE_DIR releases)
set(RELEASE_DIR snapshots)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://cairographics.org/${RELEASE_DIR}/cairo-${VERSION}.tar.xz"
    FILENAME "cairo-${VERSION}.tar.xz"
    SHA512 843dce4f1cb5d9fb0c33240dff658ba2723bf04697045d16669e4b7674a5287ef0eb3d960a688a129902fb714230263e35d085186dc220b65307b5ad7fa09d23
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Rename-stat-to-stats.patch
    # Remove after next release
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-boilerplate-Use-_cairo_malloc-instead-of-malloc.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Add-a-bounds-check-to-cairo_cff_parse_charstring.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0004-Slightly-improve-dealing-with-error-snapshots.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0005-Add-a-bounds-check-to-cairo_cff_font_read_fdselect.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0006-Avoid-a-use-after-free.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0007-Avoid-a-use-after-scope.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0008-Fix-undefined-left-shifts.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0009-Fix-out-of-bounds-access-in-cairo_type1_font_subset_.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0010-Fix-memory-leak-in-cairo_cff_font_read_cid_fontdict.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0011-cff-Check-subroutine-number-is-valid-before-using-as.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
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
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/cairo RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/cairo/version ${VERSION})
