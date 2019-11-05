include(vcpkg_common_functions)
include(${CMAKE_CURRENT_LIST_DIR}/vcpkg_acquire_gnuwin32_program.cmake)

set(LIBJPEG_TURBO_VERSION 2.0.3)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/${LIBJPEG_TURBO_VERSION}.zip"
    FILENAME "libjpeg-turbo-${LIBJPEG_TURBO_VERSION}.zip"
    SHA512 32422cd4daa29aafb711322bcab26d692b6862607b56b2e6c01ce1b13a7643669b9a759cff976f9d474558dde9323b4b2fb21f2b610cae4e583516edf533800d
)

# Patches
set(LIBJPEG_TURBO_PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Make-executables-conditional.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${LIBJPEG_TURBO_VERSION}
    PATCHES ${LIBJPEG_TURBO_PATCHES}
)

# Find NASM and add to the path
vcpkg_find_acquire_program(NASM)
get_filename_component(NASM_EXE_PATH ${NASM} DIRECTORY)
set(ENV{PATH} "$ENV{PATH};${NASM_EXE_PATH}")

# Find gnutools and add to the path
vcpkg_acquire_gnuwin32_program(GREP)
vcpkg_acquire_gnuwin32_program(SED)
get_filename_component(GREP_EXE_PATH ${GREP} DIRECTORY)
get_filename_component(SED_EXE_PATH ${SED} DIRECTORY)
set(ENV{PATH} "$ENV{PATH};${GREP_EXE_PATH};${SED_EXE_PATH}")

# Run CMake build
set(BUILD_OPTIONS
    -DENABLE_EXECUTABLES=OFF
    -DWITH_SIMD=ON
    -DWITH_TURBOJPEG=OFF
)

string(COMPARE EQUAL ${VCPKG_LIBRARY_LINKAGE} "dynamic" ENABLE_SHARED)
string(COMPARE EQUAL ${VCPKG_LIBRARY_LINKAGE} "static" ENABLE_STATIC)

if (NOT VCPKG_CMAKE_SYSTEM_NAME OR VCPKG_CMAKE_SYSTEM_NAME MATCHES "^Windows")
    string(COMPARE EQUAL ${VCPKG_CRT_LINKAGE} "dynamic" WITH_CRT_DLL)

    list(APPEND BUILD_OPTIONS -DWITH_CRT_DLL=${WITH_CRT_DLL})
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        ${BUILD_OPTIONS}
        -DENABLE_STATIC=${ENABLE_STATIC}
        -DENABLE_SHARED=${ENABLE_SHARED}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/libjpeg-turbo RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libjpeg-turbo/version ${LIBJPEG_TURBO_VERSION})
