set(VERSION_MAJOR 76)
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
    SHA512 b702ab62fb37a1574d5f4a768326d0f8fa30d9db5b015605b5f8215b5d8547f83d84880c586d3dcc7b6c76f8d47ef34e04b0f51baa55908f737024dd79a42a6c
)

# Patches
set(PATCHES
    # CMake files
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-CMake-platform.patch
    # Patch specifically for vcpkg on top of above
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Remove-install-suffix-on-Windows.patch
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

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}/source
    OPTIONS
        ${BUILD_OPTIONS}
        -DICU_ENABLE_TOOLS=${ENABLE_TOOLS}
        -DICU_CROSS_COMPILING=${CROSS_COMPILING}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
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

    vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/icu)
endif ()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/sbin)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/sbin)

# Merge cmake configs
file(COPY
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/icu
    PATTERN ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/*.cmake
)
file(COPY
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/icu
    PATTERN ${CURRENT_PACKAGES_DIR}/lib/cmake/*.cmake
)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/cmake)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/icu RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/icu/version "${VERSION_MAJOR}.${VERSION_MINOR}.0")
