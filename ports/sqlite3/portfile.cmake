include(vcpkg_common_functions)

set(SQLITE3_VERSION 3.29.00)
string(REPLACE "." "" SQLITE3_TAG ${SQLITE3_VERSION})
string(CONCAT SQLITE3_TAG ${SQLITE3_TAG} "00")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://sqlite.org/2019/sqlite-amalgamation-${SQLITE3_TAG}.zip"
    FILENAME "sqlite-amalgamation-${SQLITE3_TAG}.zip"
    SHA512 3306ac3e37ec46f1b2ac74155756c82afadff7bf5b8b4c9b5516f5e8c1c785b5f50ec9b840482292f2f6c5d72cf6d9a78a0dfb727f0a9cf134b6c5522606e9b3
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${SQLITE3_VERSION}
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

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/sqlite3/copyright "SQLite is in the Public Domain.\nhttp://www.sqlite.org/copyright.html\n")
