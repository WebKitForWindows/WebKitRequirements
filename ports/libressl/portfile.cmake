include(vcpkg_common_functions)

set(LIBRESSL_VERSION 2.8.1)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libressl-${LIBRESSL_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VERSION}.tar.gz"
    FILENAME "libressl-${LIBRESSL_VERSION}.tar.gz"
    SHA512 57af2c7a1a8522dca25c4e6371cb44f5ab074be1aded153e6e5fca4fa0844518710f7ce834d4dd309086686c492f10fca83f4d45c084eb49607cb5861f07ac99
)
vcpkg_extract_source_archive(${ARCHIVE})

# Apply patches
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Remove-postfix-from-archive-name.patch
)

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DLIBRESSL_APPS=OFF
        -DLIBRESSL_TESTS=OFF
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libressl RENAME copyright)
file(
    INSTALL 
        ${SOURCE_PATH}/apps/openssl/cert.pem
        ${SOURCE_PATH}/apps/openssl/openssl.cnf
        ${SOURCE_PATH}/apps/openssl/x509v3.cnf
    DESTINATION ${CURRENT_PACKAGES_DIR}/etc/ssl
)
