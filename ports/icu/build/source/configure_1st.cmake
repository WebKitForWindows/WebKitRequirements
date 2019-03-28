# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

# In this configure file are set only this vars:
#
# PACKAGE
# VERSION VERSION_MAJOR VERSION_MINOR VERSION_PATCH VERSION_TWEAK
# LIB_VERSION LIB_VERSION_MAJOR
# UNICODE_VERSION


function(status_message msg)
  message(STATUS "${msg}")
endfunction()

function(error_message msg)
  if(ANDROID)
    # Duplicate a message to build with Gradle and CMake in server mode.
    message(STATUS "ERROR: ${msg}")
  endif()
  message(FATAL_ERROR "${msg}")
endfunction()

function(check_message msg var)
  if(var)
    set(res "yes")
  else()
    set(res "no")
  endif()
  message(STATUS "checking ${msg}  ${res}")
endfunction()

function(get_version_parts version out_MAJOR out_MINOR out_PATCH out_TWEAK)
  set(version_REGEX "^[0-9]+(\\.[0-9]+)?(\\.[0-9]+)?(\\.[0-9]+)?$")
  set(version_REGEX_1 "^[0-9]+$")
  set(version_REGEX_2 "^[0-9]+\\.[0-9]+$")
  set(version_REGEX_3 "^[0-9]+\\.[0-9]+\\.[0-9]+$")
  set(version_REGEX_4 "^[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+$")

  if(NOT version MATCHES ${version_REGEX})
    error_message("Problem parsing version string.")
  endif()

  if(version MATCHES ${version_REGEX_1})
    set(count 1)
  elseif(version MATCHES ${version_REGEX_2})
    set(count 2)
  elseif(version MATCHES ${version_REGEX_3})
    set(count 3)
  elseif(version MATCHES ${version_REGEX_4})
    set(count 4)
  endif()

  string(REGEX REPLACE "^([0-9]+)(\\.[0-9]+)?(\\.[0-9]+)?(\\.[0-9]+)?"
      "\\1" major "${version}")

  if(NOT count LESS 2)
    string(REGEX REPLACE "^[0-9]+\\.([0-9]+)(\\.[0-9]+)?(\\.[0-9]+)?"
        "\\1" minor "${version}")
  else()
    set(minor "0")
  endif()

  if(NOT count LESS 3)
    string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+)(\\.[0-9]+)?"
        "\\1" patch "${version}")
  else()
    set(patch "0")
  endif()

  if(NOT count LESS 4)
    string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.[0-9]+\\.([0-9]+)"
        "\\1" tweak "${version}")
  else()
    set(tweak "0")
  endif()

  set(${out_MAJOR} "${major}" PARENT_SCOPE)
  set(${out_MINOR} "${minor}" PARENT_SCOPE)
  set(${out_PATCH} "${patch}" PARENT_SCOPE)
  set(${out_TWEAK} "${tweak}" PARENT_SCOPE)
endfunction()

function(get_icu_version out_VERSION)
  set(src_FILE ${CMAKE_CURRENT_SOURCE_DIR}/common/unicode/uvernum.h)
  file(READ ${src_FILE} src_FILE_CONTENTS)
  string(
    REGEX MATCH "[ \t]*#[ \t]*define[ \t]+U_ICU_VERSION[ \t]+\"([^\"]*)\""
    version_str ${src_FILE_CONTENTS}
  )
  if(CMAKE_MATCH_COUNT EQUAL 1)
    set(${out_VERSION} ${CMAKE_MATCH_1} PARENT_SCOPE)
  endif()
endfunction()

function(get_unicode_version out_VERSION)
  set(src_FILE ${CMAKE_CURRENT_SOURCE_DIR}/common/unicode/uchar.h)
  file(READ ${src_FILE} src_FILE_CONTENTS)
  string(
    REGEX MATCH "[ \t]*#[ \t]*define[ \t]+U_UNICODE_VERSION[ \t]+\"([^\"]*)\""
    version_str ${src_FILE_CONTENTS}
  )
  if(CMAKE_MATCH_COUNT EQUAL 1)
    set(${out_VERSION} ${CMAKE_MATCH_1} PARENT_SCOPE)
  endif()
endfunction()


set(PACKAGE "icu")

status_message("for ICU version numbers")

get_icu_version(VERSION)
if(NOT VERSION)
  error_message(
    "Cannot determine ICU version number from uvernum.h header file"
  )
endif()

get_unicode_version(UNICODE_VERSION)
if(NOT UNICODE_VERSION)
  error_message(
    "Cannot determine Unicode version number from uchar.h header file"
  )
endif()

get_version_parts(${VERSION}
  VERSION_MAJOR VERSION_MINOR VERSION_PATCH VERSION_TWEAK
)

set(LIB_VERSION ${VERSION})
set(LIB_VERSION_MAJOR ${VERSION_MAJOR})

status_message(
  "release ${VERSION}, library ${LIB_VERSION}, unicode version ${UNICODE_VERSION}"
)
