set(VERSION 0.10.1)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/libjxl/libjxl/archive/v${VERSION}.zip"
    FILENAME "libjxl-${VERSION}.zip"
    SHA512 c106f1e02e2c6b1e9341ad116e90baa646bae5c1992779ee187d5dcb206f436cabe9686d81b5c17d0b7dfd0fce4b93c57bd3049fdee583a7d63b6e0d90a2325e
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
