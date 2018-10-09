# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

set(lib_NAME ${ICULIBS_STUBDT})
#set(lib_NAME_SUFFIX ${DATA_STUBNAME})  # not STUBDATA_STUBNAME !!!

add_library(${lib_NAME} "")

set_target_properties(${lib_NAME} PROPERTIES
  EXPORT_NAME ${DATA_STUBNAME}  # not STUBDATA_STUBNAME !!!
  OUTPUT_NAME ${ICULIBS_DT}${ICULIBSUFFIX_DEBUG}  # not ICULIBS_STUBDT !!!

  ARCHIVE_OUTPUT_DIRECTORY ${LIBDIR}/${STUBDATA_STUBNAME}
  LIBRARY_OUTPUT_DIRECTORY ${LIBDIR}/${STUBDATA_STUBNAME}
  RUNTIME_OUTPUT_DIRECTORY ${BINDIR}/${STUBDATA_STUBNAME}
)

### Common libraries options
include(${PROJECT_SOURCE_DIR}/common_icu_lib_flags.cmake)
#include(${PROJECT_SOURCE_DIR}/common_icu_lib_includes.cmake)  # Not included.

### Library's specific flags
# PRIVATE flags
if(MSVC)
  set_property(TARGET ${lib_NAME} APPEND PROPERTY
    COMPILE_DEFINITIONS STUBDATA_BUILD
  )
endif()
set_property(TARGET ${lib_NAME} APPEND_STRING PROPERTY
  LINK_FLAGS ${LDFLAGSICUDT}
)

### Include directories
# PRIVATE
target_include_directories(${lib_NAME} PRIVATE
  ${PROJECT_SOURCE_DIR}/common
)

include(${CMAKE_CURRENT_LIST_DIR}/ICU-${PROJECT_VERSION}-source_files.cmake)

if(CMAKE_HOST_WIN32 AND BUILD_SHARED_LIBS AND (MSVC OR MINGW))
  add_custom_command(TARGET ${lib_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${BINDIR}${CONFIG_DIR_NAME}
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      $<TARGET_FILE:${lib_NAME}> ${BINDIR}${CONFIG_DIR_NAME}/
  )
endif()

if(PKGDATA_MODE STREQUAL "common")
  add_custom_command(TARGET ${lib_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${LIBDIR}${CONFIG_DIR_NAME}
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      $<TARGET_FILE:${lib_NAME}> ${LIBDIR}${CONFIG_DIR_NAME}/
  )

  install(
    TARGETS ${lib_NAME}
    EXPORT "${TARGETS_EXPORT_NAME}"
    ARCHIVE  DESTINATION "${libdir}"
    LIBRARY  DESTINATION "${libdir}"
    RUNTIME  DESTINATION "${bindir}"
    INCLUDES DESTINATION "${includedir}"
  )
endif()
