# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
# Copyright (c) 2014, 2018, Ruslan Baratov. All rights reserved.
#
## ICU build file for CMake build tools

## ICU build files for CMake build tools are based on the original ICU files:
# 'configure.ac', '*/*.m4', '*/Makefile.in', 'icudefs.mk.in', 'config/mh-*',
# 'data/pkgdataMakefile.in', 'data/makedata.mak', 'allinone/allinone.sln',
# 'allinone/Build.Windows*.ProjectConfiguration.props', '*/*.vcxproj'


# TODO: check work ICU_CONDITIONAL()

# TODO: take additional compiler and link flags and link libs from mh-*
# TODO: THREADSC*FLAGS defined in mh-*
# TODO: take compiler flags and rules for Android from:
# https://android.googlesource.com/platform/external/icu/
# git clone https://android.googlesource.com/platform/external/icu

# TODO: Using the file "uconfig.h.prepend", see configure_2nd.cmake
# Flags from uconfig.h.prepend are used by INTERFACE_COMPILE_DEFINITIONS.


#############################################################################
# Configure CMake itself
#############################################################################


if(CMAKE_GENERATOR MATCHES "Visual Studio.*")
  message(STATUS "CMake 3.11+ is required for Visual Studio generator.")
  cmake_minimum_required(VERSION 3.11)
else()
  cmake_minimum_required(VERSION 3.4)
endif()

if(POLICY CMP0067)
  # Honor language standard in try_compile() source-file signature.
  # Introduced in CMake 3.8.
  cmake_policy(SET CMP0067 NEW)
endif()


#############################################################################
# Configure initialization
#############################################################################

set(ICUPREFIX "icu")  # before configure_1st.cmake
include(${CMAKE_CURRENT_LIST_DIR}/configure_1st.cmake)  # before project()
string(TOUPPER ${PACKAGE} PACKAGE_UPPER)

project(${PACKAGE_UPPER} VERSION ${VERSION} LANGUAGES C CXX ASM)

# Before configure_2nd.cmake
set(TARGETS_NAMESPACE "${PROJECT_NAME}::")
set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")

include(${CMAKE_CURRENT_LIST_DIR}/configure_2nd.cmake)  # after project()
include(${CMAKE_CURRENT_LIST_DIR}/icudefs.cmake)  # after configure_2nd.cmake

# After icudefs.cmake
list(INSERT CPPFLAGS 0 ${DEFS})

if(NOT BUILD_SHARED_LIBS)
  list(APPEND CPPFLAGS U_STATIC_IMPLEMENTATION)
endif()

# Location of the libraries before "make install" is used
# See also stubdata target properties.
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${LIBDIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${LIBDIR})

# Location of the executables before "make install" is used
# See also stubdata target properties.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BINDIR})

# RPATH settings
# https://cmake.org/Wiki/CMake_RPATH_handling
# https://gitlab.kitware.com/cmake/community/wikis/doc/cmake/RPATH-handling
if(ICU_ENABLE_RPATH)
  if(IOS)
    # TODO: iOS dynamic framework
  elseif(ANDROID)
    # *.so libraries loaded by Java code, RPATH will not be used
  elseif(UNIX)
    if(APPLE)
      # https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dyld.1.html
      set(CMAKE_INSTALL_RPATH "@executable_path/../${CMAKE_INSTALL_LIBDIR}")
    else()
      # https://linux.die.net/man/8/ld-linux
      set(CMAKE_INSTALL_RPATH "\$ORIGIN/../${CMAKE_INSTALL_LIBDIR}")
    endif()
  endif()
endif()

