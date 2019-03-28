# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

# TODO: PLUGIN_OBJECTS = testplug.o

target_sources(${exe_NAME}
  PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/icuinfo.cpp
)

if(ICU_ENABLE_PLUGINS)
  # TODO: PLUGIN_OBJECTS = testplug.o
  # TODO: see source/tools/genrb/CMakeLists.txt with foreach()
  #target_sources(${exe_NAME}
  #PRIVATE
  #  ${CMAKE_CURRENT_LIST_DIR}/testplug.c
  #)
endif()
