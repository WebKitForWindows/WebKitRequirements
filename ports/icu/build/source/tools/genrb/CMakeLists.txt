# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

foreach(exe_NAME "genrb" "derb")
  if(exe_NAME STREQUAL "derb" AND NOT ICU_ENABLE_ICUIO)
    continue()
  endif()

  add_executable(${exe_NAME} "")

  ### Common executables options
  include(${PROJECT_SOURCE_DIR}/common_tools_exe_flags.cmake)
  #include(${PROJECT_SOURCE_DIR}/common_tools_exe_libs.cmake)  # Included below.

  ### Executable's specifics

  # PRIVATE flags
  set_property(TARGET ${exe_NAME} APPEND PROPERTY
    COMPILE_DEFINITIONS
      UNISTR_FROM_CHAR_EXPLICIT=explicit
      UNISTR_FROM_STRING_EXPLICIT=explicit
  )

  ### Include directories
  # PRIVATE
  target_include_directories(${exe_NAME} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}
    ${PROJECT_SOURCE_DIR}/common
    ${PROJECT_SOURCE_DIR}/i18n
    ${PROJECT_SOURCE_DIR}/tools/toolutil
    ${PROJECT_SOURCE_DIR}/io
  )

  ### Link libraries
  # PRIVATE
  if(exe_NAME STREQUAL "derb")
    # $(LIBICUIO) $(LIBS)
    target_link_libraries(${exe_NAME} PRIVATE ${ICULIBS_IO})
  endif()

  # Common libs must be after the ${ICULIBS_IO}
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
endforeach()
