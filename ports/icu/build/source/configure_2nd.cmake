# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

include(CheckIncludeFile)
include(CheckIncludeFileCXX)
include(CheckSymbolExists)
include(CheckTypeSize)
include(TestBigEndian)

macro(icu_conditional name condition)
  if(${condition})
    set(${name}_TRUE "")
    set(U_HAVE_${name} 1)
  else()
    set(${name}_TRUE "#")
    set(U_HAVE_${name} 0)
  endif()
endmacro()

function(try_compile_src src_file_name src_file_ext
    header_text main_text definitions libraries out_var)
  set(file_name "try_compile_${src_file_name}")
  set(src_file
    "${CMAKE_CURRENT_BINARY_DIR}/try_compile/${file_name}.${src_file_ext}"
  )
  set(bin_dir "${CMAKE_CURRENT_BINARY_DIR}/try_compile/${file_name}")

  file(WRITE ${src_file}
  "
      ${header_text}
      int main()
      {
        ${main_text}
        return 0;
      }
  ")

  if(NOT definitions)
    set(definitions "-DTEMP_TRY_STUB_DEF")
  endif()

  if(libraries)
    try_compile(_${out_var} ${bin_dir}
      SOURCES ${src_file}
      COMPILE_DEFINITIONS ${definitions}
      LINK_LIBRARIES ${libraries}
      OUTPUT_VARIABLE build_OUT
    )
  else()
    try_compile(_${out_var} ${bin_dir}
      SOURCES ${src_file}
      COMPILE_DEFINITIONS ${definitions}
      OUTPUT_VARIABLE build_OUT
    )
  endif()


  if(_${out_var})
    set(${out_var} 1 PARENT_SCOPE)
    message(STATUS "Looking for ${out_var} - set to 1 - TRUE")
#    message(STATUS ${build_OUT})  # For debug
  else()
    set(${out_var} 0 PARENT_SCOPE)
    message(STATUS "Looking for ${out_var} - set to 0 - FALSE")
#    message(STATUS ${build_OUT})  # For debug
  endif()
endfunction()


# Accumulate #defines

# CONFIG_CPPFLAGS: These are defines that are set for ICU Build time only.
# They are only needed for building ICU itself. Example: platform stuff
# NOTE: only -D flags.
# NOTE: to CPPFLAGS
set(CONFIG_CPPFLAGS "")

# UCONFIG_CPPFLAGS: These are defines which are set for ICU build time,
# and also a notice is output that they need to be set
# for end-users of ICU also. uconfig.h.prepend is generated
# with, for example, "#define U_DISABLE_RENAMING 1"
# Example: ICU configuration stuff
# NOTE: only -D flags.
# NOTE: to CPPFLAGS and to 'uconfig.h.prepend' file.
set(UCONFIG_CPPFLAGS "")

# UCONFIG_CFLAGS: contains a copy of anything that needs to be set by end users
# such as -std
# NOTE: not used, in orig configure.ac are NOT -D flags.
set(UCONFIG_CFLAGS "")

set(CFLAGS "")
set(CXXFLAGS "")
set(CPPFLAGS "")

set(STATICCFLAGS "")
set(STATICCXXFLAGS "")
set(STATICCPPFLAGS "")

set(LIBCFLAGS "")
set(LIBCXXFLAGS "")
set(LIBCPPFLAGS "")

set(SHAREDLIBCFLAGS "")
set(SHAREDLIBCXXFLAGS "")
set(SHAREDLIBCPPFLAGS "")

set(LIBS "")
set(LDFLAGS " ")  # Property 'LINK_FLAGS' is appendable string, not list.

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Check whether to build debug libraries
#check_message("whether to build debug libraries" ${ENABLE_DEBUG})
list(APPEND CPPFLAGS_DEBUG U_DEBUG=1)

# Check whether to build release libraries
#check_message("whether to build release libraries" ${ENABLE_RELEASE})

# TODO: see:
# http://userguide.icu-project.org/layoutengine/paragraph
# https://github.com/harfbuzz/icu-le-hb
# TODO: find_package(icu-le-hb), not pkg-config.
# pkg-config is needed for harfbuzz support
#PKG_CHECK_MODULES(ICULEHB, icu-le-hb, have_icu_le_hb=true, :)
set(HAVE_ICU_LE_HB false)

# TODO: Is it needed with CMake?
# Ensure that if CXXFLAGS/CFLAGS were not set when calling configure,
# set it correctly based on (enable/disable) debug or release option.
# The release mode use is the default one for autoconf
#if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
#  if(CFLAGS STREQUAL "")
#    if(ENABLE_DEBUG)
#      set(CFLAGS -g)
#    endif()
#    if(ENABLE_RELEASE)
#      list(APPEND CFLAGS -O2)
#    endif()
#  endif()
#endif()
#if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
#  if(CXXFLAGS STREQUAL "")
#    if(ENABLE_DEBUG)
#      set(CXXFLAGS -g)
#    endif()
#    if(ENABLE_RELEASE)
#      list(APPEND CXXFLAGS -O2)
#    endif()
#  endif()
#endif()

option(ICU_CROSS_COMPILING "Enable cross compiling" OFF)
set(ICU_CROSS_BUILDROOT "" CACHE PATH
  "Specify an absolute path to the build directory of an ICU built for the current platform"
)
if(NOT ICU_CROSS_BUILDROOT)
  if(ICU_CROSS_COMPILING)
    error_message(
      "Error! Cross compiling but no ICU_CROSS_BUILDROOT option specified - please supply the path to an executable ICU's build root"
    )
  endif()
elseif(EXISTS ${ICU_CROSS_BUILDROOT}/config/icucross.cmake)
  status_message("Using cross buildroot: ${ICU_CROSS_BUILDROOT}")
elseif(EXISTS ${ICU_CROSS_BUILDROOT})
  error_message(
    "${crossICU_CROSS_BUILDROOT}/config/icucross.cmake not found. Please build ICU in ${ICU_CROSS_BUILDROOT} first."
  )
else()
  error_message(
    "No such directory ${ICU_CROSS_BUILDROOT} supplied as the argument to ICU_CROSS_BUILDROOT. Use an absolute path."
  )
endif()

# Determine how strict we want to be when compiling
option(ICU_ENABLE_STRICT "Compile with strict compiler options" ON)
if(ICU_ENABLE_STRICT)
  if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    list(APPEND CFLAGS
      -Wall -pedantic -Wshadow -Wpointer-arith
      -Wmissing-prototypes -Wwrite-strings
    )
  elseif(MSVC)
    list(APPEND CFLAGS /W4)
  endif()
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    list(APPEND CXXFLAGS
      -W -Wall -pedantic -Wpointer-arith -Wwrite-strings -Wno-long-long
    )
  elseif(MSVC)
    list(APPEND CXXFLAGS /W4)
  endif()
endif()
check_message("whether strict compiling is on" ${ICU_ENABLE_STRICT})

# Checks for libraries and other host specific stuff.
# TODO: On HP/UX, don't link to -lm from a shared lib
# because it isn't PIC (at least on 10.2).
option(ICU_USE_LIB_M "Compile with 'm' library." ON)
if(ICU_USE_LIB_M)
  find_library(LIB_M_LOCATION NAMES "m")
  set(HAVE_LIB_M OFF)
  if(LIB_M_LOCATION)
    try_compile_src("for_lib_m" "c"
      "#include <math.h>"
      "double d = floor(2.0);"
      ""
      "${LIB_M_LOCATION}"
      _HAVE_LIB_M
    )
    if(_HAVE_LIB_M)
      set(HAVE_LIB_M ON)
#      set(LIB_M_TARGET "${TARGETS_NAMESPACE}m")
#      add_library(${LIB_M_TARGET} SHARED IMPORTED)
#      set_target_properties(${LIB_M_TARGET} PROPERTIES
#        IMPORTED_LOCATION "${LIB_M_LOCATION}"
#      )
#      list(INSERT LIBS 0 ${LIB_M_TARGET})
      list(INSERT LIBS 0 "m")
    endif()
  endif()
endif()

if(BUILD_SHARED_LIBS)
  set(ICU_ENABLE_SHARED ON)
  set(ICU_ENABLE_STATIC OFF)
else()
  set(ICU_ENABLE_SHARED OFF)
  set(ICU_ENABLE_STATIC ON)
endif()

# Check whether to build shared libraries
#option(ICU_ENABLE_SHARED "Build shared libraries" ON)
check_message("whether to build shared libraries" ${ICU_ENABLE_SHARED})

# Check whether to build static libraries
#option(ICU_ENABLE_STATIC "Build static libraries" OFF)
check_message("whether to build static libraries" ${ICU_ENABLE_STATIC})

# When building release static library, there might be some optimization flags we can use
if(ICU_ENABLE_STATIC AND NOT ICU_ENABLE_SHARED)
  set(_HAVE_STATIC_OPTIMIZATION no)
  if(UNIX AND NOT APPLE AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
    list(APPEND ST_OPT_CPPFLAGS -ffunction-sections -fdata-sections)
    list(APPEND ST_OPT_LDFLAGS  "-Wl,--gc-sections")
    list(APPEND CHECK_CPPFLAGS ${CPPFLAGS} ${ST_OPT_CPPFLAGS})
    try_compile_src("static_library_optimization" "c"
      ""
      ""
      "${CHECK_CPPFLAGS}"
      "${ST_OPT_LDFLAGS}"
      _HAVE_STATIC_OPTIMIZATION
    )
    if(_HAVE_STATIC_OPTIMIZATION)
      #list(APPEND CPPFLAGS ${ST_OPT_CPPFLAGS})
      list(APPEND CFLAGS_RELEASE ${ST_OPT_CPPFLAGS})
      set(LDFLAGS_RELEASE "${LDFLAGS} ${ST_OPT_LDFLAGS}")
    endif()
  endif()
  check_message("whether we can use static library optimization option"
    ${_HAVE_STATIC_OPTIMIZATION}
  )
endif()

# Check whether to enable auto cleanup of libraries
option(ICU_ENABLE_AUTO_CLEANUP "Enable auto cleanup of libraries" OFF)
set(UCLN_NO_AUTO_CLEANUP 1)
set(MSVC_RELEASE_FLAG "")
if(ICU_ENABLE_AUTO_CLEANUP)
  list(APPEND CONFIG_CPPFLAGS UCLN_NO_AUTO_CLEANUP=0)
  set(UCLN_NO_AUTO_CLEANUP 0)

  # MSVC floating-point option
  if(MSVC)
    if(MSVC_VERSION LESS 1400)
      set(MSVC_RELEASE_FLAG /Op)
    else()
      set(MSVC_RELEASE_FLAG /fp:precise)
    endif()
    list(APPEND CFLAGS ${MSVC_RELEASE_FLAG})
    list(APPEND CXXFLAGS ${MSVC_RELEASE_FLAG})
  endif()
endif()
check_message(
  "whether to enable auto cleanup of libraries" ${ICU_ENABLE_AUTO_CLEANUP}
)

# Check whether to enabled draft APIs
option(ICU_ENABLE_DRAFT "Enable draft APIs (and internal APIs)" ON)
set(U_DEFAULT_SHOW_DRAFT 1)
if(NOT ICU_ENABLE_DRAFT)
  set(U_DEFAULT_SHOW_DRAFT 0)
  list(APPEND CONFIG_CPPFLAGS U_DEFAULT_SHOW_DRAFT=0)
endif()
check_message("whether to enable draft APIs" ${ICU_ENABLE_DRAFT})
# Make sure that we can use draft API in ICU.
if(NOT U_DEFAULT_SHOW_DRAFT)
  list(APPEND CONFIG_CPPFLAGS U_SHOW_DRAFT_API U_SHOW_INTERNAL_API)
endif()

option(ICU_ENABLE_RENAMING "Add a version suffix to symbols" ON)
set(U_DISABLE_RENAMING 0)
if(NOT ICU_ENABLE_RENAMING)
  set(U_DISABLE_RENAMING 1)
  list(APPEND UCONFIG_CPPFLAGS U_DISABLE_RENAMING=1)
endif()
check_message("whether to enable renaming of symbols" ${ICU_ENABLE_RENAMING})

option(ICU_ENABLE_TRACING "Enable function and data tracing" OFF)
set(U_ENABLE_TRACING 0)
if(ICU_ENABLE_TRACING)
  set(U_ENABLE_TRACING 1)
  list(APPEND CONFIG_CPPFLAGS U_ENABLE_TRACING=1)
endif()
check_message(
  "whether to enable function and data tracing" ${ICU_ENABLE_TRACING}
)

# check if elf.h is present.
check_include_file("elf.h" _HAVE_ELF_H)
if(_HAVE_ELF_H)
  set(HAVE_ELF_H 1)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_ELF_H=1)
else()
  set(HAVE_ELF_H 0)
endif()

# Enable/disable plugins
option(ICU_ENABLE_PLUGINS "Enable plugins" OFF)
icu_conditional(PLUGINS ICU_ENABLE_PLUGINS)
if(ICU_ENABLE_PLUGINS)
  list(APPEND UCONFIG_CPPFLAGS UCONFIG_ENABLE_PLUGINS=1)
endif()

option(ICU_DISABLE_DYLOAD "Disable dynamic loading" OFF)
set(U_ENABLE_DYLOAD 1)
if(ICU_DISABLE_DYLOAD)
  set(U_ENABLE_DYLOAD 0)
  list(APPEND CONFIG_CPPFLAGS U_ENABLE_DYLOAD=0)
endif()
check_message(
  "whether to enable dynamic loading of plugins. Ignored if plugins disabled."
  ${U_ENABLE_DYLOAD}
)
set(HAVE_LIB_DL OFF)
if(U_ENABLE_DYLOAD)
  check_include_file("dlfcn.h" _HAVE_DLFCN_H)
  if(_HAVE_DLFCN_H)
    set(HAVE_DLFCN_H 1)

    check_symbol_exists("dlopen" "dlfcn.h" _HAVE_DLOPEN)
    if(_HAVE_DLOPEN)
      set(HAVE_DLOPEN 1)
    elseif(CMAKE_DL_LIBS)
      find_library(LIB_DL_LOCATION NAMES ${CMAKE_DL_LIBS})
      if(LIB_DL_LOCATION)
        set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_DL_LIBS})
        check_symbol_exists("dlopen" "dlfcn.h" _HAVE_DLOPEN_DL)
        if(_HAVE_DLOPEN_DL)
          set(HAVE_DLOPEN 1)
          set(HAVE_LIB_DL ON)
