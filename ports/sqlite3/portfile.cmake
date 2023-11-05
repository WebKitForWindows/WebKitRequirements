set(VERSION 3.44.00)
string(REPLACE "." "" TAG ${VERSION})
string(CONCAT TAG ${TAG} "00")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://sqlite.org/2023/sqlite-amalgamation-${TAG}.zip"
    FILENAME "sqlite-amalgamation-${TAG}.zip"
    SHA512 b24d3862885818d3409967ff434f4b84133531bc87dd26bc1af941ae721baa9b4ad1d527014e63f03e59c34ffdc204a1a28a83d7a9517080531059eaac45668c
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
