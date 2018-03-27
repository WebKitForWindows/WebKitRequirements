include(vcpkg_common_functions)
include(${CMAKE_CURRENT_LIST_DIR}/vcpkg_acquire_gnuwin32_program.cmake)

set(LIBJPEG_TURBO_VERSION 1.5.90)
set(LIBJPEG_TURBO_HASH 800d1db42e9235c794cebae25201627ed5b732a5799f96657e23b9af23291913c0ce154d4e9fe4265b011308d7b57570cbf229a81db12ab51deb8e3e4e90d414)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libjpeg-turbo-${LIBJPEG_TURBO_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/${LIBJPEG_TURBO_VERSION}.zip"
    FILENAME "libjpeg-turbo-${LIBJPEG_TURBO_VERSION}.zip"
    SHA512 ${LIBJPEG_TURBO_HASH}
)
vcpkg_extract_source_archive(${ARCHIVE})

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

# Apply patches
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Make-executables-conditional.patch
        ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Use-grep-and-sed-on-all-platforms.patch
)

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
