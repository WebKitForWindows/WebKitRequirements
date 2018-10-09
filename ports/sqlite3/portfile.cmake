include(vcpkg_common_functions)

set(SQLITE3_VERSION 3.25.02)
string(REPLACE "." "" SQLITE3_TAG ${SQLITE3_VERSION})
string(CONCAT SQLITE3_TAG ${SQLITE3_TAG} "00")
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/sqlite-amalgamation-${SQLITE3_TAG})

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "http://sqlite.org/2018/sqlite-amalgamation-${SQLITE3_TAG}.zip"
    FILENAME "sqlite-amalgamation-${SQLITE3_TAG}.zip"
    SHA512 f87b4ab405f85df85b5d63e9e28c4db76202dc2d5461e0d0c626fa7521570d89a1122403c037704859ecb58ac1747ebf4b3c8a2f3a3c3d8492e8060df92e379f
)
vcpkg_extract_source_archive(${ARCHIVE})

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
