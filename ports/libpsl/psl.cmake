# Download PSL file
# Up to date as of 08-17-2020
vcpkg_from_github(
    OUT_SOURCE_PATH PSL_SOURCE_PATH
    REPO publicsuffix/list
    REF 529308c7668f67f2206628314d40d7eef0c2c261
    SHA512 af37a04df0a87c08fb32590a09b6ca70f54e3189033fc3ce80adcd8755b8719701bf0444ec3999e208ac83fa318cd8c94a13b74ec0d0032b7e698eb229a3730b
    HEAD_REF master
)

file(INSTALL ${PSL_SOURCE_PATH}/public_suffix_list.dat DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl)
file(INSTALL ${PSL_SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright-psl)
