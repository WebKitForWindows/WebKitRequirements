set(VERSION 0.5.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/ngtcp2/nghttp3/releases/download/v${VERSION}/nghttp3-${VERSION}.tar.bz2"
    FILENAME "nghttp3-${VERSION}.tar.bz2"
    SHA512 dce1f70091fc61946550a85072054d8e4136fb027b2fb187ae7823616c7c5a37c6abae332e16a78a38480be7b99f09ac37d031facb4323d06017e80d1affee15
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
    -DENABLE_LIB_ONLY=ON
)

if (VCPKG_LIBRARY_LINKAGE MATCHES static)
    set(NGHTTP3_SHARED_LIB OFF)
    set(NGHTTP3_STATIC_LIB ON)
else ()
    set(NGHTTP3_SHARED_LIB ON)
    set(NGHTTP3_STATIC_LIB OFF)
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        ${BUILD_OPTIONS}
        -DENABLE_SHARED_LIB=${NGHTTP3_SHARED_LIB}
        -DENABLE_STATIC_LIB=${NGHTTP3_STATIC_LIB}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/nghttp3 RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/nghttp3/version ${VERSION})
