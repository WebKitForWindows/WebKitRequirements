set(VERSION 0.8.1)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/libjxl/libjxl/archive/v${VERSION}.zip"
    FILENAME "libjxl-${VERSION}.zip"
    SHA512 05613f2223f7fdaebdfb56e05ec4c2f25b8998a6612900d10a34ea0b0cd023197739b0dbc217181299cfebf54c81d0f63aa26b0b5c9e1be37dd8100a897bc9d9
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
