# Creating a release

The WinCairoRequirements repository uses GitHub releases to host a distribution
which are then downloaded by scripts contained in the WebKit repository. By
default the latest release will be downloaded when doing a WebKit build. Each
release corresponds to a tag within the git repository.

## Tag names

Tags are done based on the date of creation of the distribution. This is done
because the third party requirements change sporadically and semantic
versioning does not fit with the distribution. This provides a clear timeline
on when the requirements changed.

## Creating the tag

To create the tag have the commit that is being released checked out locally.
From there run the following commands where YYYY.MM.DD corresponds to the year
month and day the tag is created.

```
git tag -a vYYYY.MM.DD -m "vYYYY.MM.DD"
git push origin vYYYY.MM.DD
```

Once the tag is pushed a release can be created within GitHub.

## Continuous Integration

The WinCairoRequirements repository uses [Drone](https://drone.io) to build the
release when a tag is pushed. It will create a GitHub release associated with
the tag and create the distribution for 32 and 64-bit WinCairo builds.

# Manually creating a distribution

The repository contains a number of scripts to create a distribution. These are
used to build locally consistently.

All the scripts take a `triplet` value which specifies the toolchain. By
default the `x64-windows-webkit` toolchain is used. For building 
WinCairoRequirements two toolchain files were created because there are some
libraries that need to be built statically even when a dynamic build is wanted.
Only the `x64-windows-webkit` toolchain is supported at this time.

## Install script

The `Install-Requirements.ps1` script is a wrapper around `vcpkg` which will
invoke `vcpkg install` with a list of requirements. The requirements are
defined in a .json file which is nothing more than a list of port names.

## Renaming bin/lib

The WebKit Windows port assumes that the bin and lib directory both contain a
suffix for whether it is a 64-bit or 32-bit build. The
`Rename-WithBitSuffix.ps1` script will rename according to the triplet passed
in.

## Creating the zip

The `Package-Requirements.ps1` script creates a zip file containing the
dependencies. If a different filename is required then set the `-Output` flag
accordingly.

## Command listing

```
& Install-Requirements.ps1

# TODO Remove cflite from distribution
.\vcpkg.exe install cflite --triplet x64-windows-webkit

& Rename-WithBitSuffix.ps1
& Delete-PthreadHeaders.ps1

& Package-Requirements.ps1
```
