set(VERSION_MAJOR 77)
set(VERSION_MINOR 1)
set(VERSION "${VERSION_MAJOR}.${VERSION_MINOR}")
set(VERSION2 "${VERSION_MAJOR}_${VERSION_MINOR}")
set(VERSION3 "${VERSION_MAJOR}-${VERSION_MINOR}")

set(FILENAME "icu4c-${VERSION2}-src.tgz")
set(URLS "https://github.com/unicode-org/icu/releases/download/release-${VERSION3}/${FILENAME}")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 a47d6d9c327d037a05ea43d1d1a06b2fd757cc02a94f7c1a238f35cfc3dfd4ab78d0612790f3a3cca0292c77412a9c2c15c8f24b718f79a857e007e66f07e7cd
)

# Patches
set(PATCHES
    # CMake files
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-CMake-platform.patch
    # Patch specifically for vcpkg on top of above
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Remove-install-suffix-on-Windows.patch
    # Append CMAKE_EXECUTABLE_SUFFIX and CMAKE_CROSSCOMPILING_EMULATOR to tool paths for cross-compilation
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Append-CMAKE_EXECUTABLE_SUFFIX-to-tool-paths.patch
    # Copy stubdata DLL to bin/ during cross-compilation (not just native Windows)
    ${CMAKE_CURRENT_LIST_DIR}/patches/0004-Copy-stubdata-dll-to-bin-for-cross-compile.patch
    # Pass optCpuArch to writeObjectCode to avoid nullptr dereference with clang
    ${CMAKE_CURRENT_LIST_DIR}/patches/0005-Pass-optCpuArch-from-pkgdata-to-writeObjectCode.patch
    # Allow overriding link.exe/LIB.exe via env vars for cross-compilation
    ${CMAKE_CURRENT_LIST_DIR}/patches/0006-Skip-pkgdata-link-step-when-cross-compiling.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    PATCHES ${PATCHES}
)

# Run CMake build
set(BUILD_OPTIONS
    -DICU_ENABLE_PLUGINS=OFF
    -DICU_ENABLE_EXTRAS=OFF
    -DICU_ENABLE_SAMPLES=OFF
    -DICU_ENABLE_TESTS=OFF
)

# Check for a cross compile
if (DEFINED ICU_CROSS_BUILD_ROOT)
    message(STATUS "Cross compiling ICU")

    set(CROSS_COMPILING ON)
    set(ENABLE_TOOLS OFF)

    # Place value of ICU_CROSS_BUILDROOT into the triplet file
    list(APPEND BUILD_OPTIONS -DICU_CROSS_BUILDROOT=${ICU_CROSS_BUILD_ROOT})
else ()
    set(CROSS_COMPILING OFF)
    set(ENABLE_TOOLS ON)
endif ()

# When cross-compiling for Windows from a non-Windows host, pkgdata.exe runs
# under Wine but cannot invoke link.exe/LIB.exe. The CMake build links the
# data library itself, so skip the redundant link step in pkgdata (patch 0006).
if (NOT VCPKG_HOST_IS_WINDOWS AND ENABLE_TOOLS)
    set(ENV{ICU_SKIP_PKGDATA_LINK} 1)
endif ()

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}/source
    OPTIONS
        ${BUILD_OPTIONS}
        -DICU_ENABLE_TOOLS=${ENABLE_TOOLS}
        -DICU_CROSS_COMPILING=${CROSS_COMPILING}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/ICU)
vcpkg_fixup_pkgconfig()

if (ENABLE_TOOLS)
    # Rearrange location of tools
    set(TOOLS
        genbrk
        gencfu
        gencnval
        gendict
        genrb
        gentest
        pkgdata
        makeconv
        icuinfo
    )
    set(STOOLS
        genccode
        gencmn
        gennorm2
        gensprep
        icupkg)

    set(TOOL_EXTENSION .exe)

    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/icu)

    foreach (tool ${TOOLS})
        # Remove debug versions
        file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/${tool}${TOOL_EXTENSION})
        # Move into the tools directory
        file(RENAME ${CURRENT_PACKAGES_DIR}/bin/${tool}${TOOL_EXTENSION} ${CURRENT_PACKAGES_DIR}/tools/icu/${tool}${TOOL_EXTENSION})
    endforeach()
    foreach (tool ${STOOLS})
        # Remove debug versions
        file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/sbin/${tool}${TOOL_EXTENSION})
        # Move into the tools directory
        file(RENAME ${CURRENT_PACKAGES_DIR}/sbin/${tool}${TOOL_EXTENSION} ${CURRENT_PACKAGES_DIR}/tools/icu/${tool}${TOOL_EXTENSION})
    endforeach()

    # vcpkg_copy_tool_dependencies requires PowerShell, skip on non-Windows hosts
    if (VCPKG_HOST_IS_WINDOWS)
        vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/icu)
    endif ()
endif ()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/sbin)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/sbin)

# Meson requires a pkgconfig file to properly build libraries with ICU
# The CMake here doesn't create one so just use a generated one
if (VCPKG_TARGET_IS_WINDOWS)
    file(INSTALL ${CMAKE_CURRENT_LIST_DIR}/pkgconfig/release DESTINATION ${CURRENT_PACKAGES_DIR}/lib RENAME pkgconfig)
    file(INSTALL ${CMAKE_CURRENT_LIST_DIR}/pkgconfig/debug DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib RENAME pkgconfig)
endif ()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/icu RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/icu/version "${VERSION_MAJOR}.${VERSION_MINOR}.0")
