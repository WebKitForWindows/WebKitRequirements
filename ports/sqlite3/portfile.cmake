set(VERSION 3.43.00)
string(REPLACE "." "" TAG ${VERSION})
string(CONCAT TAG ${TAG} "00")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://sqlite.org/2023/sqlite-amalgamation-${TAG}.zip"
    FILENAME "sqlite-amalgamation-${TAG}.zip"
    SHA512 241b22899c9090d94677328335588ba964a5bc3bfb278b8dcc97d6062cdfab6460b5b03dc166124f6119f5f8ece62ef9d06298de06eb5b36ed3ea49fd6ddc394
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
