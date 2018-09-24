project(libpsl)
cmake_minimum_required(VERSION 3.7)

find_package(ICU 59.1 REQUIRED COMPONENTS uc)

string(REGEX MATCH "^[0-9]+" LIBPSL_VERSION_MAJOR "${LIBPSL_VERSION}")
string(REGEX MATCH "\\.[0-9]+\\." LIBPSL_VERSION_MINOR "${LIBPSL_VERSION}")
string(REGEX MATCH "[0-9]+$" LIBPSL_VERSION_PATCH "${LIBPSL_VERSION}")
string(REGEX REPLACE "\\." "" LIBPSL_VERSION_MINOR ${LIBPSL_VERSION_MINOR})
set(LIBPSL_VERSION_NUMBER "0x001402")

#config
include(GNUInstallDirs)
include(${CMAKE_SOURCE_DIR}/cmake/config_configure.cmake)

include_directories(${CMAKE_BINARY_DIR}/include)

include_directories(${ICU_INCLUDE_DIR})
list(APPEND LIBPSL_LIBS ${ICU_LIBRARIES})

include_directories(src)
add_subdirectory(src)

install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/include/libpsl.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