#          set(LIB_DL_TARGET "${TARGETS_NAMESPACE}dl")
#          add_library(${LIB_DL_TARGET} SHARED IMPORTED)
#          set_target_properties(${LIB_DL_TARGET} PROPERTIES
#            IMPORTED_LOCATION "${LIB_DL_LOCATION}"
#          )
#          list(INSERT LIBS 0 ${LIB_DL_TARGET})
          list(INSERT LIBS 0 ${CMAKE_DL_LIBS})
        else()
          set(HAVE_DLOPEN 0)
        endif()
      endif()
    endif()
  else()
    set(HAVE_DLFCN_H 0)
  endif()

  if(NOT HAVE_DLFCN_H OR NOT HAVE_DLOPEN)
    list(APPEND CONFIG_CPPFLAGS HAVE_DLOPEN=0)
  endif()
endif()

# Check for miscellanous functions.
# So, use for putil / tools only.
# Note that this will generate HAVE_GETTIMEOFDAY, not U_HAVE_GETTIMEOFDAY
check_symbol_exists("gettimeofday" "sys/time.h" _HAVE_GETTIMEOFDAY)
if(_HAVE_GETTIMEOFDAY)
  set(HAVE_GETTIMEOFDAY 1)
else()
  set(HAVE_GETTIMEOFDAY 0)
