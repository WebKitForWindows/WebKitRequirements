set(VERSION 3.44.02)
string(REPLACE "." "" TAG ${VERSION})
string(CONCAT TAG ${TAG} "00")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://sqlite.org/2023/sqlite-amalgamation-${TAG}.zip"
    FILENAME "sqlite-amalgamation-${TAG}.zip"
    SHA512 c609bba33f79cc6866515f575923b39cb61262f8d5f55c130476ce8ce016ee85f4a593b87eeef1b022a5d9f8490f5ed0616265490ef4840b7a06db2a5f4653c1
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
