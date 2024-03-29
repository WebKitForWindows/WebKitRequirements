set(VERSION_MAJOR 2)
set(VERSION_MINOR 12)
set(VERSION_PATCH 6)
set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://download.gnome.org/sources/libxml2/${VERSION_MAJOR}.${VERSION_MINOR}/libxml2-${VERSION}.tar.xz"
    FILENAME "libxml2-${VERSION}.tar.xz"
    SHA512 19d6901c0f189813e8bd20ffdfbb29d8545ca30154d1f3cc82624d64e4db3cfbe8eef7e8ccc1e195289f1bf94bb50fefcf11a95badb0ddeb845b4e4ea5a819ac
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

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS ${BUILD_OPTIONS}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/libxml2/aclocal)
file(REMOVE ${CURRENT_PACKAGES_DIR}/share/libxml2/xml2-config)
file(INSTALL ${SOURCE_PATH}/Copyright DESTINATION ${CURRENT_PACKAGES_DIR}/share/libxml2 RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libxml2/version ${VERSION})
