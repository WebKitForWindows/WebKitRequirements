### ICU build files for CMake build tools

In the ICU build files for CMake build tools are released most configure
options, compile and linker flags and others from the original ICU files:

 'configure.ac', '*/*.m4', '*/Makefile.in', 'icudefs.mk.in', 'config/mh-*',
 'data/pkgdataMakefile.in', 'data/makedata.mak', 'allinone/allinone.sln',
 'allinone/Build.Windows*.ProjectConfiguration.props', '*/*.vcxproj'

Unrealized options are marked with 'TODO' in CMake files.
Extras, samples and test building is not released.
Layoutex building is partially implemented, need to study the work with
the library icu-le-hb without pkg-config, only with CMake.

ICU data building from scratch ('files' mode) is not released.
Now ICU_DATA_PACKAGING can be 'archive', 'library', 'static' and 'auto'.
For iOS, Android and Microsoft Store (Windows Store) platforms is always 'auto'.

For more info see 'TODO' markers in CMake files.

ICU 58.2 and ICU 61.1 are supported.

For the CMake projects, the ICU library using is tested only in CONFIG mode
for find_package() command.

Building is tested on:
- Ubuntu 18.04 -- GCC 7.3.0, Clang 6.0.0;
- Windows 7 -- MSVC from Visual Studio 15 2017;
- Windows 7 -- MinGW-w64/w32, GCC 7.3.0,
               CMake generator "MinGW Makefiles"/"MSYS Makefiles";
- Android NDK 17.1.4828580 on Ubuntu 18.04.

Sample running is tested on:
- Ubuntu 18.04 -- GCC 7.3.0, Clang 6.0.0;
- Windows 7 -- MSVC from Visual Studio 15 2017;
- Windows 7 -- MinGW-w64/w32, GCC 7.3.0,
               CMake generator "MinGW Makefiles"/"MSYS Makefiles";
- Windows XP SP3 -- built on Windows 7, MSVC from Visual Studio 15 2017
                    with '-T v141_xp' toolset (ICU 58.2).

Static and shared, debug and release buildings are tested in these
configurations.

It works with the CMake 3.3 and higher.

For building with CMake copy the CMake files from 'icu/'
(and patched files from 'patches/icu-<version>/' for MSVC or MinGW)
to the ICU source tree and just run:

cd ./icu
mkdir ./build
cd ./build
cmake ../ \
 -DICU_ENABLE_EXTRAS=OFF \
 -DICU_ENABLE_SAMPLES=OFF \
 -DICU_ENABLE_TESTS=OFF \
 -DBUILD_SHARED_LIBS=ON \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_INSTALL_PREFIX=inst
cmake --build .

For building with Android NDK:

1. Build for host platform as mentioned above with
   ICU_ENABLE_TOOLS=ON (default).

2. Use the commands for Android building:

cd ./icu
mkdir ./build_android
cd ./build_android
cmake ../ \
 -DANDROID_HOME=/path/to/android-sdk-linux \
 -DANDROID_NDK=/path/to/android-sdk-linux/ndk-bundle \
 -DCMAKE_TOOLCHAIN_FILE=/path/to/android-sdk-linux/ndk-bundle/build/cmake/android.toolchain.cmake \
 -DANDROID_ABI=arm64-v8a \
 -DANDROID_NATIVE_API_LEVEL=24 \
 -DANDROID_TOOLCHAIN=clang \
 -DANDROID_STL=c++_static \
 "-DANDROID_CPP_FEATURES=rtti exceptions" \
 -DCMAKE_MAKE_PROGRAM=make \
 -DBUILD_SHARED_LIBS=ON \
 -DCMAKE_BUILD_TYPE=Release \
\
 -DICU_ENABLE_EXTRAS=OFF \
 -DICU_ENABLE_SAMPLES=OFF \
 -DICU_ENABLE_TESTS=OFF \
 -DICU_CROSS_COMPILING=ON \
 -DICU_CROSS_BUILDROOT="/<full path to the parent dir with the unpacked ICU sources>/icu/build/source" \
 -DCMAKE_INSTALL_PREFIX=inst

Available the next options (in the brackets are default values):

# Enable cross compiling.
ICU_CROSS_COMPILING      (OFF)
# Specify an absolute path to the build directory of an ICU built
# for the current platform.
ICU_CROSS_BUILDROOT      ("")
# Compile with strict compiler options.
ICU_ENABLE_STRICT        (ON)
# Enable auto cleanup of libraries.
ICU_ENABLE_AUTO_CLEANUP  (OFF)
# Enable draft APIs (and internal APIs).
ICU_ENABLE_DRAFT         (ON)
# Add a version suffix to symbols.
ICU_ENABLE_RENAMING      (ON)
# Enable function and data tracing.
ICU_ENABLE_TRACING       (OFF)
# Enable plugins.
ICU_ENABLE_PLUGINS       (OFF)
# Disable dynamic loading.
ICU_DISABLE_DYLOAD       (OFF)
# Use rpath when linking.
ICU_ENABLE_RPATH         (OFF)
# Build ICU extras.
ICU_ENABLE_EXTRAS        (ON) # TODO: not released, please set to OFF.
# Build ICU's icuio library.
ICU_ENABLE_ICUIO         (ON)
# Build ICU's Paragraph Layout library. The library 'icu-le-hb' must be
# available via find_package(icu-le-hb). See http://harfbuzz.org.
ICU_ENABLE_LAYOUTEX      (${HAVE_ICU_LE_HB}) # TODO: not released.
# The ICU Layout Engine has been removed.
ICU_ENABLE_LAYOUT        (OFF)
# Build ICU's tools.
ICU_ENABLE_TOOLS         (ON)
# Specify how to package ICU data.
# Possible values: files, archive, library, static, auto.
# See http://userguide.icu-project.org/icudata for more info.
ICU_DATA_PACKAGING       ("auto") # TODO: 'files' mode is not released.
# Tag a suffix to the library names.
ICU_LIBRARY_SUFFIX       ("")
# Build ICU tests.
ICU_ENABLE_TESTS         (ON) # TODO: not released, please set to OFF.
# Build ICU samples.
ICU_ENABLE_SAMPLES       (ON) # TODO: not released, please set to OFF.

The main idea belongs to Ruslan Baratov with Hunter package manager. Thanks.

See file 'LICENSE_CMakeLists' for license information.
