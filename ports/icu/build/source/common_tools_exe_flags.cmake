# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

### Common executables flags

# PRIVATE flags
set_property(TARGET ${exe_NAME} APPEND PROPERTY
  COMPILE_DEFINITIONS ${CPPFLAGS}
)
if(CPPFLAGS_DEBUG)
  set_property(TARGET ${exe_NAME} APPEND PROPERTY
    COMPILE_DEFINITIONS $<$<CONFIG:Debug>:${CPPFLAGS_DEBUG}>
  )
endif()
if(CPPFLAGS_RELEASE)
  set_property(TARGET ${exe_NAME} APPEND PROPERTY
    COMPILE_DEFINITIONS $<$<CONFIG:Release>:${CPPFLAGS_RELEASE}>
  )
endif()

set_property(TARGET ${exe_NAME} APPEND PROPERTY
  COMPILE_OPTIONS $<$<COMPILE_LANGUAGE:C>:${CFLAGS}>
)
if(CFLAGS_DEBUG)
  set_property(TARGET ${exe_NAME} APPEND PROPERTY
    COMPILE_OPTIONS $<$<AND:$<COMPILE_LANGUAGE:C>,$<CONFIG:Debug>>:${CFLAGS_DEBUG}>
  )
endif()
if(CFLAGS_RELEASE)
  set_property(TARGET ${exe_NAME} APPEND PROPERTY
    COMPILE_OPTIONS $<$<AND:$<COMPILE_LANGUAGE:C>,$<CONFIG:Release>>:${CFLAGS_RELEASE}>
  )
endif()

set_property(TARGET ${exe_NAME} APPEND PROPERTY
  COMPILE_OPTIONS $<$<COMPILE_LANGUAGE:CXX>:${CXXFLAGS}>
)
if(CXXFLAGS_DEBUG)
  set_property(TARGET ${exe_NAME} APPEND PROPERTY
    COMPILE_OPTIONS $<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CONFIG:Debug>>:${CXXFLAGS_DEBUG}>
  )
endif()
if(CXXFLAGS_RELEASE)
  set_property(TARGET ${exe_NAME} APPEND PROPERTY
    COMPILE_OPTIONS $<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CONFIG:Release>>:${CXXFLAGS_RELEASE}>
  )
endif()

set_property(TARGET ${exe_NAME} APPEND_STRING PROPERTY
  LINK_FLAGS ${LDFLAGS}
)
if(LDFLAGS_DEBUG)
  set_property(TARGET ${exe_NAME} APPEND_STRING PROPERTY
    LINK_FLAGS_DEBUG ${LDFLAGS_DEBUG}
  )
endif()
if(LDFLAGS_RELEASE)
  set_property(TARGET ${exe_NAME} APPEND_STRING PROPERTY
    LINK_FLAGS_RELEASE ${LDFLAGS_RELEASE}
  )
endif()
