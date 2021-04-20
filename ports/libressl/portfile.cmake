set(VERSION 3.3.2)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${VERSION}.tar.gz"
    FILENAME "libressl-${VERSION}.tar.gz"
    SHA512 16a06771a38d7f88e755878875ec38e814a9bdfe5ec5d0b9b4a7a7ce3ee4a9c3d395f82cee2803ebc418c9ea27c0ac3aa5c34197e048ea91cd8d9a707da56f77
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Remove-postfix-from-archive-name.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Disable-additional-warnings-for-Visual-Studio.patch
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
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DLIBRESSL_TESTS=OFF
    OPTIONS_RELEASE
        -DLIBRESSL_APPS=${LIBRESSL_APPS}
    OPTIONS_DEBUG
        -DLIBRESSL_APPS=OFF
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
if (tools IN_LIST FEATURES)
    vcpkg_copy_tools(TOOL_NAMES openssl AUTO_CLEAN)
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
