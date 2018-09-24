# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

# Subdirectories ordered by SUBDIRS in Makefile.in

# Libraries
include(${CMAKE_CURRENT_LIST_DIR}/toolutil/CMakeLists.txt)     # lib  # before pkgdata
include(${CMAKE_CURRENT_LIST_DIR}/ctestfw/CMakeLists.txt)      # lib

# Executables
include(${CMAKE_CURRENT_LIST_DIR}/makeconv/CMakeLists.txt)     # exe
include(${CMAKE_CURRENT_LIST_DIR}/genrb/CMakeLists.txt)        # exe
include(${CMAKE_CURRENT_LIST_DIR}/genbrk/CMakeLists.txt)       # exe
include(${CMAKE_CURRENT_LIST_DIR}/gencnval/CMakeLists.txt)     # exe
include(${CMAKE_CURRENT_LIST_DIR}/gensprep/CMakeLists.txt)     # exe
include(${CMAKE_CURRENT_LIST_DIR}/icuinfo/CMakeLists.txt)      # exe + TODO: lib
include(${CMAKE_CURRENT_LIST_DIR}/genccode/CMakeLists.txt)     # exe
include(${CMAKE_CURRENT_LIST_DIR}/gencmn/CMakeLists.txt)       # exe
include(${CMAKE_CURRENT_LIST_DIR}/icupkg/CMakeLists.txt)       # exe
include(${CMAKE_CURRENT_LIST_DIR}/pkgdata/CMakeLists.txt)      # exe
include(${CMAKE_CURRENT_LIST_DIR}/gentest/CMakeLists.txt)      # exe
include(${CMAKE_CURRENT_LIST_DIR}/gennorm2/CMakeLists.txt)     # exe
include(${CMAKE_CURRENT_LIST_DIR}/gencfu/CMakeLists.txt)       # exe
include(${CMAKE_CURRENT_LIST_DIR}/gendict/CMakeLists.txt)      # exe

if(PROJECT_VERSION VERSION_GREATER 58.9)
  #ifneq (@platform_make_fragment_name@,mh-cygwin-msvc)
  if(NOT MSVC)
    include(${CMAKE_CURRENT_LIST_DIR}/escapesrc/CMakeLists.txt)  # exe
  endif()
endif()

# Excluded in SUBDIRS in Makefile.in
#include(${CMAKE_CURRENT_LIST_DIR}/gencolusb/CMakeLists.txt)
#include(${CMAKE_CURRENT_LIST_DIR}/genren/CMakeLists.txt)
#include(${CMAKE_CURRENT_LIST_DIR}/icuswap/CMakeLists.txt)
#include(${CMAKE_CURRENT_LIST_DIR}/memcheck/CMakeLists.txt)
#include(${CMAKE_CURRENT_LIST_DIR}/tzcode/CMakeLists.txt)
