set(VERSION 0.15.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/google/highway/archive/refs/tags/${VERSION}.tar.gz"
    FILENAME "highway-${VERSION}.tar.gz"
    SHA512 ed07e855721f87ea67d762b30e001643a76bd16d70372415023c8e6f1a43c58759a14a638e8eb20566863d8358d994153bf7a660fcf604e808adfea5f938a013
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Only-run-hwy_list_targets-if-its-possible-to-do-so.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Set-RUNTIME_OUTPUT_DIRECTORY-for-test-executables.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Provide-individual-toggles-for-build-options.patch
    # Remove above in next release
    ${CMAKE_CURRENT_LIST_DIR}/patches/0004-Make-additional-libraries-optional.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# Run CMake build
set(BUILD_OPTIONS
    -DHWY_CONTRIB=OFF
    -DHWY_TEST=OFF

    -DHWY_ENABLE_EXAMPLES=OFF
    -DHWY_ENABLE_INSTALL=ON
    -DBUILD_TESTING=OFF
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS 
        ${BUILD_OPTIONS}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/highway RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/highway/version ${VERSION})
