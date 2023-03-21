set(VERSION 1.17.8)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/cairo-${VERSION})

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://gitlab.freedesktop.org/cairo/cairo/-/archive/${VERSION}/cairo-${VERSION}.tar.bz2"
    FILENAME "cairo-${VERSION}.tar.bz2"
    SHA512 86d59c60c0436dde1cced60f11774e08bc483b3310faa066f9cb1cd60e64c4b7d61a27d1f5d4781187b1a3839c7b3e490a7503d09f25dbdcd5be21290f066cf8
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-CMake-build.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Rename-stat-to-stats.patch

    # Check-picking from 1.17.9
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Win32-surface-compositor-should-support-DWrite-font.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0004-doc-Fix-dwrite-gtk-doc-warnings.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0005-doc-fix-cairo_dwrite_font_face_set_rendering_params-.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0006-DWrite-More-accurate-glyph-paths-for-small-fonts.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0007-DWrite-Don-t-convert-subpixel-antialiasing-to-graysc.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0008-DWrite-glyph-surfaces-should-take-subpixel-positions.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0009-DWrite-clipped-glyphs-in-win32-compositor.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0010-Fix-cairo_matrix_transform_distance-documentation.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0011-DWrite-Inflate-glyph-bounds-1px-vertically-too.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0012-Change-the-workaround-of-MinGW-dwrite_3.h-problem.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0013-DWrite-Support-antialias-and-subpixel-order-font-opt.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0014-DWrite-region-clipping-didn-t-work-on-win32-surfaces.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0015-win32-font-is-very-small-if-the-lfHeight-of-HFONT-is.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Run CMake build
if (freetype IN_LIST FEATURES)
    message(STATUS "Enabling freetype support")
    set(CAIRO_ENABLE_FREETYPE ON)
else ()
    set(CAIRO_ENABLE_FREETYPE OFF)
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCAIRO_ENABLE_FONTCONFIG=OFF
        -DCAIRO_ENABLE_FREETYPE=${CAIRO_ENABLE_FREETYPE}
        -DCAIRO_ENABLE_PNG=ON
        -DCAIRO_ENABLE_ZLIB=OFF
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/cairo RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/cairo/version ${VERSION})