endif()

# Check whether to use the evil rpath or not
option(ICU_ENABLE_RPATH "Use rpath when linking" OFF)

if(CMAKE_CXX_STANDARD LESS 11)
  try_compile_src("if_include_string_works" "cpp"
    "#include <string>"
    ""
    ""
    ""
    _HEADER_STDSTRING
  )
  if(_HEADER_STDSTRING)
    set(U_HAVE_STD_STRING 1)
  else()
    set(U_HAVE_STD_STRING 0)
    list(APPEND CONFIG_CPPFLAGS U_HAVE_STD_STRING=0)
  endif()
  check_message("if #include <string> works" ${_HEADER_STDSTRING})
endif()

try_compile_src("if_include_atomic_works" "cpp"
  "#include <atomic>"
  ""
  ""
  ""
  _HEADER_ATOMIC
)
if(_HEADER_ATOMIC)
  set(U_HAVE_ATOMIC 1)
else()
  set(U_HAVE_ATOMIC 0)
endif()
# Make this available via CPPFLAGS
list(APPEND CONFIG_CPPFLAGS U_HAVE_ATOMIC=${U_HAVE_ATOMIC})
check_message("if #include <atomic> works" ${_HEADER_ATOMIC})

# Always build ICU with multi-threading support.
find_package(Threads REQUIRED)
if(NOT TARGET Threads::Threads)
  error_message("Threads library is not found.")
endif()
set(HAVE_THREADS ON)
list(INSERT LIBS 0 Threads::Threads)
# TODO: need THREADSC*FLAGS ?
# TODO: THREADSC*FLAGS defined in mh-*
set(THREADSCPPFLAGS "")
set(THREADSCFLAGS "")
set(THREADSCXXFLAGS "")

