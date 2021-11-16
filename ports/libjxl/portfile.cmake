set(VERSION 0.6.1)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/libjxl/libjxl/archive/v${VERSION}.zip"
    FILENAME "libjxl-${VERSION}.zip"
    SHA512 f19afcf9538d46a7410ce9f3b38ecf73e61fcbb0e2e565fce6f8fc62f1c99f5900f6b88705007262b6c55edebe5d7b62bd09e5a953424185facdaf4d128bf85a
)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-find-module-for-hwy.patch 
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Add-find-module-for-brotli.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Add-find-module-for-lcms.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0004-No-lodepng.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0005-Install-runtimes-in-bin.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0006-Remove-setting-of-CMAKE_FIND_LIBRARY_SUFFIXES.patch
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
