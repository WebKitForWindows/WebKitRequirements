include(vcpkg_common_functions)

set(LIBRESSL_VERSION 2.8.0)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libressl-${LIBRESSL_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VERSION}.tar.gz"
    FILENAME "libressl-${LIBRESSL_VERSION}.tar.gz"
    SHA512 3004cd78a9d52dece9f24272389778d6afca549de245852004ddd57b01a0c3a6fa1cee2d56980d067d23b3ead7f7a4aa6bcf4e0c57a56f5f7d9fd3f8d23f3ca2
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
