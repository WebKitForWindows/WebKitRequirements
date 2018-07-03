# Patches for a port

A `vcpkg` file has support for applying patches to source code. This is useful
when there is a fix in the repository that has no associated release or for
modifying the repository to work with `vcpkg`.

By convention if a port requires changes to the source code any changes are put
into the `patches` directory. The filename contains a number specifying the
order the patches are applied and then the commit message. These are then
applied in the `portfile.cmake` after the source is extracted and before the
build is invoked.

```cmake
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/patches/0001-My-first-change.patch
        ${CMAKE_CURRENT_LIST_DIR}/patches/0002-My-second-change.patch
)
```

When a project does not contain a CMake build patch files should not be used
instead those files should be under the `build` directory and copied into the
build root.

## Cherry picking from GitHub

When a repository is in GitHub and a cherry pick is required this can be
done directly from the UI. URLs take the following form.

```shell
https://github.com/${org}/${repo}/${commit-sha}.patch
```

From there save the file into the `patches` directory keeping with the naming
conventions. Then add it to the list of applied patches.

## Manually creating patches

Check out the git repository for the project that is being patched. Make sure
that tags are also checked out. Then to create a branch on that tag run the
following command.

```shell
git checkout tags/<tag_name> -b patches
```

Then make the modifications necessary to the repository to get the `vcpkg`
build working as expected. Please ensure that there is an extended commit
message that explains why the change is necessary. Also try and order the
commits so ones that would not be accepted upstream are prior to ones that
could potentially be accepted.

When all the patches are ready run the following command to get a patchset
that can then be checked in.

```shell
git format-patch HEAD~<num_commints>
```
