# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

set(exe_NAME pkgdata)

add_executable(${exe_NAME} "")

### Common executables options
include(${PROJECT_SOURCE_DIR}/common_tools_exe_flags.cmake)
include(${PROJECT_SOURCE_DIR}/common_tools_exe_libs.cmake)

### Executable's specifics

# TODO:
# PRIVATE flags
#set_property(TARGET ${lib_NAME} APPEND PROPERTY
#  COMPILE_DEFINITIONS
#  # DEFS += -DUDATA_SO_SUFFIX=\".$(SO)\" -DSTATIC_O=\"$(STATIC_O)\"
#  UDATA_SO_SUFFIX=\".$(SO)\"
#  STATIC_O=\"$(STATIC_O)\"
#)

### Include directories
# PRIVATE
target_include_directories(${exe_NAME} PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}
  ${PROJECT_SOURCE_DIR}/common
  ${PROJECT_SOURCE_DIR}/tools/toolutil
)

include(${CMAKE_CURRENT_LIST_DIR}/ICU-${PROJECT_VERSION}-source_files.cmake)

install(
  TARGETS ${exe_NAME}
  EXPORT "${TARGETS_EXPORT_NAME}"
  ARCHIVE  DESTINATION "${libdir}"
  LIBRARY  DESTINATION "${libdir}"
  RUNTIME  DESTINATION "${bindir}"
  INCLUDES DESTINATION "${includedir}"
)
