include(vcpkg_common_functions)

set(NGHTTP2_VERSION 1.40.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/nghttp2/nghttp2/archive/v${NGHTTP2_VERSION}.zip"
    FILENAME "nghttp2-${NGHTTP2_VERSION}.zip"
    SHA512 94e61c9bf94cd699433fb414d40a1136aef179ea8b9b1f4816c3e67012eaac7094cdebc66f2e050c912c5acba19ee0d451dce20abf778c160b8603fbb9638f67
)

# Patches
set(NGHTTP2_PATCHES
    # Remove after https://github.com/nghttp2/nghttp2/pull/1418 lands in a release
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Make_hard-coded_static_lib_suffix.patch
    # Remove after https://github.com/nghttp2/nghttp2/pull/1444 lands in a release
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-fix-recv-window-flow-control-issue.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${NGHTTP2_VERSION}
    PATCHES ${NGHTTP2_PATCHES}
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

if (VCPKG_LIBRARY_LINKAGE MATCHES static)
    set(NGHTTP2_SHARED_LIB OFF)
    set(NGHTTP2_STATIC_LIB ON)
else ()
    set(NGHTTP2_SHARED_LIB ON)
    set(NGHTTP2_STATIC_LIB OFF)
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        ${BUILD_OPTIONS}
        -DENABLE_SHARED_LIB=${NGHTTP2_SHARED_LIB}
        -DENABLE_STATIC_LIB=${NGHTTP2_STATIC_LIB}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/nghttp2 RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/nghttp2/version ${NGHTTP2_VERSION})
