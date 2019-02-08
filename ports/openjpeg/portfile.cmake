include(vcpkg_common_functions)

set(OPENJPEG_VERSION 2.3.0)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/openjpeg-${OPENJPEG_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VERSION}.zip"
    FILENAME "openjpeg-${OPENJPEG_VERSION}.zip"
    SHA512 d753479cc26ce6a3cf98daa50cd79825cb81afa819bfb94d9453583bd1b92f1480093cfa57b93cba26414047f198041311eef2dd112e3e0e898e33862276c38f
)
vcpkg_extract_source_archive(${ARCHIVE})

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