# Check for mmap()
set(HAVE_MMAP 0)
try_compile_src("if_include_atomic_works" "cpp"
  "
    #include <unistd.h>
    #include <sys/mman.h>
    #include <sys/stat.h>
    #include <fcntl.h>
  "
  "mmap((void *)0, 0, PROT_READ, 0, 0, 0);"
  ""
  ""
  _HAVE_MMAP
)
if(_HAVE_MMAP)
  set(HAVE_MMAP 1)
else()
  list(APPEND CONFIG_CPPFLAGS U_HAVE_MMAP=0)
endif()
check_message("for mmap" ${HAVE_MMAP})

# Check to see if genccode can generate simple assembly.
set(GENCCODE_ASSEMBLY "")
if(MINGW)
  if( CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(GENCCODE_ASSEMBLY "-a gcc-mingw64")  # 64 bits
  else()
    set(GENCCODE_ASSEMBLY "-a gcc-cygwin")   # 32 bits
  endif()
elseif(APPLE)
  set(GENCCODE_ASSEMBLY "-a gcc-darwin")
elseif(UNIX)  # for GCC and clang
  set(GENCCODE_ASSEMBLY "-a gcc")
endif()
if(IOS OR ANDROID OR WINDOWS_STORE)
  # Support only archive mode for these platforms.
  set(GENCCODE_ASSEMBLY "")
endif()
set(_GENCCODE_ASSEMBLY ${GENCCODE_ASSEMBLY})
if(NOT _GENCCODE_ASSEMBLY)
  set(_GENCCODE_ASSEMBLY OFF)
endif()
check_message("for genccode assembly" ${_GENCCODE_ASSEMBLY})

# Checks for header files

check_include_file("inttypes.h" _HAVE_INTTYPES_H)
if(_HAVE_INTTYPES_H)
  set(HAVE_INTTYPES_H 1)
  set(U_HAVE_INTTYPES_H 1)
else()
  set(HAVE_INTTYPES_H 0)
  set(U_HAVE_INTTYPES_H 0)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_INTTYPES_H=0)
endif()

check_include_file("dirent.h" _HAVE_DIRENT_H)
if(_HAVE_DIRENT_H)
  set(HAVE_DIRENT_H 1)
  set(U_HAVE_DIRENT_H 1)
else()
  set(HAVE_DIRENT_H 0)
  set(U_HAVE_DIRENT_H 0)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_DIRENT_H=0)
endif()

# Check for endianness
test_big_endian(_U_IS_BIG_ENDIAN)
if(_U_IS_BIG_ENDIAN)
  set(U_IS_BIG_ENDIAN 1)
  set(U_ENDIAN_CHAR "b")
else()
  set(U_IS_BIG_ENDIAN 0)
  set(U_ENDIAN_CHAR "l")
endif()

# Do various POSIX related checks
set(U_HAVE_NL_LANGINFO_CODESET 0)
set(U_NL_LANGINFO_CODESET -1)
check_symbol_exists("nl_langinfo" "langinfo.h" _HAVE_NL_LANGINFO)
if(_HAVE_NL_LANGINFO)
  set(HAVE_NL_LANGINFO 1)
  set(U_HAVE_NL_LANGINFO 1)

  set(NL_LANGINFO_CODESET "unknown")
  foreach(nl_item CODESET _NL_CTYPE_CODESET_NAME)
    try_compile_src("check_nl_langinfo_item" "c"
      "#include <langinfo.h>"
      "nl_langinfo(${nl_item});"
      ""
      ""
      _NL_LANGINFO_CODESET
    )
    if(_NL_LANGINFO_CODESET)
      set(NL_LANGINFO_CODESET ${nl_item})
      break()
    endif()
  endforeach()

  if(_NL_LANGINFO_CODESET)
    set(U_HAVE_NL_LANGINFO_CODESET 1)
    set(U_NL_LANGINFO_CODESET ${NL_LANGINFO_CODESET})
    if(NOT NL_LANGINFO_CODESET STREQUAL "xCODESET")
      list(APPEND CONFIG_CPPFLAGS NL_LANGINFO_CODESET=${NL_LANGINFO_CODESET})
    endif()
  else()
    list(APPEND CONFIG_CPPFLAGS U_HAVE_NL_LANGINFO_CODESET=0)
  endif()

else()
  set(HAVE_NL_LANGINFO 0)
  set(U_HAVE_NL_LANGINFO 0)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_NL_LANGINFO_CODESET=0)
  if(MINGW AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
    list(APPEND CONFIG_CPPFLAGS U_HAVE_NL_LANGINFO_CODESET=0)
  endif()
endif()

# Namespace support checks
try_compile_src("check_namespace_support" "cpp"
  "
    namespace x_version {void f(){}}
    namespace x = x_version;
    using namespace x_version;
  "
  "f();"
  ""
  ""
  _NAMESPACE_OK
)
check_message("for namespace support" ${_NAMESPACE_OK})
if(NOT _NAMESPACE_OK)
  error_message("Namespace support is required to build ICU.")
endif()

set(U_OVERRIDE_CXX_ALLOCATION 0)
set(U_HAVE_PLACEMENT_NEW 0)
try_compile_src("overriding_new_and_delete" "cpp"
  "
    #include <stdlib.h>
    class UMemory {
    public:
    void *operator new(size_t size) {return malloc(size);}
    void *operator new[](size_t size) {return malloc(size);}
    void operator delete(void *p) {free(p);}
    void operator delete[](void *p) {free(p);}
    };
  "
  ""
  ""
  ""
  _OVERRIDE_CXX_ALLOCATION_OK
)
check_message(
  "for properly overriding new and delete" ${_OVERRIDE_CXX_ALLOCATION_OK}
)
if(_OVERRIDE_CXX_ALLOCATION_OK)
  set(U_OVERRIDE_CXX_ALLOCATION 1)

  try_compile_src("placement_new_and_delete" "cpp"
    "
      #include <stdlib.h>
      class UMemory {
      public:
      void *operator new(size_t size) {return malloc(size);}
      void *operator new[](size_t size) {return malloc(size);}
      void operator delete(void *p) {free(p);}
      void operator delete[](void *p) {free(p);}
      void * operator new(size_t, void *ptr) { return ptr; }
      void operator delete(void *, void *) {}
      };
    "
    ""
    ""
    ""
    _OVERRIDE_PLACEMENT_NEW_OK
  )
  if(_OVERRIDE_PLACEMENT_NEW_OK)
    set(U_HAVE_PLACEMENT_NEW 1)
  else()
    list(APPEND CONFIG_CPPFLAGS U_HAVE_PLACEMENT_NEW=0)
  endif()
  check_message("for placement new and delete" ${_OVERRIDE_PLACEMENT_NEW_OK})
else()
  list(APPEND CONFIG_CPPFLAGS U_OVERRIDE_CXX_ALLOCATION=0)
endif()

check_symbol_exists("popen" "stdio.h" _HAVE_POPEN)
if(_HAVE_POPEN)
  set(HAVE_POPEN 1)
  set(U_HAVE_POPEN 1)
else()
  set(HAVE_POPEN 0)
  set(U_HAVE_POPEN 0)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_POPEN=0)
