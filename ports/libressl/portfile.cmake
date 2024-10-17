set(VERSION 4.0.0)

set(FILENAME "libressl-${VERSION}.tar.gz")
set(URLS "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${FILENAME}")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 b5ec6d1f4e3842ecb487f9a67d86db658d05cbe8cd3fcba61172affa8c65c5d0823aa244065a7233f06c669d04a5a36517c02a2d99d2f2da3c4df729ac243b37
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Disable-additional-warnings-for-Visual-Studio.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

if (tools IN_LIST FEATURES)
    message(STATUS "Enabling tools")
    set(LIBRESSL_APPS ON)
else ()
    set(LIBRESSL_APPS OFF)
endif ()

# Run CMake build
vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DLIBRESSL_TESTS=OFF
    OPTIONS_RELEASE
        -DLIBRESSL_APPS=${LIBRESSL_APPS}
    OPTIONS_DEBUG
        -DLIBRESSL_APPS=OFF
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/LibreSSL)
vcpkg_fixup_pkgconfig()

# Prepare distribution
if (tools IN_LIST FEATURES)
    vcpkg_copy_tools(TOOL_NAMES openssl ocspcheck AUTO_CLEAN)
else ()
    # Config and pem files are not installed without the apps
    file(
        INSTALL
            ${SOURCE_PATH}/cert.pem
            ${SOURCE_PATH}/openssl.cnf
            ${SOURCE_PATH}/x509v3.cnf
        DESTINATION ${CURRENT_PACKAGES_DIR}/etc/ssl
    )
endif ()

# Empty directory created during install to house certificates
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/etc/ssl/certs)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/etc/ssl/certs)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libressl RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libressl/version ${VERSION})
