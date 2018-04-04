include(vcpkg_common_functions)

set(CFLITE_VERSION 0.0.2)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/OpenCFLite-${CFLITE_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/fujii/OpenCFLite/archive/v${CFLITE_VERSION}.zip"
    FILENAME "OpenCFLite-${CFLITE_VERSION}.zip"
    SHA512 6655025baf720096841b7d9f537cc62e6ff42a953e0ca6a2788c61d1192186257a249e4550ec28b44cf5752baac1fb83b72a66226425af7d3153f7371c0412d3
)
vcpkg_extract_source_archive(${ARCHIVE})

# Run CMake build

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/APPLE_LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/cflite RENAME copyright)