endif()

check_symbol_exists("tzset" "time.h" _HAVE_TZSET)
set(U_HAVE_TZSET 0)
if(_HAVE_TZSET)
  set(HAVE_TZSET 1)
  set(U_TZSET tzset)
  set(U_HAVE_TZSET 1)
else()
  set(HAVE_TZSET 0)
  check_symbol_exists("_tzset" "time.h" _HAVE__TZSET)
  if(_HAVE__TZSET)
    set(HAVE__TZSET 1)
    set(U_TZSET _tzset)
    set(U_HAVE_TZSET 1)
  else()
    set(HAVE__TZSET 0)
    list(APPEND CONFIG_CPPFLAGS U_HAVE_TZSET=0)
  endif()
endif()

set(U_HAVE_TZNAME 0)
try_compile_src("for_tzname" "c"
  "
    #ifndef _XOPEN_SOURCE
    #define _XOPEN_SOURCE
    #endif
    #include <stdlib.h>
    #include <time.h>
    #ifndef tzname /* For SGI.  */
    extern char *tzname[]; /* RS6000 and others reject char **tzname.  */
    #endif
  "
  "atoi(*tzname);"
  ""
  ""
  _TZNAME
)
if(_TZNAME)
  set(U_TZNAME tzname)
  set(U_HAVE_TZNAME 1)
else()
  try_compile_src("for__tzname" "c"
    "
      #include <stdlib.h>
      #include <time.h>
      extern char *_tzname[];
    "
    "atoi(*_tzname);"
    ""
    ""
    __TZNAME
  )
  if(__TZNAME)
    set(U_TZNAME _tzname)
    set(U_HAVE_TZNAME 1)
  else()
    list(APPEND CONFIG_CPPFLAGS U_HAVE_TZNAME=0)
  endif()
endif()

try_compile_src("for_timezone" "c"
  "
    #ifndef _XOPEN_SOURCE
    #define _XOPEN_SOURCE
    #endif
    #include <time.h>
  "
  "timezone = 1;"
  ""
  ""
  _TIMEZONE
)
set(U_HAVE_TIMEZONE 0)
if(_TIMEZONE)
  set(U_TIMEZONE timezone)
  set(U_HAVE_TIMEZONE 1)
else()
  try_compile_src("for___timezone" "c"
    "#include <time.h>"
    "__timezone = 1;"
    ""
    ""
    ___TIMEZONE
  )
  if(___TIMEZONE)
    set(U_TIMEZONE __timezone)
    set(U_HAVE_TIMEZONE 1)
  else()
    try_compile_src("for__timezone" "c"
      "#include <time.h>"
      "_timezone = 1;"
      ""
      ""
      __TIMEZONE
    )
    if(__TIMEZONE)
      set(U_TIMEZONE _timezone)
      set(U_HAVE_TIMEZONE 1)
    else()
      list(APPEND CONFIG_CPPFLAGS U_HAVE_TIMEZONE=0)
    endif()
  endif()
endif()

check_symbol_exists("strtod_l" "stdlib.h" _HAVE_STRTOD_L)
if(_HAVE_STRTOD_L)
  set(HAVE_STRTOD_L 1)
  set(U_HAVE_STRTOD_L 1)
  if(NOT ANDROID)
    # Symbols "freelocale" and "LC_ALL_MASK" are not defined
    # in Android with "xlocale.h".
    check_include_file("xlocale.h" _HAVE_XLOCALE_H)
  endif()
  if(_HAVE_XLOCALE_H)
    set(HAVE_XLOCALE_H 1)
    set(U_HAVE_XLOCALE_H 1)
    list(APPEND CONFIG_CPPFLAGS U_HAVE_STRTOD_L=1 U_HAVE_XLOCALE_H=1)
  else()
    set(HAVE_XLOCALE_H 0)
    set(U_HAVE_XLOCALE_H 0)
    list(APPEND CONFIG_CPPFLAGS U_HAVE_STRTOD_L=1 U_HAVE_XLOCALE_H=0)
  endif()
else()
  set(HAVE_STRTOD_L 0)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_STRTOD_L=0)
  set(U_HAVE_STRTOD_L 0)
endif()

# Checks for typedefs
check_type_size("int8_t"   TYPE_int8_t   LANGUAGE CXX)
check_type_size("uint8_t"  TYPE_uint8_t  LANGUAGE CXX)
check_type_size("int16_t"  TYPE_int16_t  LANGUAGE CXX)
check_type_size("uint16_t" TYPE_uint16_t LANGUAGE CXX)
check_type_size("int32_t"  TYPE_int32_t  LANGUAGE CXX)
check_type_size("uint32_t" TYPE_uint32_t LANGUAGE CXX)
check_type_size("int64_t"  TYPE_int64_t  LANGUAGE CXX)
check_type_size("uint64_t" TYPE_uint64_t LANGUAGE CXX)