# Variables for CMake package configurations
set(config_PACKAGE_TEMPLATE "${CMAKE_CURRENT_LIST_DIR}/cmake/Config.in.cmake")
set(config_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/cmake")
set(config_INSTALL_DIR "share/cmake/icu")
set(config_PACKAGE "${config_BINARY_DIR}/${PROJECT_NAME}Config.cmake")
set(config_PACKAGE_VERSION
  "${config_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
)


#############################################################################
# Subdirectories
#############################################################################

# Subdirectories ordered by SUBDIRS in Makefile.in

include(${CMAKE_CURRENT_LIST_DIR}/stubdata/CMakeLists.txt)    # icudata (stubdata)
include(${CMAKE_CURRENT_LIST_DIR}/common/CMakeLists.txt)      # icuuc
include(${CMAKE_CURRENT_LIST_DIR}/i18n/CMakeLists.txt)        # icui18n
if(ICU_ENABLE_LAYOUTEX)
  include(${CMAKE_CURRENT_LIST_DIR}/layoutex/CMakeLists.txt)  # iculx
endif()
if(ICU_ENABLE_ICUIO)
  include(${CMAKE_CURRENT_LIST_DIR}/io/CMakeLists.txt)        # icuio
endif()
if(ICU_ENABLE_TOOLS)
  include(${CMAKE_CURRENT_LIST_DIR}/tools/CMakeLists.txt)
endif()
include(${CMAKE_CURRENT_LIST_DIR}/data/CMakeLists.txt)        # icudata (real data)
if(ICU_ENABLE_EXTRAS)
  #include(${CMAKE_CURRENT_LIST_DIR}/extra/CMakeLists.txt)     # uconv, ...
  error_message(
    "TODO: Building the EXTRAS is not yet supported. Please set ICU_ENABLE_EXTRAS=OFF"
  )
endif()
if(ICU_ENABLE_SAMPLES)
  #include(${CMAKE_CURRENT_LIST_DIR}/samples/CMakeLists.txt)
  error_message(
    "TODO: Building the SAMPLES is not yet supported. Please set ICU_ENABLE_SAMPLES=OFF"
  )
endif()
if(ICU_ENABLE_TESTS)
  #include(${CMAKE_CURRENT_LIST_DIR}/test/CMakeLists.txt)
  error_message(
    "TODO: Building the TESTS is not yet supported. Please set ICU_ENABLE_TESTS=OFF"
  )
endif()


#############################################################################
# Install CMake package configurations
#############################################################################

include(CMakePackageConfigHelpers)

# Use:
# * PROJECT_VERSION
write_basic_package_version_file(
  "${config_PACKAGE_VERSION}"
  COMPATIBILITY SameMajorVersion
)

# Use:
# * TARGETS_EXPORT_NAME
# * PROJECT_NAME
configure_package_config_file(
  "${config_PACKAGE_TEMPLATE}"
  "${config_PACKAGE}"
  PATH_VARS ICUPKGDATA_DIR
  INSTALL_DESTINATION "${config_INSTALL_DIR}"
)

install(
  FILES "${config_PACKAGE}" "${config_PACKAGE_VERSION}"
  DESTINATION "${config_INSTALL_DIR}"
)

install(
  EXPORT "${TARGETS_EXPORT_NAME}"
  NAMESPACE "${TARGETS_NAMESPACE}"
  DESTINATION "${config_INSTALL_DIR}"
)


#############################################################################
# For cross compilation
#############################################################################

# config/icucross.cmake:
# TODO: Use file(GENERATE ) to evaluate the CONFIG_DIR_NAME.
set(CROSS_BUILD_FILE ${PROJECT_BINARY_DIR}/config/icucross.cmake)
set(CROSS_BUILD_TEXT
  "
set(CROSS_ICU_VERSION ${VERSION})
set(TOOLBINDIR \${ICU_CROSS_BUILDROOT}/bin${CONFIG_DIR_NAME})
set(TOOLLIBDIR \${ICU_CROSS_BUILDROOT}/lib${CONFIG_DIR_NAME})
  "
)
file(WRITE ${CROSS_BUILD_FILE} ${CROSS_BUILD_TEXT})
