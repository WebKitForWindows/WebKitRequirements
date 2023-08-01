set(VERSION 0.14.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/ngtcp2/nghttp3/releases/download/v${VERSION}/nghttp3-${VERSION}.tar.bz2"
    FILENAME "nghttp3-${VERSION}.tar.bz2"
    SHA512 29af8a5b5fff4b4f5f104073a76fa86747a0fcaff20be9f926911bb4a1ae343319cc3c7de8c2795897a827ae4084026dc503f12dde315f7b183336447d3a0a76
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