if(NOT HAVE_TYPE_int8_t)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_INT8_T=0)
endif()

if(NOT HAVE_TYPE_uint8_t)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_UINT8_T=0)
endif()

if(NOT HAVE_TYPE_int16_t)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_INT16_T=0)
endif()

if(NOT HAVE_TYPE_uint16_t)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_UINT16_T=0)
endif()

if(NOT HAVE_TYPE_int32_t)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_INT32_T=0)
endif()

if(NOT HAVE_TYPE_uint32_t)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_UINT32_T=0)
endif()

if(NOT HAVE_TYPE_int64_t)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_INT64_T=0)
endif()

if(NOT HAVE_TYPE_uint64_t)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_UINT64_T=0)
endif()

# Do various wchar_t related checks
option(ICU_USE_WCS_OR_W_LIB "Compile with 'wxs' or 'w' libraries." ON)
check_include_file("wchar.h" _HAVE_WCHAR_H)
if(_HAVE_WCHAR_H)
  set(HAVE_WCHAR_H 1)
  set(U_HAVE_WCHAR_H 1)
  set(wcs_w_lib "")
  if(ICU_USE_WCS_OR_W_LIB)
    set(wcs_w_lib "" wcs w)
  endif()
  foreach(lib ${wcs_w_lib})
    if(lib)
      find_library(HAVE_LIB_${lib} NAMES ${lib})
      if(NOT HAVE_LIB_${lib})
        continue()
      endif()
    else()
      set(HAVE_LIB_${lib} "")
    endif()
    try_compile_src("for_timezone" "c"
      "
        #define HAVE_WCHAR_H 1
        #include <wchar.h>
      "
      "
        wchar_t *src = (void*) 0;
        wchar_t *dst = (void*) 0;
        wcscpy(dst, src);
      "
      ""
      "${HAVE_LIB_${lib}}"
      _HAVE_WCSCPY
    )
    if(_HAVE_WCSCPY)
      if(${HAVE_LIB_${lib}})
        list(INSERT LIBS 0 ${HAVE_LIB_${lib}})
      endif()
      break()
    endif()
  endforeach()
  if(_HAVE_WCSCPY)
    set(HAVE_WCSCPY 1)
    set(U_HAVE_WCSCPY 1)
  else()
    set(HAVE_WCSCPY 0)
    set(U_HAVE_WCSCPY 0)
    list(APPEND CONFIG_CPPFLAGS U_HAVE_WCSCPY=0)
  endif()
else()
  set(HAVE_WCHAR_H 0)
  set(HAVE_WCSCPY 0)
  set(U_HAVE_WCHAR_H 0)
  set(U_HAVE_WCSCPY 0)
  list(APPEND CONFIG_CPPFLAGS U_HAVE_WCHAR_H=0 U_HAVE_WCSCPY=0)
endif()

get_property(DIR_DEFS DIRECTORY PROPERTY COMPILE_DEFINITIONS)
foreach(def ${DIR_DEFS})
  if(def MATCHES "STDC_HEADERS=1")
    set(HAVE_STDC_HEADERS 1)
    break()
  endif()
endforeach()
set(CMAKE_EXTRA_INCLUDE_FILES)  # var is to check_type_size()
if(HAVE_STDC_HEADERS)
  list(APPEND CMAKE_EXTRA_INCLUDE_FILES stddef.h)
endif()
if(HAVE_WCHAR_H)
  list(APPEND CMAKE_EXTRA_INCLUDE_FILES string.h wchar.h)
endif()
check_type_size("wchar_t" WCHAR_T_SIZE LANGUAGE CXX)
# We do this check to verify that everything is okay.
if(WCHAR_T_SIZE STREQUAL "" AND U_HAVE_WCHAR_H)
  error_message("There is wchar.h but the size of wchar_t is empty")
endif()
if(WCHAR_T_SIZE EQUAL 0)
  # TODO: set(U_SIZEOF_WCHAR_T ${WCHAR_T_SIZE}-${KEY}), see CMake docs for CheckTypeSize.
  error_message(
    "TODO: WCHAR_T_SIZE == 0 with CMAKE_OSX_ARCHITECTURES, see CMake docs for CheckTypeSize."
  )
endif()
set(U_SIZEOF_WCHAR_T ${WCHAR_T_SIZE})

set(U_CHECK_UTF16_STRING 1)
set(CHECK_UTF16_STRING_RESULT "unknown")
if(CMAKE_C_STANDARD EQUAL 99 OR CMAKE_C_STANDARD GREATER 10)
  set(U_CHECK_UTF16_STRING 1)
  set(CHECK_UTF16_STRING_RESULT "C only")
else()
  set(U_CHECK_UTF16_STRING 0)
endif()
if(NOT CMAKE_CXX_STANDARD EQUAL 98 AND CMAKE_CXX_STANDARD GREATER 10)
  set(U_CHECK_UTF16_STRING 1)
  if(CHECK_UTF16_STRING_RESULT STREQUAL "C only")
    set(CHECK_UTF16_STRING_RESULT "available")
  else()
    set(CHECK_UTF16_STRING_RESULT "C++ only")
  endif()
else()
  set(U_CHECK_UTF16_STRING 0)
endif()
status_message("for UTF-16 string literal support  ${CHECK_UTF16_STRING_RESULT}")

# Enable/disable extras
option(ICU_ENABLE_EXTRAS "Build ICU extras" ON)
ICU_CONDITIONAL(EXTRAS ICU_ENABLE_EXTRAS)

option(ICU_ENABLE_ICUIO "Build ICU's icuio library" ON)
ICU_CONDITIONAL(ICUIO ICU_ENABLE_ICUIO)

