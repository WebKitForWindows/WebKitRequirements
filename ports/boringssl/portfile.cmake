if (EXISTS "${CURRENT_INSTALLED_DIR}/include/openssl/ssl.h")
    message(FATAL_ERROR "Can't build BoringSSL if OpenSSL is installed. Please remove OpenSSL, and try to install BoringSSL again if you need it. Build will continue since BoringSSL is a drop-in replacement for OpenSSL")
endif()

# BoringSSL doesn't have releases so use the commit used by ngtcp2 to test
# https://github.com/ngtcp2/ngtcp2/blob/main/ci/build_boringssl.sh
set(VERSION a6d321b11fa80496b7c8ae6405468c212d4f5c87)

# Patches
set(PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/patches/0001-Find-threading-library.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0002-Specify-all-library-install-destinations.patch
    # Remove above after https://boringssl-review.googlesource.com/c/boringssl/+/54147 lands
    ${CMAKE_CURRENT_LIST_DIR}/patches/0003-Make-gtest-library-static.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0004-Adjust-CMake-for-vcpkg.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0005-Make-building-tests-optional.patch
    ${CMAKE_CURRENT_LIST_DIR}/patches/0006-Make-building-tools-optional.patch
)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/boringssl
    REF ${VERSION}
    SHA512 753367f9cbee873c091b76a47860d02003bd9430ce02abc478c02b5ee8dd687353fb0a91e7bb32a949a28830479d1ce7a4ffdb1a37a339e615ee2b2fcb6fba86
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

if (tools IN_LIST FEATURES)
    vcpkg_copy_tools(TOOL_NAMES bssl AUTO_CLEAN)
endif()

# Prepare distribution
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/boringssl RENAME copyright)
file(WRITE ${CURRENT_PACKAGES_DIR}/share/boringssl/version ${VERSION})
