set(VERSION 1.0.2)

# The woff2 library does not support shared libraries
vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

set(FILENAME "woff2-${VERSION}.zip")
set(URLS "https://github.com/google/woff2/archive/v${VERSION}.zip")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 4cb38d1daabe40cbede843c9338338590f1eed6843ba97f646a5abf8d64e814c5854561a8197157eeb267e252e316f67bef230afe4a2846cc734e0fdbd77de7e
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
vcpkg_fixup_pkgconfig()

# Copy tools
file(COPY ${CURRENT_PACKAGES_DIR}/bin/ DESTINATION ${CURRENT_PACKAGES_DIR}/tools/woff2)
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/woff2)

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/woff2 RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/woff2/version ${VERSION})
