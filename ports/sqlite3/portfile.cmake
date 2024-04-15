set(VERSION 3.45.03)
string(REPLACE "." "" TAG ${VERSION})
string(CONCAT TAG ${TAG} "00")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://sqlite.org/2024/sqlite-amalgamation-${TAG}.zip"
    FILENAME "sqlite-amalgamation-${TAG}.zip"
    SHA512 bd513a784da0aeb41cf4ed53173b2f8a0a37b38102dbc43a09e0f08c825ac22c7f8e3ab4a23c03d80cdcb95e98333812507aa8ef72db44da651ba3ab934e5204
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
