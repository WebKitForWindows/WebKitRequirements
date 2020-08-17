include(vcpkg_common_functions)

set(VERSION 1.1.34)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "http://xmlsoft.org/sources/libxslt-${VERSION}.tar.gz"
    FILENAME "libxslt-${VERSION}.tar.gz"
    SHA512 1516a11ad608b04740674060d2c5d733b88889de5e413b9a4e8bf8d1a90d712149df6d2b1345b615f529d7c7d3fa6dae12e544da828b39c7d415e54c0ee0776b
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
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/config.h.cmake.in DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/libxslt-config.cmake.in DESTINATION ${SOURCE_PATH})
#file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/libxslt/xsltconfig.h.cmake.in DESTINATION ${SOURCE_PATH}/libxslt)

# Run CMake build
set(BUILD_OPTIONS
    # Use CMAKE_DISABLE_FIND_PACKAGE_XXX=TRUE to disable dependencies in FreeType
    # Otherwise libxslt will attempt to use it if available
    -DCMAKE_DISABLE_FIND_PACKAGE_Iconv=TRUE
    -DCMAKE_DISABLE_FIND_PACKAGE_Python=TRUE
    -DCMAKE_DISABLE_FIND_PACKAGE_Thread=TRUE

    # Options
    -DLIBXSLT_WITH_DEBUGGER=OFF
    -DLIBXSLT_WITH_CRYPTO=OFF
    -DLIBXSLT_WITH_MEM_DEBUG=OFF
    -DLIBXSLT_WITH_MODULES=OFF
    -DLIBXSLT_WITH_PROFILER=OFF
    -DLIBXSLT_WITH_TRIO=OFF
    -DLIBXSLT_WITH_XSLT_DEBUG=OFF
)

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

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libxslt RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libxslt/version ${VERSION})
