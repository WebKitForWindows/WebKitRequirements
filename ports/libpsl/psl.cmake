# Download PSL file
# Up to date as of 2023-10-26
vcpkg_from_github(
    OUT_SOURCE_PATH PSL_SOURCE_PATH
    REPO publicsuffix/list
    REF c4d36f90dbf4e7f80f976aef6f88ea102c622c1d
    SHA512 319b1cf018c0e57170fe1ab79e16894e26ce91894abbf5b64bfbdaf2a0b54822b8bfce31f6c4fec650d89e18234d70b7faca1619e507cee11409d6f84e0d74c7
    HEAD_REF master
)

file(INSTALL ${PSL_SOURCE_PATH}/public_suffix_list.dat DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl)
file(INSTALL ${PSL_SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright-psl)
