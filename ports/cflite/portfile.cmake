include(vcpkg_common_functions)

set(VERSION 0.0.2)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/fujii/OpenCFLite/archive/v${VERSION}.zip"
    FILENAME "OpenCFLite-${VERSION}.zip"
    SHA512 6655025baf720096841b7d9f537cc62e6ff42a953e0ca6a2788c61d1192186257a249e4550ec28b44cf5752baac1fb83b72a66226425af7d3153f7371c0412d3
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

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
file(WRITE ${CURRENT_PACKAGES_DIR}/share/cflite/version ${VERSION})
