# Checking Headers and Functions for libpsl
add_definitions(-DHAVE_CONFIG_H)

include( CheckIncludeFile )
include( CheckFunctionExists )
include( CheckLibraryExists )
include( CheckTypeSize)

if (ICU_FOUND)
    set(WITH_LIBICU 1)
    set(BUILTIN_GENERATOR_LIBICU 1) 
endif()

if (WIN32)
    set(LIBPSL_LIBS gdi32 msimg32 user32 winmm ws2_32)
    add_definitions(-Dalloca=_alloca)
endif()

check_include_file( "alloca.h" HAVE_ALLOCA_H )
check_include_file( "inttypes.h" HAVE_INTTYPES_H )
check_include_file( "stdint.h" HAVE_STDINT_H )
check_include_file( "memory.h" HAVE_MEMORY_H )
check_include_file( "string.h" HAVE_STRING_H )
check_include_file( "stdlib.h" HAVE_STDLIB_H )
check_include_file( "strings.h" HAVE_STRINGS_H )
check_include_file( "sys/stat.h" HAVE_SYS_STAT_H )
check_include_file( "sys/types.h" HAVE_SYS_TYPES_H )
check_include_file( "unistd.h" HAVE_UNISTD_H )
check_include_file( "langinfo.h" HAVE_LANGINFO_H )

check_include_file( "sys/mman.h" HAVE_SYS_MMAN_H )

check_function_exists( HAVE_ALLOCA HAVE_ALLOCA )
check_function_exists( clock_gettime HAVE_CLOCK_GETTIME )
check_function_exists( fmemopen HAVE_FMEMOPEN )
check_function_exists( nl_langinfo HAVE_NL_LANGINFO )
check_function_exists( strndup HAVE_STRNDUP )

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/include/libpsl.h.in ${CMAKE_CURRENT_BINARY_DIR}/include/libpsl.h)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/src/config.h)
