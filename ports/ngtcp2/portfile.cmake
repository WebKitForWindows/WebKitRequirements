set(VERSION 1.1.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/ngtcp2/ngtcp2/releases/download/v${VERSION}/ngtcp2-${VERSION}.tar.bz2"
    FILENAME "ngtcp2-${VERSION}.tar.bz2"
    SHA512 b1a82cfa062ea85e0dfef0c4b0914f0b19cfa47d9d82b3c38a4fdb46088694c86c9440fbf333ee6ddc8d582ecfa6d0a426b0b7da500af7b2ab52d0f6bdf93c53
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Run CMake build
if (VCPKG_LIBRARY_LINKAGE MATCHES static)
    set(NGTCP2_SHARED_LIB OFF)
    set(NGTCP2_STATIC_LIB ON)
else ()
    set(NGTCP2_SHARED_LIB ON)
    set(NGTCP2_STATIC_LIB OFF)
endif ()

# Each port of an OpenSSL equivalent checks to see that no other variant is installed so
# just check to see if any OpenSSL variants are requested and if not use the system one
set(USE_OPENSSL ON)
if (NOT libressl IN_LIST FEATURES)
    message(STATUS "Using system SSL library")
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DENABLE_OPENSSL=ON
        -DENABLE_SHARED_LIB=${NGTCP2_SHARED_LIB}
        -DENABLE_STATIC_LIB=${NGTCP2_STATIC_LIB}
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
