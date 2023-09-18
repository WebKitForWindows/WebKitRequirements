# Download PSL file
# Up to date as of 2023-09-18
vcpkg_from_github(
    OUT_SOURCE_PATH PSL_SOURCE_PATH
    REPO publicsuffix/list
    REF 1a4824549b093abc3077205ae5386ed57f73806d
    SHA512 2028d75c87f4f1b0827a5f42ae397c95390ee3b24a8971f396e622731bded21ead37ecfc47ca44a08486cb7a7ea35fa8d8e0b2612feec601e10cd6be697523c6
    HEAD_REF master
)

file(INSTALL ${PSL_SOURCE_PATH}/public_suffix_list.dat DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl)
file(INSTALL ${PSL_SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright-psl)
