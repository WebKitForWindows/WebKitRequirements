# Simplified libxslt CMake file
#
# This CMake implementation just does the minimum to build 
# WinCairoRequirements and does not handle all the things possible when using
# the Makefile directly.
#
# Features missing:
#   - Tests are not built
#   - No support for iconv
#   - Only building libxslt not libexslt or anything further

cmake_minimum_required(VERSION 3.7)

project(xml2)

set(VERSION 1.1.32)
set(LIBXSLT_VERSION_NUMBER 10132)

option(WITH_TRIO "Enable TRIO string manipulator" OFF)
option(WITH_XSLT_DEBUG "Enable XSLT debbugging module" ON)
option(WITH_MEM_DEBUG "Enable memory debugger" OFF)
option(WITH_DEBUGGER "Enable external debugger support" ON)
option(WITH_ICONV "Use iconv library" ON)
option(WITH_ZLIB "Use zlib library" OFF)
option(WITH_CRYPTO "Enable Crypto support" ON)
option(WITH_MODULES "Enable Module support" OFF)

configure_file(
  ${CMAKE_SOURCE_DIR}/libxslt/xsltconfig.h.cmake.in
  ${CMAKE_SOURCE_DIR}/libxslt/xsltconfig.h
  @ONLY
)

set(LIBXSLT_SOURCES
  libxslt/attributes.c
  libxslt/attrvt.c
  libxslt/documents.c
  libxslt/extensions.c
  libxslt/extra.c
  libxslt/functions.c
  libxslt/imports.c
  libxslt/keys.c
  libxslt/namespaces.c
  libxslt/numbers.c
  libxslt/pattern.c
  libxslt/preproc.c
  libxslt/security.c
  libxslt/templates.c
  libxslt/transform.c
  libxslt/variables.c
  libxslt/xslt.c
  libxslt/xsltlocale.c
  libxslt/xsltutils.c
)

find_package(LibXML2 2.9.7 REQUIRED)

set(LIBXSLT_INCLUDE_DIRS
  ${CMAKE_SOURCE_DIR}
  ${CMAKE_SOURCE_DIR}/libxslt
  ${LIBXML2_INCLUDE_DIR}
)

include_directories(${LIBXSLT_INCLUDE_DIRS})

add_library(xslt ${LIBXSLT_SOURCES})
target_link_libraries(xslt PRIVATE ${LIBXML2_LIBRARIES})

install(
  TARGETS xslt
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)

file(GLOB LIBXSLT_API_HEADERS ${CMAKE_SOURCE_DIR}/libxslt/*.h )

install(
  FILES ${LIBXSLT_API_HEADERS}
  DESTINATION include/libxslt
)
