# Download PSL file
# Up to date as of 04-15-2019
vcpkg_from_github(
    OUT_SOURCE_PATH PSL_SOURCE_PATH
    REPO publicsuffix/list
    REF 033221af7f600bcfce38dcbfafe03b9a2269c4cc
    SHA512 268a442bec50531d66ca824e85242b705d50f4cbfe205ff81c9207cb6fc166ca36867201192e444b3766fea26c047d045af18aaad4df4d92219ba1608e6e2d6a
    HEAD_REF master
)

file(INSTALL ${PSL_SOURCE_PATH}/public_suffix_list.dat DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl)
file(INSTALL ${PSL_SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright-psl)
