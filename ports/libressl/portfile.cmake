include(vcpkg_common_functions)

set(LIBRESSL_VERSION 2.7.0)
set(LIBRESSL_HASH d0e51fa7143f71266e9193fbda151c6e65ba403fa93b4030edcfd4909f5905b03586cc5605e58a62a190d46e9caf7191b6572106b8e92bc5400b2e1b6b7e025e)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libressl-${LIBRESSL_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VERSION}.tar.gz"
    FILENAME "libressl-${LIBRESSL_VERSION}.tar.gz"
    SHA512 ${LIBRESSL_HASH}
)
vcpkg_extract_source_archive(${ARCHIVE})

# Apply patches
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Use-BUILD_SHARED_LIBS-to-specify-library-type.patch
        ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Remove-postfix-from-archive-name.patch
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
