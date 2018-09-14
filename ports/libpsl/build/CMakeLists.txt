project(libpsl)
cmake_minimum_required(VERSION 3.7)

find_package(ICU 56.1 REQUIRED COMPONENTS uc)

if (ICU_FOUND)
    set(WITH_LIBICU 1)
    set(BUILTIN_GENERATOR_LIBICU 1) 
endif()

string(REGEX MATCH "^[0-9]+" LIBPSL_VERSION_MAJOR "${LIBPSL_VERSION}")
string(REGEX MATCH "\\.[0-9]+\\." LIBPSL_VERSION_MINOR "${LIBPSL_VERSION}")
string(REGEX MATCH "[0-9]+$" LIBPSL_VERSION_PATCH "${LIBPSL_VERSION}")
string(REGEX REPLACE "\\." "" LIBPSL_VERSION_MINOR ${LIBPSL_VERSION_MINOR})

add_definitions(-DHAVE_CONFIG_H=1)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/include/libpsl.h.in ${CMAKE_CURRENT_BINARY_DIR}/include/libpsl.h)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/src/config.h)

include_directories(${CMAKE_BINARY_DIR}/include)

if (WIN32)
    set(LIBPSL_LIBS gdi32 msimg32 user32 winmm ws2_32)
    add_definitions(-Dalloca=_alloca)
endif()

include_directories(${ICU_INCLUDE_DIR})
list(APPEND LIBPSL_LIBS ${ICU_LIBRARIES})

include_directories(src)
add_subdirectory(src)

install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/include/libpsl.h
  DESTINATION "include"
)

include(${CMAKE_SOURCE_DIR}/cmake/cmake_package.cmake)
