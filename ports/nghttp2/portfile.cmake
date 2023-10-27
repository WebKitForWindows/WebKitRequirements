set(VERSION 1.58.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/nghttp2/nghttp2/archive/v${VERSION}.zip"
    FILENAME "nghttp2-${VERSION}.zip"
    SHA512 25989f6847088ad084366adb87f5b19906a433717a1e148471a5a74dc2a5f14c9c20b309c69e6d1f86284be971532a1b0dfa496b148a8c5abb8f4c2f2bca22f5
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
        -DENABLE_SHARED_LIB=${NGHTTP2_SHARED_LIB}
        -DENABLE_STATIC_LIB=${NGHTTP2_STATIC_LIB}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/nghttp2 RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/nghttp2/version ${VERSION})
