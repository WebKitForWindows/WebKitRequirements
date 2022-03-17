# Download PSL file
# Up to date as of 2022-03-16
vcpkg_from_github(
    OUT_SOURCE_PATH PSL_SOURCE_PATH
    REPO publicsuffix/list
    REF c1f376165d9591ba47b8a01b11cbc5e3ffbd81b2
    SHA512 5b7698868ac4e3a06e4ad8d04b6cffbadd6234bbb79caca6e55dd0088248e6f6ad39b7115eb6a0c0c8fc06ca8b88fe485c0788fc9d49259e65f0cb8d0a24a6f1
    HEAD_REF master
)

file(INSTALL ${PSL_SOURCE_PATH}/public_suffix_list.dat DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl)
file(INSTALL ${PSL_SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright-psl)