# Enable/disable layoutex
option(ICU_ENABLE_LAYOUTEX
  "Build ICU's Paragraph Layout library. icu-le-hb must be available via find_package(icu-le-hb). See http://harfbuzz.org"
  ${HAVE_ICU_LE_HB}
)
# TODO: remove it when find_package(icu-le-hb).
if(ICU_ENABLE_LAYOUTEX)
  error_message("TODO: find_package(icu-le-hb), see: http://userguide.icu-project.org/layoutengine/paragraph. Now please set ICU_ENABLE_LAYOUTEX=OFF")
endif()
ICU_CONDITIONAL(LAYOUTEX ICU_ENABLE_LAYOUTEX)

# Enable/disable layout
option(ICU_ENABLE_LAYOUT "..." OFF)
if(ICU_ENABLE_LAYOUT)
  error_message("The ICU Layout Engine has been removed. Please set ICU_ENABLE_LAYOUT=OFF")
endif()

# Enable/disable tools
option(ICU_ENABLE_TOOLS "Build ICU's tools" ON)
if(IOS OR ANDROID OR WINDOWS_STORE)
  set(ICU_CROSS_BUILDROOT OFF CACHE BOOL "Build ICU's tools" FORCE)
endif()
ICU_CONDITIONAL(TOOLS ICU_ENABLE_TOOLS)

#ICU_DATA_PACKAGING     specify how to package ICU data. Possible values:
#  files    raw files (.res, etc)
#  archive  build a single icudtXX.dat file
#  library  shared library (.dll/.so/etc.)
#  static   static library (.a/.lib/etc.)
#  auto     build shared if possible (default)
#     See http://userguide.icu-project.org/icudata for more info.
set(ICU_DATA_PACKAGING "auto" CACHE STRING
  "Specify how to package ICU data. Possible values: files, archive, library, static, auto. See http://userguide.icu-project.org/icudata for more info"
)
if(IOS OR ANDROID OR WINDOWS_STORE)
  # Support only archive mode for these platforms.
  set(ICU_DATA_PACKAGING "archive" CACHE STRING
    "Specify how to package ICU data. Possible values: files, archive, library, static, auto. See http://userguide.icu-project.org/icudata for more info"
    FORCE
  )
endif()

if(ICU_DATA_PACKAGING STREQUAL "files"
    OR ICU_DATA_PACKAGING STREQUAL "archive"
    OR ICU_DATA_PACKAGING STREQUAL "library"
    OR ICU_DATA_PACKAGING STREQUAL "static"
    OR ICU_DATA_PACKAGING STREQUAL "auto")
  set(datapackaging ${ICU_DATA_PACKAGING})
elseif(ICU_DATA_PACKAGING STREQUAL "common")
  set(datapackaging "archive")
elseif(ICU_DATA_PACKAGING STREQUAL "dll")
  set(datapackaging "library")
else()
  error_message("Bad value ${ICU_DATA_PACKAGING} for ICU_DATA_PACKAGING")
endif()

# TODO:
# Always put raw data files in share/icu/{version}, etc.
# Never use lib/icu/{version} for data files..
# Actual shared libraries will go in {libdir}.

if(datapackaging STREQUAL "auto")
  # default to library
  set(datapackaging "library")
  if(ICU_ENABLE_STATIC AND NOT ICU_ENABLE_SHARED)
    set(datapackaging "static")
  endif()
endif()

# TODO: datapackaging_dir=`eval echo $thedatadir`"/icu/${VERSION}"
set(datapackaging_dir "icu/${VERSION}")

set(datapackaging_msg "(No explanation for mode ${datapackaging}.)")

set(datapackaging_msg_path
  "ICU will look in ${datapackaging_dir} which is the installation location. Call u_setDataDirectory() or use the ICU_DATA environment variable to override."
)
set(datapackaging_msg_set
  "ICU will use the linked data library. If linked with the stub library located in stubdata/, the application can use udata_setCommonData() or set a data path to override."
)
set(datapackaging_howfound "(unknown)")

if(datapackaging STREQUAL "files")
  set(DATA_PACKAGING_MODE "files")
  set(datapackaging_msg "ICU data will be stored in individual files.")
  set(datapackaging_howfound "${datapackaging_msg_path}")
elseif(datapackaging STREQUAL "archive")
  set(DATA_PACKAGING_MODE "common")
  set(datapackaging_msg "ICU data will be stored in a single .dat file.")
  set(datapackaging_howfound "${datapackaging_msg_path}")
elseif(datapackaging STREQUAL "library")
    set(DATA_PACKAGING_MODE "dll")
    set(datapackaging_msg "ICU data will be linked with ICU.")
    if(ICU_ENABLE_STATIC)
      set(datapackaging_msg "${datapackaging_msg} A static data library will be built. ")
    endif()
    if(ICU_ENABLE_SHARED)
      set(datapackaging_msg "${datapackaging_msg} A shared data library will be built. ")
    endif()
    set(datapackaging_howfound "${datapackaging_msg_set}")
elseif(datapackaging STREQUAL "static")
  set(DATA_PACKAGING_MODE "static")
  set(datapackaging_msg "ICU data will be stored in a static library.")
  set(datapackaging_howfound "${datapackaging_msg_set}")
endif()

# Sets a library suffix
set(ICU_LIBRARY_SUFFIX "" CACHE STRING "Tag a suffix to the library names")
set(ICULIBSUFFIX ${ICU_LIBRARY_SUFFIX})
set(msg ${ICULIBSUFFIX})
if(NOT msg)
  set(msg "none")
endif()
status_message("for a library suffix to use  ${msg}")
if(ICULIBSUFFIX)
  if(NOT ICULIBSUFFIX MATCHES "[A-Za-z0-9_]+")
    error_message("Suffix must contain only [A-Za-z0-9_] symbols.")
  endif()
  set(U_HAVE_LIB_SUFFIX 1)
  #set(ICULIBSUFFIXCNAME=`echo _$ICULIBSUFFIX | sed 's/[^A-Za-z0-9_]/_/g'`)
  set(ICULIBSUFFIXCNAME _${ICULIBSUFFIX})
  list(APPEND UCONFIG_CPPFLAGS
    U_HAVE_LIB_SUFFIX=1 U_LIB_SUFFIX_C_NAME=\"${ICULIBSUFFIXCNAME}\"
  )
