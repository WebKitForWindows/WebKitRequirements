include(vcpkg_common_functions)

set(ICU_VERSION 61.1)
string(REPLACE "." "_" ICU_TAG ${ICU_VERSION})
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/icu)

# Get the source archive
vcpkg_download_distfile(ARCHIVE
    URLS "http://download.icu-project.org/files/icu4c/${ICU_VERSION}/icu4c-${ICU_TAG}-src.tgz"
    FILENAME "icu4c-${ICU_TAG}-src.tgz"
    SHA512 4c37691246db802e4bae0c8c5f6ac1dac64c5753b607e539c5c1c36e361fcd9dd81bd1d3b5416c2960153b83700ccdb356412847d0506ab7782ae626ac0ffb94
)
vcpkg_extract_source_archive(${ARCHIVE})

# Apply patches
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Check-U_HAVE_TZ-values.patch
        ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Use-__has_declspec_attribute.patch
        ${CMAKE_CURRENT_LIST_DIR}/patches/0003-genccode-crashes-when-creating-assembly-files.patch
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
    SOURCE_PATH ${SOURCE_PATH}
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
