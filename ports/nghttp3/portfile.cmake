set(VERSION 1.2.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/ngtcp2/nghttp3/releases/download/v${VERSION}/nghttp3-${VERSION}.tar.xz"
    FILENAME "nghttp3-${VERSION}.tar.xz"
    SHA512 51ade6b17215eb15c92b18ad7a94b70e0a442d5968aee31ec734e5826d09ca34197e64407a1ac3f7bfb4ed1a0b3c3b58afc4a152542bacdcc4c71140931a7652
)

set(PATCHES
    # Remove after next release
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-cmake-add-BUILD_TESTING-fix-MSVC-with-static-shared.patch
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
        -DBUILD_TESTING=OFF
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
