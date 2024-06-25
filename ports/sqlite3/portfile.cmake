set(VERSION 3.46.00)
string(REPLACE "." "" TAG ${VERSION})
string(CONCAT TAG ${TAG} "00")

set(FILENAME "sqlite-amalgamation-${TAG}.zip")
# URL needs to be iterated every year
set(URLS "https://sqlite.org/2024/${FILENAME}")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 b38befaec5b3c32a35536f22f8e1dbb7a1859a6b354ad0fbdfb28634f2fab5acaa4d418420d52c4ab5291784203d46af16c183f113c4d2b4ce7efaa3a2a31d30
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-CMake-build.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DENABLE_FTS3=ON
        -DENABLE_LOAD_EXTENSION=OFF
        -DENABLE_RTREE=ON
        -DENABLE_THREADSAFE=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/sqlite3/copyright "SQLite is in the Public Domain.\nhttp://www.sqlite.org/copyright.html\n")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/sqlite3/version ${VERSION})
