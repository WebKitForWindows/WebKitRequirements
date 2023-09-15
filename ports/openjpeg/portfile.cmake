set(VERSION 2.5.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/uclouvain/openjpeg/archive/v${VERSION}.zip"
    FILENAME "openjpeg-${VERSION}.zip"
    SHA512 8f0ce9cbb2f40cd03b7ab9f1686e5a055e53b5941478a1acb3f404f6555d1620a71a93ce7307e931e8820000757e751744f284009040e103b02c10907f8136f7
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
vcpkg_cmake_config_fixup()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/openjpeg RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/openjpeg/version ${VERSION})