else()
  set(U_HAVE_LIB_SUFFIX 0)
  set(ICULIBSUFFIXCNAME "")
endif()

# Enable/disable tests
option(ICU_ENABLE_TESTS "Build ICU tests" ON)
ICU_CONDITIONAL(TESTS ICU_ENABLE_TESTS)

# Enable/disable samples
# Additionally, the variable FORCE_LIBS may be set before calling configure.
# If set, it will REPLACE any automatic list of libraries.
option(ICU_ENABLE_SAMPLES "Build ICU samples" ON)
ICU_CONDITIONAL(SAMPLES ICU_ENABLE_SAMPLES)

set(ICUDATA_CHAR ${U_ENDIAN_CHAR})
#if(WIN32)  # From source/data/makedata.mak  # TODO: need it?
#  set(ICUDATA_CHAR "l")
#endif()

# TODO:
# Platform-specific Makefile setup
# set ICUDATA_CHAR to 'e' for any EBCDIC (which should be big endian) platform.
#if(<platform> EQUAL <...> AND NOT ICU_ENABLE_ASCII_STRINGS STREQUAL "1")
#  set(ICUDATA_CHAR "e")
#endif()

if(FORCE_LIBS)
  status_message(
    " *** Overriding automatically chosen [LIBS=${LIBS}], using instead [FORCE_LIBS=${FORCE_LIBS}]"
  )
  set(LIBS ${FORCE_LIBS})
endif()

# Now that we're done using CPPFLAGS etc. for tests, we can change it for build.
if(CMAKE_C_COMPILER_ID MATCHES "Clang")
  list(APPEND CLANGCFLAGS -Qunused-arguments -Wno-parentheses-equality)
else()
  set(CLANGCFLAGS "")
endif()
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  list(APPEND CLANGCXXFLAGS -Qunused-arguments -Wno-parentheses-equality)
else()
  set(CLANGCXXFLAGS "")
endif()

list(APPEND CPPFLAGS ${THREADSCPPFLAGS})
list(APPEND CFLAGS   ${THREADSCFLAGS}   ${CLANGCFLAGS})
list(APPEND CXXFLAGS ${THREADSCXXFLAGS} ${CLANGCXXFLAGS})

# append all config cppflags
list(APPEND CPPFLAGS ${CONFIG_CPPFLAGS} ${UCONFIG_CPPFLAGS})



# icucommon
#  "-DDEFAULT_ICU_PLUGINS=\"/usr/local/lib/icu\" "
#list(APPEND CPPFLAGS _REENTRANT PIC)
#set(LDFLAGS "${LDFLAGS} -Wl,-Bsymbolic")



status_message("CPPFLAGS=${CPPFLAGS}")
status_message("CFLAGS=${CFLAGS}")
status_message("CXXFLAGS=${CXXFLAGS}")
status_message("LDFLAGS=${LDFLAGS}")
status_message("LIBS=${LIBS}")

status_message(" ")
status_message("ICU for C/C++ ${VERSION} is ready to be built.")
status_message("=== Important Notes: ===")

status_message("Data Packaging: ${datapackaging}")
status_message(" This means: ${datapackaging_msg}")
status_message(" To locate data: ${datapackaging_howfound}")

if(UCONFIG_CPPFLAGS)
  set(HDRFILE_NAME "uconfig.h.prepend")
  set(HDRFILE "${PROJECT_BINARY_DIR}/config/uconfig.h.prepend")
  status_message(
    "
*** WARNING: You must set the following flags before code compiled against this ICU will function properly:

   ${UCONFIG_CPPFLAGS}

The recommended way to do this is to prepend the following lines to source/common/unicode/uconfig.h or #include them near the top of that file.
Creating the file ${HDRFILE}

---------------   ${HDRFILE_NAME}
    "
  )

  set(HDRFILE_TEXT
    "/* ICU customizations: put these lines at the top of uconfig.h */\n\n"
  )
  foreach(flag ${UCONFIG_CPPFLAGS})
    set(HDRFILE_TEXT "${HDRFILE_TEXT}/* $flag */")
    if(flag MATCHES ".*=.*")
      string(REGEX REPLACE "([^=]*)=(.*)" "#define \\1 \\2" _flag ${flag})
      set(HDRFILE_TEXT "${HDRFILE_TEXT}${_flag}\n")
    elseif(flag MATCHES ".*")
      string(REGEX REPLACE "([^=]*)(.*)" "#define \\1 \\2" _flag ${flag})
      set(HDRFILE_TEXT "${HDRFILE_TEXT}${_flag}\n")
#    elseif(flag MATCHES ".*")
#      set(HDRFILE_TEXT "${HDRFILE_TEXT} /*  Not sure how to handle this argument: ${flag} */\n")
    endif()
  endforeach()
  status_message(${HDRFILE_TEXT})
  set(HDRFILE_TEXT "${HDRFILE_TEXT}\n/* End of ${HDRFILE_NAME}*/\n")
  file(WRITE ${HDRFILE} ${HDRFILE_TEXT})
  status_message("--------------- end ${HDRFILE_NAME}")
endif()

if(UCONFIG_CFLAGS)
  status_message(
    "C   apps may want to build with CFLAGS   = ${UCONFIG_CFLAGS}"
  )
endif()
if(UCONFIG_CXXFLAGS)
  status_message(
    "C++ apps may want to build with CXXFLAGS = ${UCONFIG_CXXFLAGS}"
  )
endif()

if(NOT ICU_ENABLE_TOOLS)
  status_message(
    "## Note: you have disabled ICU's tools. This ICU cannot build its own data or tests."
  )
  status_message(
    "## Expect build failures in the 'data', 'test', and other directories."
  )
endif()
