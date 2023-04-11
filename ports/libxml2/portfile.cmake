set(VERSION_MAJOR 2)
set(VERSION_MINOR 10)
set(VERSION_PATCH 4)
set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://download.gnome.org/sources/libxml2/${VERSION_MAJOR}.${VERSION_MINOR}/libxml2-${VERSION}.tar.xz"
    FILENAME "libxml2-${VERSION}.tar.xz"
    SHA512 792c1dceb098cd353a7eca4c46d31cce6310b2553d97fd3918cf0b94d93b2480759202036511bde36c24166236bd4616f57e79959eea9afe3f60614bdfe13094
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Adjust-CMake-for-vcpkg.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Remove-library-suffix-on-Windows.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Run CMake build
set(BUILD_OPTIONS
    # Require ICU
    -DLIBXML2_WITH_ICU=ON

    # Turn off tests and programs
    -DLIBXML2_WITH_TESTS=OFF
    -DLIBXML2_WITH_PROGRAMS=OFF

    # Options
    -DLIBXML2_WITH_C14N=OFF
    -DLIBXML2_WITH_CATALOG=OFF
    -DLIBXML2_WITH_DEBUG=OFF
    -DLIBXML2_WITH_FTP=OFF
    -DLIBXML2_WITH_HTTP=OFF
    -DLIBXML2_WITH_ICONV=OFF
    -DLIBXML2_WITH_ISO8859X=ON
    -DLIBXML2_WITH_LEGACY=OFF
    -DLIBXML2_WITH_LZMA=OFF
    -DLIBXML2_WITH_MEM_DEBUG=OFF
    -DLIBXML2_WITH_MODULES=OFF
    -DLIBXML2_WITH_OUTPUT=ON
    -DLIBXML2_WITH_PATTERN=OFF
    -DLIBXML2_WITH_PUSH=ON
    -DLIBXML2_WITH_PYTHON=OFF
    -DLIBXML2_WITH_READER=OFF
    -DLIBXML2_WITH_REGEXPS=ON
    -DLIBXML2_WITH_RUN_DEBUG=OFF
    -DLIBXML2_WITH_SAX1=ON
    -DLIBXML2_WITH_SCHEMAS=OFF
    -DLIBXML2_WITH_SCHEMATRON=OFF
    -DLIBXML2_WITH_THREADS=ON
    -DLIBXML2_WITH_THREAD_ALLOC=OFF
    -DLIBXML2_WITH_VALID=OFF
    -DLIBXML2_WITH_WRITER=OFF
    -DLIBXML2_WITH_XINCLUDE=OFF
    -DLIBXML2_WITH_XPTR=OFF
    -DLIBXML2_WITH_XPTR_LOCS=OFF
    -DLIBXML2_WITH_ZLIB=OFF
)

# libxslt requires certain features to be turned on
if (xslt IN_LIST FEATURES)
    list(APPEND BUILD_OPTIONS
        -DLIBXML2_WITH_HTML=ON
        -DLIBXML2_WITH_TREE=ON
        -DLIBXML2_WITH_XPATH=ON
    )
else ()
    list(APPEND BUILD_OPTIONS
        -DLIBXML2_WITH_HTML=OFF
        -DLIBXML2_WITH_TREE=OFF
        -DLIBXML2_WITH_XPATH=OFF
    )
endif ()

# Disable parallel configure due to configure file writing back into the
# include directory
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS ${BUILD_OPTIONS}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/Copyright DESTINATION ${CURRENT_PACKAGES_DIR}/share/libxml2 RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libxml2/version ${VERSION})
