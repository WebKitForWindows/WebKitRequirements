cmake_minimum_required(VERSION 2.8.0)

set(CMAKE_CONFIGURATION_TYPES "Release;Debug;MinSizeRel;RelWithDebInfo")

include(GNUInstallDirs)

project(icu C CXX)

# OPTIONS

# CONFIGURE
include (CheckFunctionExists)
include (CheckIncludeFile)
include (CheckIncludeFiles)
include (CheckLibraryExists)
include (CheckSymbolExists)
include (CheckTypeSize)
include (CheckCSourceCompiles)
include (CMakeDependentOption)

#
# Embed ICU data to object file
#

set(ICU_VERSION 59)
set(ICUDATA_NAME icudt${ICU_VERSION})

file(TO_NATIVE_PATH ${CMAKE_CURRENT_LIST_DIR}/source/data/in/${ICUDATA_NAME}l.dat DATA_FILE)
set(DATA_ASM ${CMAKE_CURRENT_BINARY_DIR}/icudt.asm)
set(DATA_OBJ ${CMAKE_CURRENT_BINARY_DIR}/icudt.obj)
set(DATA_ENTRY __imp__${ICUDATA_NAME}_dat)

file(WRITE ${DATA_ASM}
  "section .data\n"
  "global ${DATA_ENTRY}\n"
  "\t${DATA_ENTRY}:\n"
  "\tincbin \"${DATA_FILE}\"\n"
)

if(NOT DEFINED NASM)
  set(NASM nasm CACHE FILEPATH "Path to NASM/YASM executable")
endif()

set(NAFLAGS -fwin64)

add_custom_command(OUTPUT ${DATA_OBJ}
    DEPENDS ${DATA_FILE}
    COMMAND ${NASM} ${NAFLAGS} ${DATA_ASM} -o${DATA_OBJ})

set_source_files_properties(${DATA_OBJ} PROPERTIES GENERATED 1)

#
# SET SOURCES
#

function(get_vcxproj_sources DIRNAME FILENAME OUTPUT)
  file(STRINGS ${DIRNAME}/${FILENAME} CONTENTS)
  foreach(line ${CONTENTS})
    if ("${line}" MATCHES "<ClCompile Include=\"(.*)\"")
      list(APPEND SOURCES ${DIRNAME}/${CMAKE_MATCH_1})
    endif()
  endforeach()
  set(${OUTPUT} ${SOURCES} PARENT_SCOPE)
endfunction()

get_vcxproj_sources("source/common" "common.vcxproj" ICUUC_SOURCES)
get_vcxproj_sources("source/i18n" "i18n.vcxproj" ICUI18N_SOURCES)

list(APPEND ICUUC_SOURCES ${DATA_OBJ})

#
# PUBLIC HEADERS
#

file(GLOB ICUUC_PUBLIC_HEADERS source/common/unicode/*.h)
file(GLOB ICUI18N_PUBLIC_HEADERS source/i18n/unicode/*.h)

#
# BUILD LIBRARIES
#

macro(add_shared_library NAME SOURCES)
  list(APPEND TARGETS ${NAME})
  add_library(${NAME} SHARED ${SOURCES})
  target_include_directories(${NAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
endmacro()

macro(add_static_library NAME SOURCES)
  list(APPEND TARGETS ${NAME}-static)
  add_library(${NAME}-static STATIC ${SOURCES})
  set_target_properties(${NAME}-static PROPERTIES OUTPUT_NAME ${NAME})
  target_include_directories(${NAME}-static PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
  if (MSVC)
    set_target_properties(${NAME}-static PROPERTIES PREFIX "lib")
  endif()
endmacro()

include_directories(
  source/common
  source/common/unicode
)

if (WIN32)
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
endif()

add_static_library(icuuc "${ICUUC_SOURCES}")
target_compile_definitions(icuuc-static PRIVATE U_STATIC_IMPLEMENTATION U_COMMON_IMPLEMENTATION)

add_static_library(icui18n "${ICUI18N_SOURCES}")
target_compile_definitions(icui18n-static PRIVATE U_STATIC_IMPLEMENTATION U_I18N_IMPLEMENTATION)

add_shared_library(icuuc "${ICUUC_SOURCES}")
target_compile_definitions(icuuc PRIVATE U_COMMON_IMPLEMENTATION)

add_shared_library(icui18n "${ICUI18N_SOURCES}")
target_compile_definitions(icui18n PRIVATE U_I18N_IMPLEMENTATION)
target_link_libraries(icui18n icuuc)


# INSTALL

install(
  TARGETS ${TARGETS}
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)

install(
  FILES
    ${ICUUC_PUBLIC_HEADERS}
    ${ICUI18N_PUBLIC_HEADERS}
  DESTINATION include/unicode
)

