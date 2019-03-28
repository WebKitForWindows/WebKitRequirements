# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

target_sources(${exe_NAME}
  PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/genmbcs.cpp
    ${CMAKE_CURRENT_LIST_DIR}/makeconv.cpp
    ${CMAKE_CURRENT_LIST_DIR}/gencnvex.c
    ${CMAKE_CURRENT_LIST_DIR}/ucnvstat.c

  PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/genmbcs.h
    ${CMAKE_CURRENT_LIST_DIR}/makeconv.h
)
