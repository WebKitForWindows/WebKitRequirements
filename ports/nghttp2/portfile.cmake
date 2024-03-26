set(VERSION 1.60.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/nghttp2/nghttp2/releases/download/v${VERSION}/nghttp2-${VERSION}.tar.xz"
    FILENAME "nghttp2-${VERSION}.tar.xz"
    SHA512 5e6365d9118596d41848930de70f4a918d72463920184df60a7e1678c3a6c9cf1416236888e7e34395c87f41bba00a114994ba5a6e73f6a389769abf1b5cc842
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Adjust-CMake-for-vcpkg.patch
    # Remove after next release
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-CMake-Respect-BUILD_STATIC_LIBS.patch
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
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/nghttp2 RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/nghttp2/version ${VERSION})
