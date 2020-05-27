include(vcpkg_common_functions)

set(VERSION_MAJOR 63)
set(VERSION_MINOR 1)
set(VERSION "${VERSION_MAJOR}.${VERSION_MINOR}")
set(VERSION2 "${VERSION_MAJOR}_${VERSION_MINOR}")
set(VERSION3 "${VERSION_MAJOR}-${VERSION_MINOR}")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/unicode-org/icu/releases/download/release-${VERSION3}/icu4c-${VERSION2}-src.tgz"
    FILENAME "icu4c-${VERSION2}-src.tgz"
    SHA512 9ab407ed840a00cdda7470dcc4c40299a125ad246ae4d019c4b1ede54781157fd63af015a8228cd95dbc47e4d15a0932b2c657489046a19788e5e8266eac079c
)

# Patches
set(ICU_PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-genccode-crashes-when-creating-assembly-files.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    PATCHES ${ICU_PATCHES}
)

# Add CMake sources
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/source DESTINATION ${SOURCE_PATH})

# Run CMake build
set(BUILD_OPTIONS
    -DICU_ENABLE_EXTRAS=OFF
    -DICU_ENABLE_SAMPLES=OFF
    -DICU_ENABLE_TESTS=OFF
)

# Check for a cross compile
if (NOT VCPKG_CMAKE_SYSTEM_NAME OR VCPKG_CMAKE_SYSTEM_NAME MATCHES "^Windows")
    set(VCPKG_WINDOWS ON)
endif ()

if (NOT VCPKG_WINDOWS OR VCPKG_TARGET_ARCHITECTURE MATCHES "^arm")
    message(STATUS "Cross compiling ICU")

    set(CROSS_COMPILING ON)
    set(ENABLE_TOOLS OFF)

    # Place value of ICU_CROSS_BUILDROOT into the triplet file
    list(APPEND BUILD_OPTIONS -DICU_CROSS_BUILDROOT=${ICU_CROSS_BUILD_ROOT})
else ()
    set(CROSS_COMPILING OFF)
    set(ENABLE_TOOLS ON)
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/source
    PREFER_NINJA
    OPTIONS
        ${BUILD_OPTIONS}
        -DICU_ENABLE_TOOLS=${ENABLE_TOOLS}
        -DICU_CROSS_COMPILING=${CROSS_COMPILING}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

if (ENABLE_TOOLS)
    # Rearrange location of tools
    set(TOOLS
        derb
        genbrk
        genccode
        gencfu
        gencmn
        gencnval
        gendict
        gennorm2
        genrb
        gensprep
        gentest
        pkgdata
        makeconv
        icupkg
        icuinfo
    )

    set(TOOL_EXTENSION .exe)

    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/icu)

    foreach (tool ${TOOLS})
        # Remove debug versions
        file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/${tool}${TOOL_EXTENSION})
        # Move into the tools directory
        file(RENAME ${CURRENT_PACKAGES_DIR}/bin/${tool}${TOOL_EXTENSION} ${CURRENT_PACKAGES_DIR}/tools/icu/${tool}${TOOL_EXTENSION})
    endforeach()

    vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/icu)
endif ()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/icu RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/icu/version "${VERSION_MAJOR}.${VERSION_MINOR}.0")
