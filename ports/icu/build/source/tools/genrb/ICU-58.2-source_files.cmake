# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

  if(exe_NAME STREQUAL "genrb")
    target_sources(${exe_NAME}
      PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}/genrb.cpp
        ${CMAKE_CURRENT_LIST_DIR}/parse.cpp
        ${CMAKE_CURRENT_LIST_DIR}/prscmnts.cpp
        ${CMAKE_CURRENT_LIST_DIR}/reslist.cpp
        ${CMAKE_CURRENT_LIST_DIR}/wrtjava.cpp
        ${CMAKE_CURRENT_LIST_DIR}/wrtxml.cpp
        ${CMAKE_CURRENT_LIST_DIR}/errmsg.c
        ${CMAKE_CURRENT_LIST_DIR}/rbutil.c
        ${CMAKE_CURRENT_LIST_DIR}/read.c
        ${CMAKE_CURRENT_LIST_DIR}/rle.c
        ${CMAKE_CURRENT_LIST_DIR}/ustr.c

      PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}/errmsg.h
        ${CMAKE_CURRENT_LIST_DIR}/genrb.h
        ${CMAKE_CURRENT_LIST_DIR}/parse.h
        ${CMAKE_CURRENT_LIST_DIR}/prscmnts.h
        ${CMAKE_CURRENT_LIST_DIR}/rbutil.h
        ${CMAKE_CURRENT_LIST_DIR}/read.h
        ${CMAKE_CURRENT_LIST_DIR}/reslist.h
        ${CMAKE_CURRENT_LIST_DIR}/rle.h
        ${CMAKE_CURRENT_LIST_DIR}/ustr.h
    )
  endif()

  if(exe_NAME STREQUAL "derb")
    target_sources(${exe_NAME}
      PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}/derb.cpp
    )
  endif()
