# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

target_sources(${lib_NAME}
  PRIVATE
    ${private_src_DIR}/datamap.cpp
    ${private_src_DIR}/testdata.cpp
    ${private_src_DIR}/tstdtmod.cpp
    ${private_src_DIR}/uperf.cpp
    ${private_src_DIR}/ctest.c
    ${private_src_DIR}/ucln_ct.c

  PUBLIC
    ${public_src_DIR}/unicode/ctest.h
    ${public_src_DIR}/unicode/datamap.h
    ${public_src_DIR}/unicode/testdata.h
    ${public_src_DIR}/unicode/testlog.h
    ${public_src_DIR}/unicode/testtype.h
    ${public_src_DIR}/unicode/tstdtmod.h
    ${public_src_DIR}/unicode/uperf.h
    ${public_src_DIR}/unicode/utimer.h
)
