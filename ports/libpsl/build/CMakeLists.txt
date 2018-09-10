project(libpsl)
cmake_minimum_required(VERSION 3.7)

find_package(ICU 56.1 REQUIRED COMPONENTS uc)

# TODO generate a config.h
if (ICU_FOUND)
    add_definitions(-DWITH_LIBICU=1)
    add_definitions(-DU_ICU_VERSION="6.1.1")
    add_definitions(-DPACKAGE_VERSION="")
endif()

if(0)
add_definitions(-DPSL_VERSION_NUMBER=0x001402)
add_definitions(-DPSL_VERSION_MAJOR=0)
add_definitions(-DPSL_VERSION_MINOR=20)
add_definitions(-DPSL_VERSION_PATCH=2)
else()
set(LIBPSL_VERSION_NUMBER 0x001402)
set(LIBPSL_VERSION_MAJOR 0)
set(LIBPSL_VERSION_MINOR 20)
set(LIBPSL_VERSION_PATCH 2)
endif()

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/include/libpsl.h.in ${CMAKE_CURRENT_BINARY_DIR}/include/libpsl.h)

include_directories(${CMAKE_BINARY_DIR}/include)

if (WIN32)
    set(LIBPSL_LIBS gdi32 msimg32 user32 winmm ws2_32)
endif()

include_directories(${ICU_INCLUDE_DIR})
list(APPEND LIBPSL_LIBS ${ICU_LIBRARIES})

include_directories(src)
add_subdirectory(src)

message("TEST ${CMAKE_INSTALL_INCLUDEDIR}")

# Install
install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/include/libpsl.h
  DESTINATION "include"
)