include(vcpkg_common_functions)

set(LIBXML2_VERSION 2.9.4)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libxml2-${LIBXML2_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "http://xmlsoft.org/sources/libxml2-${LIBXML2_VERSION}.tar.gz"
    FILENAME "libxml2-${LIBXML2_VERSION}.tar.gz"
    SHA512 f5174ab1a3a0ec0037a47f47aa47def36674e02bfb42b57f609563f84c6247c585dbbb133c056953a5adb968d328f18cbc102eb0d00d48eb7c95478389e5daf9
)
vcpkg_extract_source_archive(${ARCHIVE})

# Add CMake sources
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/config.h DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/include/libxml/xmlversion.h.cmake.in DESTINATION ${SOURCE_PATH}/include/libxml)

# Run CMake build
set(BUILD_OPTIONS
    # Threading
    -DLIBXML_THREAD_SAFETY=no
    -DWITH_THREAD_ALLOC=OFF

    # Options
    -DWITH_C14N=OFF
    -DWITH_CATALOG=OFF
    -DWITH_DEBUG=OFF
    -DWITH_DOCB=OFF
    -DWITH_FTP=OFF
    -DWITH_FTP=OFF
    -DWITH_HTTP=OFF
    -DWITH_ICONV=OFF
    -DWITH_ICU=ON
    -DWITH_ISO8859X=ON
    -DWITH_LEGACY=OFF
    -DWITH_MEM_DEBUG=OFF
    -DWITH_MODULES=OFF
    -DWITH_OUTPUT=ON
    -DWITH_PATTERN=OFF
    -DWITH_PUSH=ON
    -DWITH_PYTHON=OFF
    -DWITH_READER=OFF
    -DWITH_REGEXPS=ON
    -DWITH_RUN_DEBUG=OFF
    -DWITH_SAX1=ON
    -DWITH_SCHEMAS=OFF
    -DWITH_SCHEMATRON=OFF
    -DWITH_VALID=OFF
    -DWITH_WALKER=ON
    -DWITH_WRITER=OFF
    -DWITH_XINCLUDE=OFF
    -DWITH_XPTR=OFF
    -DWITH_ZLIB=OFF
)

# libxslt requires certain features to be turned on
if (xslt IN_LIST FEATURES)
    list(APPEND BUILD_OPTIONS
        -DWITH_HTML=ON
        -DWITH_TREE=ON
        -DWITH_XPATH=ON
    )
else ()
    list(APPEND BUILD_OPTIONS
        -DWITH_HTML=OFF
        -DWITH_TREE=OFF
        -DWITH_XPATH=OFF
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
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libxml2 RENAME copyright)
