# Download PSL file
# Up to date as of 2022-12-08
vcpkg_from_github(
    OUT_SOURCE_PATH PSL_SOURCE_PATH
    REPO publicsuffix/list
    REF 4aec132984ce028c5b9d7882a31a85e5e5330346
    SHA512 d1fe0bb9c8cc653304f231cb8eda9e3976079757dd1adf11f4226d6a7fdaf9aca6a8b9d404b01e1c1086f615ed387742bc449db663da3c1593c102e8adaa5189
    HEAD_REF master
)

file(INSTALL ${PSL_SOURCE_PATH}/public_suffix_list.dat DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl)
file(INSTALL ${PSL_SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright-psl)
