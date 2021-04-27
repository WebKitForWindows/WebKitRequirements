set(VERSION 2.9.10)

# Get archive
vcpkg_download_distfile(ARCHIVE
    URLS "http://xmlsoft.org/sources/libxml2-${VERSION}.tar.gz"
    FILENAME "libxml2-${VERSION}.tar.gz"
    SHA512 0adfd12bfde89cbd6296ba6e66b6bed4edb814a74b4265bda34d95c41d9d92c696ee7adb0c737aaf9cc6e10426a31a35079b2a23d26c074e299858da12c072ed
)

# Patches
set(PATCHES
    # Remove CMake platform and ICU patch after next release
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Add-CMake-platform.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Adjust-CMake-for-vcpkg.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Fix-building-with-ICU-68.patch
)

# Extract archive
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${VERSION}
    PATCHES ${PATCHES}
)

# The xmlwin32version.h file is not in the archive
file(COPY ${CMAKE_CURRENT_LIST_DIR}/build/include/libxml/xmlwin32version.h.in DESTINATION ${SOURCE_PATH}/include/libxml)

# Run CMake build
set(BUILD_OPTIONS
    # Require ICU
    -DLIBXML2_WITH_ICU=ON

    # Turn off tests and programs
    -DLIBXML2_WITH_TESTS=OFF
    -DLIBXML2_WITH_PROGRAMS=OFF

    # Options
    -DLIBXML2_WITH_C14N=OFF
    -DLIBXML2_WITH_CATALOG=OFF
    -DLIBXML2_WITH_DEBUG=OFF
    -DLIBXML2_WITH_DOCB=OFF
    -DLIBXML2_WITH_FTP=OFF
    -DLIBXML2_WITH_HTTP=OFF
    -DLIBXML2_WITH_ICONV=OFF
    -DLIBXML2_WITH_ISO8859X=ON
    -DLIBXML2_WITH_LEGACY=OFF
    -DLIBXML2_WITH_LZMA=OFF
    -DLIBXML2_WITH_MEM_DEBUG=OFF
    -DLIBXML2_WITH_MODULES=OFF
    -DLIBXML2_WITH_OUTPUT=ON
    -DLIBXML2_WITH_PATTERN=OFF
    -DLIBXML2_WITH_PUSH=ON
    -DLIBXML2_WITH_PYTHON=OFF
    -DLIBXML2_WITH_READER=OFF
    -DLIBXML2_WITH_REGEXPS=ON
    -DLIBXML2_WITH_RUN_DEBUG=OFF
    -DLIBXML2_WITH_SAX1=ON
    -DLIBXML2_WITH_SCHEMAS=OFF
    -DLIBXML2_WITH_SCHEMATRON=OFF
    -DLIBXML2_WITH_THREADS=ON
    -DLIBXML2_WITH_THREAD_ALLOC=OFF
    -DLIBXML2_WITH_VALID=OFF
    -DLIBXML2_WITH_WRITER=OFF
    -DLIBXML2_WITH_XINCLUDE=OFF
    -DLIBXML2_WITH_XPTR=OFF
    -DLIBXML2_WITH_ZLIB=OFF
)

# libxslt requires certain features to be turned on
if (xslt IN_LIST FEATURES)
    list(APPEND BUILD_OPTIONS
        -DLIBXML2_WITH_HTML=ON
        -DLIBXML2_WITH_TREE=ON
        -DLIBXML2_WITH_XPATH=ON
    )
else ()
    list(APPEND BUILD_OPTIONS
        -DLIBXML2_WITH_HTML=OFF
        -DLIBXML2_WITH_TREE=OFF
        -DLIBXML2_WITH_XPATH=OFF
    )
endif ()

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

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libxml2 RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/libxml2/version ${VERSION})
