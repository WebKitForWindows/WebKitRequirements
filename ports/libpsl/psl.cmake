# Download PSL file
# Up to date as of 2024-08-13
vcpkg_from_github(
    OUT_SOURCE_PATH PSL_SOURCE_PATH
    REPO publicsuffix/list
    REF 6d6c3c973e73d1da8d1f2b9856e2e6d87c381cac
    SHA512 be0d200273b847878aa77c2a9699a0431a1e91b0a7af683aada95ca6dabf2106b4277113972e22ac8a03087af6017b2d29d1317d1eb87f71af079ee5265cadd7
    HEAD_REF master
)

file(INSTALL ${PSL_SOURCE_PATH}/public_suffix_list.dat DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl)
file(INSTALL ${PSL_SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright-psl)
