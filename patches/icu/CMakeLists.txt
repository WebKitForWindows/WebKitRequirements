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

file(TO_NATIVE_PATH ${CMAKE_CURRENT_LIST_DIR}/source/data/in/${ICUDATA_NAME}l.dat ICUDATA_FILE)
set(ICUDATA_ASM ${CMAKE_CURRENT_BINARY_DIR}/icudt.asm)
set(ICUDATA_OBJ ${CMAKE_CURRENT_BINARY_DIR}/icudt.obj)
set(ICUDATA_STUB ${CMAKE_CURRENT_BINARY_DIR}/icudt_stub.c)
set(ICUDATA_ENTRY _${ICUDATA_NAME}_dat)

file(WRITE ${ICUDATA_ASM}
  "section .rdata rdata align=32\n"
  "global ${ICUDATA_ENTRY}\n"
  "\t${ICUDATA_ENTRY}:\n"
  "\tincbin \"${ICUDATA_FILE}\"\n"
)

file(WRITE ${ICUDATA_STUB}
  "#include \"unicode/utypes.h\"\n"
  "#include \"unicode/udata.h\"\n"
  "#include \"unicode/uversion.h\"\n"
  "U_EXPORT void* U_ICUDATA_ENTRY_POINT;\n"
)

if(NOT DEFINED NASM)
  set(NASM nasm CACHE FILEPATH "Path to NASM/YASM executable")
endif()

set(NAFLAGS -fwin64)

add_custom_command(OUTPUT ${ICUDATA_OBJ}
    DEPENDS ${ICUDATA_FILE}
    COMMAND ${NASM} ${NAFLAGS} ${ICUDATA_ASM} -o${ICUDATA_OBJ})

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

if (MSVC)
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
endif()

if (FALSE)
add_static_library(icudt ${ICUDATA_OBJ})
SET_TARGET_PROPERTIES(icudt-static PROPERTIES LINKER_LANGUAGE C)

add_static_library(icuuc "${ICUUC_SOURCES}")
target_compile_definitions(icuuc-static PRIVATE U_STATIC_IMPLEMENTATION U_COMMON_IMPLEMENTATION)

add_static_library(icui18n "${ICUI18N_SOURCES}")
target_compile_definitions(icui18n-static PRIVATE U_STATIC_IMPLEMENTATION U_I18N_IMPLEMENTATION)
endif()

add_shared_library(icudt "${ICUDATA_OBJ};${ICUDATA_STUB}")
SET_TARGET_PROPERTIES(icudt PROPERTIES LINKER_LANGUAGE C)
if(MSVC)
  SET_TARGET_PROPERTIES(icudt PROPERTIES LINK_FLAGS "/NOENTRY")
endif()

add_shared_library(icuuc "${ICUUC_SOURCES}")
target_compile_definitions(icuuc PRIVATE U_COMMON_IMPLEMENTATION)
target_link_libraries(icuuc icudt)

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
