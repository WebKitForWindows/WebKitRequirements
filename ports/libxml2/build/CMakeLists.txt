# Simplified libxml2 CMake file
#
# This CMake implementation just does the minimum to build 
# WinCairoRequirements and does not handle all the things possible when using
# the Makefile directly.
#
# Features missing:
#   - Tests are not built
#   - No support for iconv
#
# TODOs: Add HAVE checks to generate a config.h
#
# Initially inspired by https://github.com/martell/libxml2.cmake

cmake_minimum_required(VERSION 3.7)

project(xml2)

set(VERSION 2.9.7)
set(LIBXML_VERSION_NUMBER 20907)

set(LIBXML_THREAD_SAFETY "native" CACHE STRING "Enable thread safety")
set_property(CACHE LIBXML_THREAD_SAFETY PROPERTY STRINGS no ctls native posix)

if (LIBXML_THREAD_SAFETY EQUAL "no")
set(WITH_THREADS OFF)
else ()
set(WITH_THREADS ON)
endif ()

option(WITH_THREAD_ALLOC OFF)

option(WITH_TRIO "Enable TRIO string manipulator" OFF)

option(WITH_C14N "Enable C14N support" ON)
option(WITH_CATALOG "Enable catalog support" ON)
option(WITH_DEBUG "Enable XML debbugging module" ON)
option(WITH_DOCB "Enable DocBook support" ON)
option(WITH_FTP "Enable FTP client" ON)
option(WITH_HTML "Enable HTML processor" ON)
option(WITH_HTTP "Enable HTTP client" ON)
option(WITH_ICONV "Enable iconv support" OFF)
option(WITH_ICU "Enable icu support" ON)
option(WITH_ISO8859X "Enable ISO8859X support" OFF)
option(WITH_LEGACY "Enable Deprecated api's" ON)
option(WITH_LZMA "Enable lzma support" OFF)
option(WITH_MEM_DEBUG "Enable memory debugger" OFF)
option(WITH_MODULES "Enable module support" ON)
option(WITH_OUTPUT "Enable serialization support" ON)
option(WITH_PATTERN "Enable xmlPattern api" ON)
option(WITH_PUSH "Enable push api" ON)
option(WITH_PYTHON "Build Python bindings" OFF)
option(WITH_READER "Enable xmlReader api" ON)
option(WITH_REGEXPS "Enable regular expressions" ON)
option(WITH_RUN_DEBUG "Enable memory debugger" OFF)
option(WITH_SAX1 "Enable SAX1 api" ON)
option(WITH_SCHEMAS "Enable XML Schema support" ON)
option(WITH_SCHEMATRON "Enable Schematron support" ON)
option(WITH_TREE "Enable tree api" ON)
option(WITH_VALID "Enable DTD validation support" ON)
option(WITH_WALKER "Enable xmlDocWalker api" ON)
option(WITH_WRITER "Enable xmlWriter api" ON)
option(WITH_XINCLUDE "Enable XInclude support" ON)
option(WITH_XPATH "Enable XPath support" ON)
option(WITH_XPTR "Enable XPointer support" ON)
option(WITH_ZLIB "Enable zlib support" OFF)

if (WITH_ICU)
  find_package(ICU 56.1 REQUIRED COMPONENTS uc)
endif()

configure_file(
  ${CMAKE_SOURCE_DIR}/include/libxml/xmlversion.h.cmake.in
  ${CMAKE_SOURCE_DIR}/include/libxml/xmlversion.h
  @ONLY
)

set(LIBXML2_SOURCES
  buf.c
  c14n.c
  catalog.c
  chvalid.c
  debugXML.c
  # Makefile.am conditionally includes this. Just adding since it has a guard
  DOCBparser.c
  dict.c 
  encoding.c
  entities.c
  error.c
  globals.c
  hash.c
  HTMLparser.c
  HTMLtree.c
  legacy.c
  list.c
  nanoftp.c
  nanohttp.c
  parser.c
  parserInternals.c
  pattern.c
  relaxng.c
  SAX.c
  SAX2.c
  schematron.c
  threads.c
  tree.c
  uri.c
  valid.c
  xinclude.c
  xlink.c
  xmlIO.c
  xmlmemory.c
  xmlmodule.c
  xmlreader.c
  xmlregexp.c
  xmlsave.c 
  xmlschemas.c
  xmlschemastypes.c
  xmlstring.c
  xmlunicode.c 
  xmlwriter.c
  xpath.c 
  xpointer.c
  # libxml.vcxproj does not include. Just adding since it has a guard
  xzlib.c
)

set(LIBXML2_INCLUDE_DIRS
  ${CMAKE_SOURCE_DIR}/include
  ${ICU_INCLUDE_DIRS}
)

if (WIN32)
  list(APPEND LIBXML2_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/win32/VC10)
endif()

include_directories(${LIBXML2_INCLUDE_DIRS})

add_library(xml2 ${LIBXML2_SOURCES})
target_link_libraries(xml2 PRIVATE ${ICU_LIBRARIES})

install(
  TARGETS xml2
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)

file(GLOB LIBXML2_API_HEADERS ${CMAKE_SOURCE_DIR}/include/libxml/*.h )

install(
  FILES ${LIBXML2_API_HEADERS}
  DESTINATION include/libxml
)
