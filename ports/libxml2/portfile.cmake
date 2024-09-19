set(VERSION_MAJOR 2)
set(VERSION_MINOR 13)
set(VERSION_PATCH 4)
set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

set(FILENAME "libxml2-${VERSION}.tar.xz")
set(URLS "https://download.gnome.org/sources/libxml2/${VERSION_MAJOR}.${VERSION_MINOR}/${FILENAME}")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 27bfaa63431798d3aa725b36af2005bda70a20b270e601cc3c8a07cc9fd02a080cb3d2b023eb42606a57b9786469488a7c09b71bdff1a518a0b4271c78c3f940
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Remove-library-suffix-on-Windows.patch
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
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/libxml2-${VERSION})
vcpkg_fixup_pkgconfig()

# Fix the xml2-config
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/libxml2)
file(RENAME ${CURRENT_PACKAGES_DIR}/bin/xml2-config ${CURRENT_PACKAGES_DIR}/tools/libxml2/xml2-config)
vcpkg_replace_string(${CURRENT_PACKAGES_DIR}/tools/libxml2/xml2-config [[$(cd "$(dirname "$0")"; pwd -P)/..]] [[$(cd "$(dirname "$0")/../.."; pwd -P)]])

if (NOT VCPKG_BUILD_TYPE)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/libxml2/debug)
    file(RENAME ${CURRENT_PACKAGES_DIR}/debug/bin/xml2-config ${CURRENT_PACKAGES_DIR}/tools/libxml2/debug/xml2-config)
    vcpkg_replace_string(${CURRENT_PACKAGES_DIR}/tools/libxml2/debug/xml2-config [[$(cd "$(dirname "$0")"; pwd -P)/..]] [[$(cd "$(dirname "$0")/../../../debug"; pwd -P)]])
    vcpkg_replace_string(${CURRENT_PACKAGES_DIR}/tools/libxml2/debug/xml2-config [[${prefix}/include]] [[${prefix}/../include]])
endif()

# Modify headers for static builds
if (VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    vcpkg_replace_string(${CURRENT_PACKAGES_DIR}/include/libxml2/libxml/xmlexports.h "ifdef LIBXML_STATIC" "if 1")
endif()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/libxml2/aclocal)
file(REMOVE ${CURRENT_PACKAGES_DIR}/share/libxml2/xml2-config)
file(INSTALL ${SOURCE_PATH}/Copyright DESTINATION ${CURRENT_PACKAGES_DIR}/share/libxml2 RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libxml2/version ${VERSION})

if (VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()
