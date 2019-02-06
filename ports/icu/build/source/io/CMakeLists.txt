# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

set(lib_NAME ${ICULIBS_IO})
set(lib_NAME_SUFFIX ${IO_STUBNAME})
set(lib_OUTPUT_NAME ${lib_NAME}${ICULIBSUFFIX_DEBUG})

if(NOT WIN32)
  set(lib_RUNTIME_OUTPUT_NAME ${lib_OUTPUT_NAME})
else()
  set(lib_RUNTIME_OUTPUT_NAME ${lib_NAME}${PROJECT_VERSION_MAJOR}${ICULIBSUFFIX_DEBUG})
endif()

set(private_src_DIR "${CMAKE_CURRENT_LIST_DIR}")
set(interface_src_DIR "${includedir}")
set(build_src_DIR
  "$<BUILD_INTERFACE:${private_src_DIR}>"
)
set(install_src_DIR
  "$<INSTALL_INTERFACE:${interface_src_DIR}>"
)
set(public_src_DIR "${build_src_DIR}${install_src_DIR}")

add_library(${lib_NAME} "")

set_target_properties(${lib_NAME} PROPERTIES
  EXPORT_NAME ${lib_NAME_SUFFIX}
  OUTPUT_NAME ${lib_OUTPUT_NAME}
  RUNTIME_OUTPUT_NAME ${lib_RUNTIME_OUTPUT_NAME}
)

### Common libraries options
include(${PROJECT_SOURCE_DIR}/common_icu_lib_flags.cmake)
include(${PROJECT_SOURCE_DIR}/common_icu_lib_includes.cmake)

### Library's specific flags
# PRIVATE flags
set_property(TARGET ${lib_NAME} APPEND PROPERTY
  COMPILE_DEFINITIONS ${CPPFLAGSICUIO}
    U_IO_IMPLEMENTATION
)
set_property(TARGET ${lib_NAME} APPEND_STRING PROPERTY
  LINK_FLAGS ${LDFLAGSICUIO}
)

### Include directories
# PRIVATE
target_include_directories(${lib_NAME} PRIVATE
  ${private_src_DIR}
  ${PROJECT_SOURCE_DIR}/common
  ${PROJECT_SOURCE_DIR}/i18n
)

### Link libraries
# PUBLIC
# LIBS = $(LIBICUUC) $(LIBICUI18N) $(DEFAULT_LIBS)
target_link_libraries(${lib_NAME} PUBLIC ${ICULIBS_I18N})

include(${CMAKE_CURRENT_LIST_DIR}/ICU-${PROJECT_VERSION}-source_files.cmake)

install(
  DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/unicode
  DESTINATION "${includedir}"
  FILES_MATCHING
  PATTERN "*.h"
)

install(
  TARGETS ${lib_NAME}
  EXPORT "${TARGETS_EXPORT_NAME}"
  ARCHIVE  DESTINATION "${libdir}"
  LIBRARY  DESTINATION "${libdir}"
  RUNTIME  DESTINATION "${bindir}"
  INCLUDES DESTINATION "${includedir}"
)
