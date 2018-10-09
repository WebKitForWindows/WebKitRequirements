# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

set(lib_NAME ${ICULIBS_LX})
set(lib_NAME_SUFFIX ${LAYOUTEX_STUBNAME})

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
  OUTPUT_NAME ${lib_NAME}${ICULIBSUFFIX_DEBUG}
)

### Common libraries options
include(${PROJECT_SOURCE_DIR}/common_icu_lib_flags.cmake)
include(${PROJECT_SOURCE_DIR}/common_icu_lib_includes.cmake)

### Library's specific flags
# PRIVATE flags
set_property(TARGET ${lib_NAME} APPEND PROPERTY
  COMPILE_DEFINITIONS
    U_LAYOUTEX_IMPLEMENTATION
)
set_property(TARGET ${lib_NAME} APPEND_STRING PROPERTY
  LINK_FLAGS ${LDFLAGSICULX}
)

### Include directories
# PRIVATE
target_include_directories(${lib_NAME} PRIVATE
  ${private_src_DIR}
  ${private_src_DIR}/unicode
  ${PROJECT_SOURCE_DIR}/common
)
if(NOT USING_ICULEHB)
  # cppflags: load .. so that #include <layout/...> works
  target_include_directories(${lib_NAME} PRIVATE
    ${PROJECT_SOURCE_DIR}
  )
else()
  target_include_directories(${lib_NAME} PRIVATE
    ${ICULEHB_CFLAGS} # TODO: check it
  )
endif()

### Link libraries
# PUBLIC
# LIBS = $(LIBICUUC) $(LIBICULE) $(DEFAULT_LIBS)
target_link_libraries(${lib_NAME} PUBLIC ${ICULIBS_UC} ${ICULIBS_LE})

include(${CMAKE_CURRENT_LIST_DIR}/ICU-${PROJECT_VERSION}-source_files.cmake)

install(
  DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/layout
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
