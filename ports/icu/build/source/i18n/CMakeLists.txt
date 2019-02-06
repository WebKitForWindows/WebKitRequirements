# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

set(lib_NAME ${ICULIBS_I18N})
set(lib_NAME_SUFFIX ${I18N_STUBNAME})
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
  COMPILE_DEFINITIONS ${CPPFLAGSICUI18N}
    U_I18N_IMPLEMENTATION
)
if(MSVC)
  if(WINDOWS_STORE)
    set_property(TARGET ${lib_NAME} APPEND PROPERTY
      COMPILE_DEFINITIONS U_PLATFORM_USES_ONLY_WIN32_API=1
    )
  endif()
endif()
if(MINGW AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
  set_property(TARGET ${lib_NAME} APPEND PROPERTY
    COMPILE_DEFINITIONS U_USE_STRTOD_L=0
  )
endif()
set_property(TARGET ${lib_NAME} APPEND_STRING PROPERTY
  LINK_FLAGS ${LDFLAGSICUI18N}
)

### Include directories
# PRIVATE
target_include_directories(${lib_NAME} PRIVATE
  ${private_src_DIR}
  ${PROJECT_SOURCE_DIR}/common
)

### Link libraries
# PUBLIC
# LIBS = $(LIBICUUC) $(DEFAULT_LIBS)
target_link_libraries(${lib_NAME} PUBLIC ${ICULIBS_UC})

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
