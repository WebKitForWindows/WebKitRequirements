cmake_minimum_required(VERSION 2.8.0)

set(CMAKE_CONFIGURATION_TYPES "Release;Debug;MinSizeRel;RelWithDebInfo")

include(GNUInstallDirs)

project(sqlite C)

# OPTIONS
option(ENABLE_EDITLINE "use BSD editline" ON)
mark_as_advanced(ENABLE_EDITLINE)
option(ENABLE_READLINE "use readline" ON)
mark_as_advanced(ENABLE_READLINE)
option(ENABLE_THREADSAFE "build a thread-safe library" ON)
mark_as_advanced(ENABLE_THREADSAFE)
option(ENABLE_DYNAMIC_EXTENSIONS "support loadable extensions" ON)
mark_as_advanced(ENABLE_THREADSAFE)
option(ENABLE_FTS3 "include fts3 support" OFF)
mark_as_advanced(ENABLE_FTT3)
option(ENABLE_FTS4 "include fts4 support" OFF)
mark_as_advanced(ENABLE_FTS4)
option(ENABLE_FTS5 "include fts5 support" OFF)
mark_as_advanced(ENABLE_FTS5)
option(ENABLE_OMIT_LOAD_EXTENSION "omit load extension" OFF)
mark_as_advanced(ENABLE_OMIT_LOAD_EXTENSION)
option(ENABLE_RTREE "include R*Tree support" OFF)
mark_as_advanced(ENABLE_RTREE)
option(ENABLE_JSON1 "include json1 support" OFF)
mark_as_advanced(ENABLE_JSON1)
option(ENABLE_SESSION "enable the session extension" OFF)
mark_as_advanced(ENABLE_SESSION)
option(ENABLE_STATIC_SHELL "statically link libsqlite3 into shell tool" ON)
mark_as_advanced(ENABLE_STATIC_SHELL)

# CONFIGURE
include (CheckFunctionExists)
include (CheckIncludeFile)
include (CheckIncludeFiles)
include (CheckLibraryExists)
include (CheckSymbolExists)
include (CheckTypeSize)
include (CheckCSourceCompiles)
include (CMakeDependentOption)

if (ENABLE_EDITLINE)
  check_include_files(editline/readline.h HAVE_EDITLINE_READLINE_H)
  if (HAVE_EDITLINE_READLINE_H)
    add_definitions(-DHAVE_EDITLINE)
  endif()
endif()

if (ENABLE_READLINE)
  check_include_files(readline/readline.h HAVE_READLINE_READLINE_H)
  if (HAVE_READLINE_READLINE_H)
    add_definitions(-DHAVE_READLINE)
  endif()
endif()

set(THREADSAFE_FLAGS -DSQLITE_THREADSAFE=0)
if (ENABLE_THREADSAFE)
  set(THREADSAFE_FLAGS -D_REENTRANT=1 -DSQLITE_THREADSAFE=1)
endif()
add_definitions(${THREADSAFE_FLAGS})

if (ENABLE_DYNAMIC_EXTENSIONS)
  check_library_exists("dl" dlopen "" HAVE_LIBDL)
else()
  add_definitions(-DSQLITE_OMIT_LOAD_EXTENSION=1)
endif()

if (ENABLE_FTS3)
  add_definitions(-DSQLITE_ENABLE_FTS3)
endif()

if (ENABLE_FTS4)
  add_definitions(-DSQLITE_ENABLE_FTS4)
endif()

if (ENABLE_FTS5)
  add_definitions(-DSQLITE_ENABLE_FTS5)
endif()

if (ENABLE_OMIT_LOAD_EXTENSION)
   add_definitions(-DSQLITE_OMIT_LOAD_EXTENSION=1)
endif()

if (ENABLE_RTREE)
    add_definitions(-DSQLITE_ENABLE_RTREE)
endif()

if (ENABLE_JSON1)
  add_definitions(-DSQLITE_ENABLE_JSON1)
endif()

if (ENABLE_SESSION)
  add_definitions(-DSQLITE_ENABLE_SESSION -DSQLITE_ENABLE_PREUPDATE_HOOK)
endif()

# TODO Add HAVE checks
if (NOT WIN32)
  add_definitions(
    -DHAVE_STDLIB_H
    -DSTDC_HEADERS=1
    -DHAVE_SYS_TYPES_H=1
    -DHAVE_SYS_STAT_H=1
    -DHAVE_STDLIB_H=1
    -DHAVE_STRING_H=1
    -DHAVE_MEMORY_H=1
    -DHAVE_STRINGS_H=1
    -DHAVE_INTTYPES_H=1
    -DHAVE_STDINT_H=1
    -DHAVE_UNISTD_H=1
    -DHAVE_DLFCN_H=1
    -DHAVE_USLEEP=1
    -DHAVE_DECL_STRERROR_R=1
    -DHAVE_STRERROR_R=1
  )
endif ()

# COMMON DEFINITIONS

get_directory_property(defs DIRECTORY ${CMAKE_SOURCE_DIR} COMPILE_DEFINITIONS)
message(STATUS "COMPILE_DEFINITIONS=${defs}")

# SET SOURCES

set(sqlite_sources
  sqlite3.c
)

set(console_sources
  shell.c
)

# BUILD LIBRARIES

add_library(sqlite3 ${sqlite_sources})
target_include_directories(sqlite3 PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

if (WIN32 AND BUILD_SHARED_LIBS)
  set_target_properties(sqlite3 PROPERTIES DEFINE_SYMBOL DLLDEFINE)
  add_definitions(-DSQLITE_API=__declspec\(dllexport\))
endif()

# INSTALL

install(
  TARGETS sqlite3
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(
  FILES sqlite3.h sqlite3ext.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
