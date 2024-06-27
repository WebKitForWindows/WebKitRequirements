set(VERSION 0.10.3)

set(FILENAME "libjxl-${VERSION}.zip")
set(URLS "https://github.com/libjxl/libjxl/archive/v${VERSION}.zip")

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS ${URLS}
    FILENAME ${FILENAME}
    SHA512 fff18c24ac7856d1c55b0820afe22b6c3ed6a5609c5f5aa6ae94fd98d72a6442ae612ef05cc63d3ac66930a4981ff34497845c12ea74c844b65d767d643d6d9d
)

# Patches
set(PATCHES
    # Remove after next release
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Update-search-path-for-highway-version.patch
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
    -DJPEGXL_ENABLE_FUZZERS=OFF
    -DJPEGXL_ENABLE_DEVTOOLS=OFF
    -DJPEGXL_ENABLE_TOOLS=OFF
    -DJPEGXL_ENABLE_MANPAGES=OFF
    -DJPEGXL_ENABLE_BENCHMARK=OFF
    -DJPEGXL_ENABLE_EXAMPLES=OFF
    -DJPEGXL_ENABLE_JNI=OFF
    -DJPEGXL_ENABLE_SJPEG=OFF
    -DJPEGXL_ENABLE_OPENEXR=OFF
    -DJPEGXL_ENABLE_SKCMS=OFF
    -DJPEGXL_ENABLE_TCMALLOC=OFF

    -DJPEGXL_FORCE_SYSTEM_BROTLI=ON
    -DJPEGXL_FORCE_SYSTEM_HWY=ON
    -DJPEGXL_FORCE_SYSTEM_LCMS2=ON

    -DBUILD_TESTING=OFF
)

string(COMPARE EQUAL ${VCPKG_LIBRARY_LINKAGE} static JPEGXL_STATIC)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        ${BUILD_OPTIONS}
        -DJPEGXL_STATIC=${JPEGXL_STATIC}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libjxl RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libjxl/version ${VERSION})
