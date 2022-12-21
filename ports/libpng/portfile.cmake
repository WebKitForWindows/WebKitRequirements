set(VERSION 1.6.39)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://downloads.sourceforge.net/project/libpng/libpng16/${VERSION}/libpng-${VERSION}.tar.gz"
    FILENAME "libpng-${VERSION}.tar.gz"
    SHA512 19851afffbe2ffde62d918f7e9017dec778a7ce9c60c75cdc65072f086e6cdc9d9895eb7b207535a84cb5f4ead77ebc2aa9d80025f153662903023e1f7ab9bae
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Skip-install-symlink.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Do-not-append-static-to-library-name.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Fix-pkgconfig-on-Windows.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Run CMake build
if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    set(PNG_STATIC_LIBS OFF)
    set(PNG_SHARED_LIBS ON)
else()
    set(PNG_STATIC_LIBS ON)
    set(PNG_SHARED_LIBS OFF)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DPNG_STATIC=${PNG_STATIC_LIBS}
        -DPNG_SHARED=${PNG_SHARED_LIBS}
        -DPNG_TESTS=OFF
        -DSKIP_INSTALL_PROGRAMS=ON
        -DSKIP_INSTALL_EXECUTABLES=ON
        -DSKIP_INSTALL_SYMLINK=ON
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/libpng ${CURRENT_PACKAGES_DIR}/debug/lib/libpng)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpng RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libpng/version ${VERSION})
