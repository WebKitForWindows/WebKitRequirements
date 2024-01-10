set(VERSION 0.9.0)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/libjxl/libjxl/archive/v${VERSION}.zip"
    FILENAME "libjxl-${VERSION}.zip"
    SHA512 11bd32af4c420d90533a04ade4a3c70c5aa7c5d6c245eda515c72154329859c28efafd076860322fc3437df210b3b3962886d6df8763285201724a3dbd25cccd
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
