set(VERSION 0.6.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/ngtcp2/ngtcp2/releases/download/v${VERSION}/ngtcp2-${VERSION}.tar.bz2"
    FILENAME "ngtcp2-${VERSION}.tar.bz2"
    SHA512 5230bc9abcd7ddd570fa3241d24bc15417a8378c3a3e059f1a7565c74da56e2519538cb33064519ea38b51aef4e460d3377f45d2aa490fcf29867f497c516941
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Use-find_package-for-boringssl.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Add-a-shared-ngtcp2_crypto_boringssl-target.patch
    # Remove after next release
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Define-WIN32_LEAN_AND_MEAN-before-ws2tcpip.h.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0004-fix-ngtcp2_htons-for-windows.patch
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
    -DENABLE_BORINGSSL=ON
)

if (VCPKG_LIBRARY_LINKAGE MATCHES static)
    set(NGTCP2_SHARED_LIB OFF)
    set(NGTCP2_STATIC_LIB ON)
else ()
    set(NGTCP2_SHARED_LIB ON)
    set(NGTCP2_STATIC_LIB OFF)
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        ${BUILD_OPTIONS}
        -DENABLE_SHARED_LIB=${NGTCP2_SHARED_LIB}
        -DENABLE_STATIC_LIB=${NGTCP2_STATIC_LIB}
    OPTIONS_RELEASE
        -DBORINGSSL_LIBRARIES_ENV=BORINGSSL_LIBRARIES
    OPTIONS_DEBUG
        -DBORINGSSL_LIBRARIES_ENV=BORINGSSL_DEBUG_LIBRARIES
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/ngtcp2 RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/ngtcp2/version ${VERSION})
