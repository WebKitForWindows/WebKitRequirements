# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

target_sources(${lib_NAME}
  PRIVATE
    ${private_src_DIR}/LXUtilities.cpp
    ${private_src_DIR}/ParagraphLayout.cpp
    ${private_src_DIR}/playout.cpp
    ${private_src_DIR}/plruns.cpp
    ${private_src_DIR}/RunArrays.cpp

  PRIVATE
    ${private_src_DIR}/LXUtilities.h

  PUBLIC
    ${public_src_DIR}/layout/ParagraphLayout.h
    ${public_src_DIR}/layout/playout.h
    ${public_src_DIR}/layout/plruns.h
    ${public_src_DIR}/layout/RunArrays.h
)
