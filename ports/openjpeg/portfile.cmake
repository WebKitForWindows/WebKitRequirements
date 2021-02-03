set(VERSION 2.4.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/uclouvain/openjpeg/archive/v${VERSION}.zip"
    FILENAME "openjpeg-${VERSION}.zip"
    SHA512 afddc0a9cdcb74c71e3f369375064b80d8065ca24fb0f381dcf57de1bc6fbb7cd703c4374c386089ba53d8df66c076de2e2b9450ebba8af49fa19c9f2d3459e7
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
    OPTIONS
        -DBUILD_CODEC=OFF
        -DBUILD_PKGCONFIG_FILES=OFF
        # Do not build static and shared libraries
        # Internally OpenJPEG respects BUILD_SHARED_LIBS
        -DBUILD_STATIC_LIBS=OFF
        # Match the vcpkg expectation
        -DOPENJPEG_INSTALL_PACKAGE_DIR=share/openjpeg
        # If this is not set then it installs into include/openjpge-<major>-<minor>
        -DOPENJPEG_INSTALL_INCLUDE_DIR=include
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/openjpeg RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/openjpeg/version ${VERSION})
