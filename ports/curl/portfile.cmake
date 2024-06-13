set(VERSION 8.7.1)
string(REPLACE "." "_" TAG ${VERSION})

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/curl/curl/releases/download/curl-${TAG}/curl-${VERSION}.zip"
    FILENAME "curl-${VERSION}.zip"
    SHA512 640bf8cf7ab68470d1a15c2a85c32849f7f2de85e4d4b1e403c7ee3c849a9ac797640ff0e4e3f9a24cf2aed449e0dc46934a7b32326f5381b3216acc3589a063
)

# Patches
set(PATCHES
    # Remove in next release
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-content_encoding-brotli-and-others-pass-through-0-le.patch
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
    # BUILD options
    -DBUILD_CURL_EXE=OFF
    -DBUILD_LIBCURL_DOCS=OFF
    -DBUILD_TESTING=OFF
    # CURL options
    -DCURL_BROTLI=ON
    -DCURL_ZLIB=ON
    -DCURL_DISABLE_ALTSVC=OFF
    -DCURL_DISABLE_SRP=ON
    -DCURL_DISABLE_BASIC_AUTH=OFF
    -DCURL_DISABLE_BEARER_AUTH=OFF
    -DCURL_DISABLE_DIGEST_AUTH=OFF
    -DCURL_DISABLE_KERBEROS_AUTH=OFF
    -DCURL_DISABLE_NEGOTIATE_AUTH=OFF
    -DCURL_DISABLE_AWS=OFF
    -DCURL_DISABLE_DICT=ON
    -DCURL_DISABLE_DOH=ON
    -DCURL_DISABLE_FILE=OFF
    -DCURL_DISABLE_FTP=ON
    -DCURL_DISABLE_GETOPTIONS=ON
    -DCURL_DISABLE_GOPHER=ON
    -DCURL_DISABLE_HSTS=OFF
    -DCURL_DISABLE_HTTP=OFF
    -DCURL_DISABLE_HTTP_AUTH=OFF
    -DCURL_DISABLE_IMAP=ON
    -DCURL_DISABLE_LDAP=ON
    -DCURL_DISABLE_LDAPS=ON
    -DCURL_DISABLE_MIME=OFF
    -DCURL_DISABLE_BINDLOCAL=OFF
    -DCURL_DISABLE_MQTT=ON
    -DCURL_DISABLE_NETRC=ON
    -DCURL_DISABLE_NTLM=ON
    -DCURL_DISABLE_PARSEDATE=OFF
    -DCURL_DISABLE_POP3=ON
    -DCURL_DISABLE_PROXY=OFF
    -DCURL_DISABLE_RTSP=ON
    -DCURL_DISABLE_SHUFFLE_DNS=ON
    -DCURL_DISABLE_SMB=ON
    -DCURL_DISABLE_SMTP=ON
    -DCURL_DISABLE_SOCKETPAIR=OFF
    -DCURL_DISABLE_TELNET=ON
    -DCURL_DISABLE_TFTP=ON
    -DCURL_DISABLE_VERBOSE_STRINGS=OFF
    -DCURL_USE_GSSAPI=OFF
    -DCURL_USE_LIBPSL=OFF
    -DCURL_USE_LIBSSH2=OFF
    # ENABLE options
    -DENABLE_CURL_MANUAL=OFF
    -DENABLE_UNIX_SOCKETS=OFF
    # USE options
    -DUSE_NGHTTP2=ON
    -DUSE_WIN32_LDAP=OFF
)

# Check for ares feature
if (ares IN_LIST FEATURES)
    message(STATUS "Enabling c-ares")
    list(APPEND BUILD_OPTIONS -DENABLE_ARES=ON -DENABLE_THREADED_RESOLVER=OFF)
else ()
    list(APPEND BUILD_OPTIONS -DENABLE_ARES=OFF -DENABLE_THREADED_RESOLVER=ON)
endif ()

