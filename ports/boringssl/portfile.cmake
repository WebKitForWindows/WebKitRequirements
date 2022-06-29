if (EXISTS "${CURRENT_INSTALLED_DIR}/include/openssl/ssl.h")
    message(FATAL_ERROR "Can't build BoringSSL if OpenSSL is installed. Please remove OpenSSL, and try to install BoringSSL again if you need it. Build will continue since BoringSSL is a drop-in replacement for OpenSSL")
endif()

# BoringSSL doesn't have releases so use the commit used by ngtcp2 to test
# https://github.com/ngtcp2/ngtcp2/blob/main/ci/build_boringssl.sh
set(VERSION 27ffcc6e19bbafddf1b59ec0bc6df2904de7eb2c)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Find-threading-library.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Make-gtest-library-static.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Make-building-tests-optional.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0004-Make-building-tools-optional.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0005-Add-install-targets.patch
    # Remove after 2022-06-12 version
    ${CMAKE_CURRENT_LIST_DIR}/patches/0006-Use-the-correct-function-types-in-X509V3_EXT_METHODs.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0007-Fix-build-with-MSVC-2022.patch
)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/boringssl
    REF ${VERSION}
    SHA512 b20b97c61a31861c4f210e90f7908f5bad5f5238c882ab14aa1d5e46e26aa4aa3cda3171e9e050f114fe453a040b7785eda5404189727db1835e5e2655b66c54
    PATCHES ${PATCHES}
)

# Install tools
vcpkg_find_acquire_program(PERL)
get_filename_component(PERL_EXE_PATH ${PERL} DIRECTORY)
vcpkg_add_to_path(${PERL_EXE_PATH})

vcpkg_find_acquire_program(NASM)
get_filename_component(NASM_EXE_PATH ${NASM} DIRECTORY)
vcpkg_add_to_path(${NASM_EXE_PATH})

vcpkg_find_acquire_program(GO)
get_filename_component(GO_EXE_PATH ${GO} DIRECTORY)
vcpkg_add_to_path(${GO_EXE_PATH})

if (tools IN_LIST FEATURES)
    set(ENABLE_TOOLS ON)
else ()
    set(ENABLE_TOOLS OFF)
endif ()

# Run CMake build
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DENABLE_TOOLS=${ENABLE_TOOLS}
    OPTIONS_DEBUG
        -DENABLE_TOOLS=OFF
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/boringssl RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/boringssl/version ${VERSION})
