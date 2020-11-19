include(vcpkg_common_functions)

set(VERSION 1.17.1)
string(REPLACE "." "_" TAG ${VERSION})

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/c-ares/c-ares/releases/download/cares-${TAG}/c-ares-${VERSION}.tar.gz"
    FILENAME "c-ares-${VERSION}.tar.gz"
    SHA512 b11887bcc9274d368088e1a8b6aca62414f20675cf0bc58e948f54fa04c327c39dd23cefe7509eec6397db14b550a3f6b77f5c18b3d735b3eef48ce2da1dcd00
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Adjust-CMake-for-vcpkg.patch
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

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/c-ares RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/c-ares/version ${VERSION})

# The static build creates empty bin directories
if (CARES_STATIC)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin)
endif ()
