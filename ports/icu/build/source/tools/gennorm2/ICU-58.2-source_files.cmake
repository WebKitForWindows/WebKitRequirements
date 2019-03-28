# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

target_sources(${exe_NAME}
  PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/gennorm2.cpp
    ${CMAKE_CURRENT_LIST_DIR}/n2builder.cpp

  PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/n2builder.h
)
