include(vcpkg_common_functions)

set(LIBXSLT_VERSION 1.1.32)
set(LIBXSLT_HASH e1ed3c103cd4c9897e7dd2360a11f63cf30382b7566ce6fcc81117804e203714446b5a62179ce628c3834b0b32ecdeeceecbdfa417507ce9ed5a107a0ebefb39)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libxslt-${LIBXSLT_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "http://xmlsoft.org/sources/libxslt-${LIBXSLT_VERSION}.tar.gz"
    FILENAME "libxslt-${LIBXSLT_VERSION}.tar.gz"
    SHA512 ${LIBXSLT_HASH}
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
