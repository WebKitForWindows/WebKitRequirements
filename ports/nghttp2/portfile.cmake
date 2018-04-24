include(vcpkg_common_functions)

set(NGHTTP2_VERSION 1.31.1)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/nghttp2-${NGHTTP2_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/nghttp2/nghttp2/archive/v${NGHTTP2_VERSION}.zip"
    FILENAME "nghttp2-${NGHTTP2_VERSION}.zip"
    SHA512 7343940083305476a980540897a15cb2af404fec67445b2c0c095839d1e850911fc0f5ed612b34fdac80eff2800a5f9e11bf713d1c3c30d3202d9e827a327928
)
vcpkg_extract_source_archive(${ARCHIVE})

# Apply patches
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Use-BUILD_SHARED_LIBS.patch
        ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Fix-library-install-destination.patch
        ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Add-__has_declspec_attribute.patch
)

# Run CMake build
set(BUILD_OPTIONS
    # ENABLE options
    -DENABLE_LIB_ONLY=ON
    -DENABLE_ASIO_LIB=OFF
    -DENABLE_FAILMALLOC=OFF
    -DENABLE_THREADS=OFF
    -DENABLE_WERROR=OFF
    # WITH options
    -DWITH_JEMALLOC=OFF
    -DWITH_LIBXML2=OFF
    -DWITH_MRUBY=OFF
    -DWITH_NEVERBLEED=OFF
    -DWITH_SPDYLAY=OFF
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
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/nghttp2 RENAME copyright)
