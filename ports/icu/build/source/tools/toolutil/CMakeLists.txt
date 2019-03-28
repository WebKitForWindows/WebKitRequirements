# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

set(lib_NAME ${ICULIBS_TOOLUTIL})
set(lib_NAME_SUFFIX ${TOOLUTIL_STUBNAME})
set(lib_OUTPUT_NAME ${lib_NAME}${ICULIBSUFFIX_DEBUG})

if(NOT WIN32)
  set(lib_RUNTIME_OUTPUT_NAME ${lib_OUTPUT_NAME})
else()
  set(lib_RUNTIME_OUTPUT_NAME ${lib_NAME}${PROJECT_VERSION_MAJOR}${ICULIBSUFFIX_DEBUG})
endif()

add_library(${lib_NAME} "")

set_target_properties(${lib_NAME} PROPERTIES
  EXPORT_NAME ${lib_NAME_SUFFIX}
  OUTPUT_NAME ${lib_OUTPUT_NAME}
  RUNTIME_OUTPUT_NAME ${lib_RUNTIME_OUTPUT_NAME}
)

### Common libraries options
include(${PROJECT_SOURCE_DIR}/common_icu_lib_flags.cmake)
#include(${PROJECT_SOURCE_DIR}/common_icu_lib_includes.cmake)  # Not included.

### Library's specific flags
# PRIVATE flags
set_property(TARGET ${lib_NAME} APPEND PROPERTY
  COMPILE_DEFINITIONS
    U_TOOLUTIL_IMPLEMENTATION
    UNISTR_FROM_CHAR_EXPLICIT=explicit
    UNISTR_FROM_STRING_EXPLICIT=explicit

    # TODO:
    # from icuinfo
    #CPPFLAGS+=  "-DU_BUILD=\"@build@\"" "-DU_HOST=\"@host@\"" "-DU_CC=\"@CC@\"" "-DU_CXX=\"@CXX@\""
    #CPPFLAGS+=  "-DU_BUILD=\"x86_64-pc-linux-gnu\"" "-DU_HOST=\"x86_64-pc-linux-gnu\"" "-DU_CC=\"clang\"" "-DU_CXX=\"clang++\""
)
set_property(TARGET ${lib_NAME} APPEND_STRING PROPERTY
  LINK_FLAGS ${LDFLAGSICUTOOLUTIL}
)

### Include directories
# PRIVATE
target_include_directories(${lib_NAME} PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}
  ${PROJECT_SOURCE_DIR}/common
  ${PROJECT_SOURCE_DIR}/i18n
)

### Link libraries
# PUBLIC
# LIBS = $(LIBICUI18N) $(LIBICUUC) $(DEFAULT_LIBS)
target_link_libraries(${lib_NAME} PUBLIC ${ICULIBS_I18N})

include(${CMAKE_CURRENT_LIST_DIR}/ICU-${PROJECT_VERSION}-source_files.cmake)

install(
  TARGETS ${lib_NAME}
  EXPORT "${TARGETS_EXPORT_NAME}"
  ARCHIVE  DESTINATION "${libdir}"
  LIBRARY  DESTINATION "${libdir}"
  RUNTIME  DESTINATION "${bindir}"
  INCLUDES DESTINATION "${includedir}"
)
