# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

set(exe_NAME gentest)

add_executable(${exe_NAME} "")

### Common executables options
include(${PROJECT_SOURCE_DIR}/common_tools_exe_flags.cmake)
#include(${PROJECT_SOURCE_DIR}/common_tools_exe_libs.cmake) # Included below

### Executable's specifics

### Include directories
# PRIVATE
target_include_directories(${exe_NAME} PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}
  ${PROJECT_SOURCE_DIR}/common
  ${PROJECT_SOURCE_DIR}/tools/toolutil
  ${PROJECT_SOURCE_DIR}/tools/ctestfw
  ${PROJECT_SOURCE_DIR}/i18n
)

# LIBS = $(LIBCTESTFW) $(LIBICUTOOLUTIL) $(LIBICUI18N) $(LIBICUUC) $(DEFAULT_LIBS) $(LIB_M)
target_link_libraries(${exe_NAME} PRIVATE ${ICULIBS_CTESTFW})

# Common libs must be after the ${ICULIBS_CTESTFW}
include(${PROJECT_SOURCE_DIR}/common_tools_exe_libs.cmake)

include(${CMAKE_CURRENT_LIST_DIR}/ICU-${PROJECT_VERSION}-source_files.cmake)

install(
  TARGETS ${exe_NAME}
  EXPORT "${TARGETS_EXPORT_NAME}"
  ARCHIVE  DESTINATION "${libdir}"
  LIBRARY  DESTINATION "${libdir}"
  RUNTIME  DESTINATION "${bindir}"
  INCLUDES DESTINATION "${includedir}"
)
