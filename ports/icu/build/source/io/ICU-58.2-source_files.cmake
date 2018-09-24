# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

target_sources(${lib_NAME}
  PRIVATE
    ${private_src_DIR}/locbund.cpp
    ${private_src_DIR}/sprintf.c
    ${private_src_DIR}/sscanf.c
    ${private_src_DIR}/ucln_io.cpp
    ${private_src_DIR}/ufile.c
    ${private_src_DIR}/ufmt_cmn.c
    ${private_src_DIR}/uprintf.cpp
    ${private_src_DIR}/uprntf_p.c
    ${private_src_DIR}/uscanf.c
    ${private_src_DIR}/uscanf_p.c
    ${private_src_DIR}/ustdio.c
    ${private_src_DIR}/ustream.cpp

  PRIVATE
    ${private_src_DIR}/locbund.h
    ${private_src_DIR}/ucln_io.h
    ${private_src_DIR}/ufile.h
    ${private_src_DIR}/ufmt_cmn.h
    ${private_src_DIR}/uprintf.h
    ${private_src_DIR}/uscanf.h

  PUBLIC
    ${public_src_DIR}/unicode/ustdio.h
    ${public_src_DIR}/unicode/ustream.h
)