# Check for ca-bundle feature
if (ca-bundle IN_LIST FEATURES)
    message(STATUS "Enabling CA bundle")
    list(APPEND BUILD_OPTIONS -DCURL_CA_BUNDLE=auto -DCURL_CA_PATH=auto)
else ()
    message(STATUS "Disabling CA bundle")
    list(APPEND BUILD_OPTIONS -DCURL_CA_BUNDLE=none -DCURL_CA_PATH=none)
endif ()

# Check for cookies feature
if (cookies IN_LIST FEATURES)
    message(STATUS "Enabling cookie handling")
    list(APPEND BUILD_OPTIONS -DCURL_DISABLE_COOKIES=OFF)
else ()
    message(STATUS "Disabling cookie handling")
    list(APPEND BUILD_OPTIONS -DCURL_DISABLE_COOKIES=ON)
endif ()

# Check for http3 feature
if (http3 IN_LIST FEATURES)
    message(STATUS "Enabling HTTP/3 support")
    list(APPEND BUILD_OPTIONS -DUSE_NGTCP2=ON)
else ()
    message(STATUS "Disabling HTTP/3 support")
    list(APPEND BUILD_OPTIONS -DUSE_NGTCP2=OFF)
endif ()

# Check for IPV6 feature
if (ipv6 IN_LIST FEATURES)
    message(STATUS "Enabling IPV6")
    list(APPEND BUILD_OPTIONS -DENABLE_IPV6=ON)
else ()
    list(APPEND BUILD_OPTIONS -DENABLE_IPV6=OFF)
endif ()

if (NOT VCPKG_CMAKE_SYSTEM_NAME OR VCPKG_CMAKE_SYSTEM_NAME MATCHES "^Windows")
    set(VCPKG_WINDOWS ON)

    # Windows specific features
    list(APPEND BUILD_OPTIONS
        -DENABLE_UNICODE=ON
    )
endif ()

string(COMPARE EQUAL ${VCPKG_LIBRARY_LINKAGE} static BUILD_STATIC_LIBS)
if (VCPKG_WINDOWS)
    list(APPEND BUILD_OPTIONS -DCURL_STATIC_CRT=${BUILD_STATIC_LIBS})
endif ()

# Each port of an OpenSSL equivalent checks to see that no other variant is installed so
# just check to see if any OpenSSL variants are requested and if not use the system one
set(USE_OPENSSL ON)
if (NOT libressl IN_LIST FEATURES)
    message(STATUS "Using system SSL library")

    if (VCPKG_WINDOWS)
        set(USE_OPENSSL OFF)
        set(USE_SCHANNEL ON)
    endif ()
endif ()

# When cross compiling curl it does not have the ability to use CMake's try_run
# functionality so these values need to be set properly for the platform
if (DEFINED CURL_CROSS_BUILD_OPTIONS)
    message(STATUS "Cross compiling curl")
    list(APPEND BUILD_OPTIONS ${CURL_CROSS_BUILD_OPTIONS})
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS 
        ${BUILD_OPTIONS}
        -DBUILD_STATIC_LIBS=${BUILD_STATIC_LIBS}
        -DCURL_USE_OPENSSL=${USE_OPENSSL}
        -DCURL_USE_SCHANNEL=${USE_SCHANNEL}
        # Remove debug postfix (prevent -d postfix on built products)
        -DCMAKE_DEBUG_POSTFIX=
    OPTIONS_DEBUG
        -DENABLE_DEBUG=ON
    MAYBE_UNUSED_VARIABLES
        CMAKE_DEBUG_POSTFIX
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/CURL)
vcpkg_fixup_pkgconfig()

# Prepare distribution
if (VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    vcpkg_replace_string(
        "${CURRENT_PACKAGES_DIR}/include/curl/curl.h"
        "#ifdef CURL_STATICLIB" "#if 1"
    )

    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin)
else ()
    file(REMOVE ${CURRENT_PACKAGES_DIR}/bin/curl-config)
    file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/curl-config)
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/curl RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/curl/version ${VERSION})
