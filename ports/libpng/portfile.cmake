include(vcpkg_common_functions)

set(LIBPNG_VERSION 1.6.37)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://downloads.sourceforge.net/project/libpng/libpng16/${LIBPNG_VERSION}/libpng-${LIBPNG_VERSION}.tar.gz"
    FILENAME "libpng-${LIBPNG_VERSION}.tar.gz"
    SHA512 2ce2b855af307ca92a6e053f521f5d262c36eb836b4810cb53c809aa3ea2dcc08f834aee0ffd66137768a54397e28e92804534a74abb6fc9f6f3127f14c9c338
)

# Patches
set(LIBPNG_PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Skip-install-symlink.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Do-not-append-static-to-library-name.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${LIBPNG_VERSION}
    PATCHES ${LIBPNG_PATCHES}
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
        -DSKIP_INSTALL_FILES=ON
        -DSKIP_INSTALL_SYMLINK=ON
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/libpng ${CURRENT_PACKAGES_DIR}/debug/lib/libpng)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpng RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libpng/version ${LIBPNG_VERSION})
