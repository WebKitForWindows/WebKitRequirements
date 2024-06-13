set(VERSION 1.61.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/nghttp2/nghttp2/releases/download/v${VERSION}/nghttp2-${VERSION}.tar.xz"
    FILENAME "nghttp2-${VERSION}.tar.xz"
    SHA512 01e930d7caf464699505f92b76e2bc8192d168612dc564d2546812c42afea2fb81d552d70e8a5fed35e2bf5deadbec8eda095af94a2484bca41542988afce52a
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
    # ENABLE options
    -DENABLE_DOC=OFF
    -DENABLE_FAILMALLOC=OFF
    -DENABLE_HTTP3=OFF
    -DENABLE_LIB_ONLY=ON
    -DENABLE_THREADS=OFF
    -DENABLE_WERROR=OFF
    # WITH options
    -DWITH_JEMALLOC=OFF
    -DWITH_LIBXML2=OFF
    -DWITH_MRUBY=OFF
    -DWITH_NEVERBLEED=OFF
    -DWITH_LIBBPF=OFF
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
        -DBUILD_TESTING=OFF
        -DBUILD_SHARED_LIBS=${NGHTTP2_SHARED_LIB}
        -DBUILD_STATIC_LIBS=${NGHTTP2_STATIC_LIB}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/nghttp2)
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/nghttp2 RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/nghttp2/version ${VERSION})
