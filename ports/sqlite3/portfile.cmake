set(VERSION 3.40.01)
string(REPLACE "." "" TAG ${VERSION})
string(CONCAT TAG ${TAG} "00")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://sqlite.org/2022/sqlite-amalgamation-${TAG}.zip"
    FILENAME "sqlite-amalgamation-${TAG}.zip"
    SHA512 863afdabbdbe27baaccc13477e08437ce3b4d7e6f0c51a294d1d71252476af474b6c275729ebe1bc801f004da7ca6775591a30fed1930c3a1920d8118864f1d2
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Add CMake sources
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/CMakeLists.txt DESTINATION ${SOURCE_PATH})

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DENABLE_FTS3=ON
        -DENABLE_OMIT_LOAD_EXTENSION=ON
        -DENABLE_RTREE=ON

        -DHAVE_STDLIB_H=ON
        -DSTDC_HEADERS=ON
        -DHAVE_SYS_TYPES_H=ON
        -DHAVE_SYS_STAT_H=ON
        -DHAVE_STDLIB_H=ON
        -DHAVE_STRING_H=ON
        -DHAVE_MEMORY_H=ON
        -DHAVE_STRINGS_H=ON
        -DHAVE_INTTYPES_H=ON
        -DHAVE_STDINT_H=ON
        -DHAVE_UNISTD_H=ON
        -DHAVE_DLFCN_H=ON
        -DHAVE_USLEEP=ON
        -DHAVE_DECL_STRERROR_R=ON
        -DHAVE_STRERROR_R=ON        
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/sqlite3/copyright "SQLite is in the Public Domain.\nhttp://www.sqlite.org/copyright.html\n")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/sqlite3/version ${VERSION})
