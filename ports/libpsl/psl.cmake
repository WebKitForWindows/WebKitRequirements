# Download PSL file
# Up to date as of 2023-02-15
vcpkg_from_github(
    OUT_SOURCE_PATH PSL_SOURCE_PATH
    REPO publicsuffix/list
    REF a312abe0e11421aff8fe909a5e02f36b7c5d28de
    SHA512 7df608b7f34c80aea0b98e869dfa3c677b75c7661245d42cffec115a7ccd3016fd17fd9e3776f6dd0e45c11307344ce8d203c82a2b27b253c7befa99be05bcaa
    HEAD_REF master
)

file(INSTALL ${PSL_SOURCE_PATH}/public_suffix_list.dat DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl)
file(INSTALL ${PSL_SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright-psl)
