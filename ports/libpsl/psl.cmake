# Download PSL file
# Up to date as of 2020-03-30
vcpkg_from_github(
    OUT_SOURCE_PATH PSL_SOURCE_PATH
    REPO publicsuffix/list
    REF e4051df5af7d0c38b66cbc075205d5660feed7b2
    SHA512 c5e397a33d96d62077970874e23826ecefc4c17d7bbe9e83db49af43deccc6eda4cbb7b76212468a7235644af42f494bdbaaa6b9f9a86447fa61159050cee865
    HEAD_REF master
)

file(INSTALL ${PSL_SOURCE_PATH}/public_suffix_list.dat DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl)
file(INSTALL ${PSL_SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpsl RENAME copyright-psl)
