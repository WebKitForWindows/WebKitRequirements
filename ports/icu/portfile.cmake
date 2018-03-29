include(vcpkg_common_functions)
include(${CMAKE_CURRENT_LIST_DIR}/vcpkg_acquire_icu_tools.cmake)

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

# Get ICU tools and append them to the current path
vcpkg_acquire_icu_tools(GENCCODE)
vcpkg_acquire_icu_tools(PKGDATA)
get_filename_component(ICU_TOOLS_PATH ${GENCCODE} DIRECTORY)
set(ENV{PATH} "$ENV{PATH};${ICU_TOOLS_PATH}")

# Add CMake sources
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/CMakeLists.txt DESTINATION ${SOURCE_PATH}/source)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/common/CMakeLists.txt DESTINATION ${SOURCE_PATH}/source/common)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/data/CMakeLists.txt DESTINATION ${SOURCE_PATH}/source/data)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/i18n/CMakeLists.txt DESTINATION ${SOURCE_PATH}/source/i18n)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/stubdata/CMakeLists.txt DESTINATION ${SOURCE_PATH}/source/stubdata)

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/source
    PREFER_NINJA
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/icu RENAME copyright)
