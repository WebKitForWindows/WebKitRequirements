set(VERSION 1.30.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/c-ares/c-ares/releases/download/v${VERSION}/c-ares-${VERSION}.tar.gz"
    FILENAME "c-ares-${VERSION}.tar.gz"
    SHA512 427f2acd34f40464972af0baa5ff547f41e64495c4871b74a9b572d8ac3cecba08c7cd79dad4702307dee25b58963cabef90123601e033d4fd4e9ee530afc2f3
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
    -DCARES_INSTALL=ON
    -DCARES_BUILD_TESTS=OFF
    -DCARES_BUILD_CONTAINER_TESTS=OFF
    -DCARES_BUILD_TOOLS=OFF
)

if (${VCPKG_LIBRARY_LINKAGE} STREQUAL static)
    set(CARES_STATIC ON)
    set(CARES_SHARED OFF)
else ()
    set(CARES_STATIC OFF)
    set(CARES_SHARED ON)
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS 
        ${BUILD_OPTIONS}
        -DCARES_STATIC=${CARES_STATIC}
        -DCARES_SHARED=${CARES_SHARED}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/c-ares)
vcpkg_fixup_pkgconfig()

# Prepare distribution
if(CARES_STATIC)
    vcpkg_replace_string(
        "${CURRENT_PACKAGES_DIR}/include/ares.h"
        "#ifdef CARES_STATICLIB" "#if 1"
    )

    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/c-ares RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/c-ares/version ${VERSION})
