include(vcpkg_common_functions)

set(OPENJPEG_VERSION 2.3.1)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VERSION}.zip"
    FILENAME "openjpeg-${OPENJPEG_VERSION}.zip"
    SHA512 809cff67e34893ccc13e41383f1bb3bb1fd9640d8e0997d6ec16afbbd326c7c4436e93a2e16ee8ebb22052c88c3e5765b473905cdc4699b8ae21b0310ea48138
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${OPENJPEG_VERSION}
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
file(WRITE ${CURRENT_PACKAGES_DIR}/share/openjpeg/version ${OPENJPEG_VERSION})
