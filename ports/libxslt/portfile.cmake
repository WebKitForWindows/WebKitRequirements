set(VERSION_MAJOR 1)
set(VERSION_MINOR 1)
set(VERSION_PATCH 37)
set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://download.gnome.org/sources/libxslt/${VERSION_MAJOR}.${VERSION_MINOR}/libxslt-${VERSION}.tar.xz"
    FILENAME "libxslt-${VERSION}.tar.xz"
    SHA512 a4e477d2bb918b7d01945e2c7491c3a4aae799dc1602bbd13de55c8a5052e210a20bc45115347eae44473c8b1d03dbc5e4a2aa18c2218f1fdfd376d87cd501ca
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Adjust-CMake-for-vcpkg.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Add-ICU-build-option.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Add-tooling-build-option.patch
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
    # Options
    -DLIBXSLT_WITH_CRYPTO=OFF
    -DLIBXSLT_WITH_DEBUGGER=OFF
    -DLIBXSLT_WITH_ICU=ON
    -DLIBXSLT_WITH_MEM_DEBUG=OFF
    -DLIBXSLT_WITH_MODULES=OFF
    -DLIBXSLT_WITH_PROFILER=OFF
    -DLIBXSLT_WITH_PYTHON=OFF
    -DLIBXSLT_WITH_TESTS=OFF
    -DLIBXSLT_WITH_TOOLS=OFF
    -DLIBXSLT_WITH_THREADS=OFF
    -DLIBXSLT_WITH_TRIO=OFF
    -DLIBXSLT_WITH_XSLT_DEBUG=OFF
)

# Disable parallel configure due to configure file writing back into the
# include directory
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS ${BUILD_OPTIONS}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE ${CURRENT_PACKAGES_DIR}/share/libxslt/xsltConf.sh)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libxslt RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libxslt/version ${VERSION})
