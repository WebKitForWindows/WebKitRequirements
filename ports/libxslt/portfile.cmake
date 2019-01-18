include(vcpkg_common_functions)

set(LIBXSLT_VERSION 1.1.33)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libxslt-${LIBXSLT_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "http://xmlsoft.org/sources/libxslt-${LIBXSLT_VERSION}.tar.gz"
    FILENAME "libxslt-${LIBXSLT_VERSION}.tar.gz"
    SHA512 ebbe438a38bf6355950167d3b580edc22baa46a77068c18c42445c1c9c716d42bed3b30c5cd5bec359ab32d03843224dae458e9e32dc61693e7cf4bab23536e0
)
vcpkg_extract_source_archive(${ARCHIVE})

# Add CMake sources
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/libxslt/xsltconfig.h.cmake.in DESTINATION ${SOURCE_PATH}/libxslt)

# Run CMake build
set(BUILD_OPTIONS
    -DWITH_TRIO=OFF
    -DWITH_XSLT_DEBUG=OFF
    -DWITH_MEM_DEBUG=OFF
    -DWITH_DEBUGGER=OFF
    -DWITH_ICONV=OFF
    -DWITH_ZLIB=OFF
    -DWITH_CRYPTO=OFF
    -DWITH_MODULES=OFF
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS ${BUILD_OPTIONS}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libxslt RENAME copyright)
