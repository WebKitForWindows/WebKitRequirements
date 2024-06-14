set(VERSION_MAJOR 1)
set(VERSION_MINOR 1)
set(VERSION_PATCH 40)
set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://download.gnome.org/sources/libxslt/${VERSION_MAJOR}.${VERSION_MINOR}/libxslt-${VERSION}.tar.xz"
    FILENAME "libxslt-${VERSION}.tar.xz"
    SHA512 5823dc8fbfe276a8fbdb1ee0d8b7924b0653b65101278db6cc7f6979c69df44f68d6b5b1ddaf753f6d8b353bc70ac65df5ab0d73e2230f996d99d018c53cb47f
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-ICU-build-option.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Add-tooling-build-option.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Remove-config-requirement-for-libxml2.patch
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
    -DLIBXSLT_WITH_MODULES=OFF
    -DLIBXSLT_WITH_PROFILER=OFF
    -DLIBXSLT_WITH_PYTHON=OFF
    -DLIBXSLT_WITH_TESTS=OFF
    -DLIBXSLT_WITH_TOOLS=OFF
    -DLIBXSLT_WITH_THREADS=OFF
    -DLIBXSLT_WITH_TRIO=OFF
    -DLIBXSLT_WITH_XSLT_DEBUG=OFF
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS ${BUILD_OPTIONS}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/libxslt-${VERSION})
vcpkg_fixup_pkgconfig()

# Fix the xslt-config
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/libxslt)
file(RENAME ${CURRENT_PACKAGES_DIR}/bin/xslt-config ${CURRENT_PACKAGES_DIR}/tools/libxslt/xslt-config)
vcpkg_replace_string(${CURRENT_PACKAGES_DIR}/tools/libxslt/xslt-config [[$(cd "$(dirname "$0")"; pwd -P)/..]] [[$(cd "$(dirname "$0")/../.."; pwd -P)]])

if (NOT VCPKG_BUILD_TYPE)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/libxslt/debug)
    file(RENAME ${CURRENT_PACKAGES_DIR}/debug/bin/xslt-config ${CURRENT_PACKAGES_DIR}/tools/libxslt/debug/xslt-config)
    vcpkg_replace_string(${CURRENT_PACKAGES_DIR}/tools/libxslt/debug/xslt-config [[$(cd "$(dirname "$0")"; pwd -P)/..]] [[$(cd "$(dirname "$0")/../../../debug"; pwd -P)]])
    vcpkg_replace_string(${CURRENT_PACKAGES_DIR}/tools/libxslt/debug/xslt-config [[${prefix}/include]] [[${prefix}/../include]])
endif()

# Modify headers for static builds
if (VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    vcpkg_replace_string(${CURRENT_PACKAGES_DIR}/include/libxslt/xsltexports.h "ifdef LIBXSLT_STATIC" "if 1")
    vcpkg_replace_string(${CURRENT_PACKAGES_DIR}/include/libexslt/exsltexports.h "ifdef LIBEXSLT_STATIC" "if 1")
endif()

# Prepare distribution
file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/xsltConf.sh)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/xsltConf.sh)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libxslt RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libxslt/version ${VERSION})

if (VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()
