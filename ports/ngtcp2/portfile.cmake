set(VERSION 1.8.0)

set(FILENAME "ngtcp2-${VERSION}.tar.xz")
set(URLS "https://github.com/ngtcp2/ngtcp2/releases/download/v${VERSION}/${FILENAME}")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 4bb838ed94977515ad7fcd86bbafddfb9733264999b268c109b8f487caf01967b0e6d9d0791f19aa549177a375a7d4182662f14b09e7dc5240fa03b68de16235
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
    if (EXISTS "${CURRENT_INSTALLED_DIR}/include/openssl/ssl.h")
        message(FATAL_ERROR "Can't build with system SSL library if OpenSSL is installed. Please remove OpenSSL and try to install again")
    endif()

    message(STATUS "Using system SSL library")
endif ()

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DBUILD_TESTING=OFF
        -DENABLE_OPENSSL=ON
        -DENABLE_SHARED_LIB=${NGTCP2_SHARED_LIB}
        -DENABLE_STATIC_LIB=${NGTCP2_STATIC_LIB}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/ngtcp2)
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/ngtcp2 RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/ngtcp2/version ${VERSION})
