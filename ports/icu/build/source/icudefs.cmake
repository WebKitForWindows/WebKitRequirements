# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

# Standard directories
include(GNUInstallDirs)
set(bindir      ${CMAKE_INSTALL_BINDIR})
set(sbindir     ${CMAKE_INSTALL_SBINDIR})
set(datarootdir ${CMAKE_INSTALL_DATAROOTDIR})
set(datadir     ${CMAKE_INSTALL_DATADIR})
set(libdir      ${CMAKE_INSTALL_LIBDIR})
set(includedir  ${CMAKE_INSTALL_INCLUDEDIR})
set(mandir      ${CMAKE_INSTALL_MANDIR})
set(sysconfdir  ${CMAKE_INSTALL_SYSCONFDIR})

# Package information
set(PACKAGE_ICU_DESCRIPTION "International Components for Unicode")
set(PACKAGE_ICU_URL "http://icu-project.org")
#set(PACKAGE @PACKAGE@)  # set in configure_2nd.cmake
#set(VERSION @VERSION@)  # set in configure_2nd.cmake
#set(UNICODE_VERSION @UNICODE_VERSION@)  # set in configure_2nd.cmake
set(SO_TARGET_VERSION ${PROJECT_VERSION})
set(SO_TARGET_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})


# The ICU data external name is usually icudata; the entry point name is
# the version-dependent name (for no particular reason except it was easier
# to change the build this way). When building in common mode, the data
# name is the versioned platform-dependent one.
set(ICUDATA_DIR ${datarootdir}/${PACKAGE}/${PROJECT_VERSION})

set(ICUDATA_BASENAME_VERSION ${ICUPREFIX}dt${PROJECT_VERSION_MAJOR})
# The entry point is almost like the basename, but has the lib suffix.
set(ICUDATA_ENTRY_POINT ${ICUPREFIX}dt${ICULIBSUFFIXCNAME}${PROJECT_VERSION_MAJOR})
#set(ICUDATA_CHAR @ICUDATA_CHAR@)  # set in configure_2nd.cmake
set(ICUDATA_PLATFORM_NAME ${ICUDATA_BASENAME_VERSION}${ICUDATA_CHAR})

if(NOT PKGDATA_MODE)
  set(PKGDATA_MODE ${DATA_PACKAGING_MODE})
endif()
if(PKGDATA_MODE STREQUAL "common")
  set(ICUPKGDATA_DIR ${ICUDATA_DIR})
elseif(PKGDATA_MODE STREQUAL "dll" OR PKGDATA_MODE STREQUAL "static")
  set(ICUPKGDATA_DIR ${libdir})
else()
  set(ICUPKGDATA_DIR ${ICUDATA_DIR})
endif()

set(ICUDATA_NAME ${ICUDATA_PLATFORM_NAME})

# These are defined here because mh-cygwin-msvc needs to override these values.
#set(ICUPKGDATA_INSTALL_DIR ${DESTDIR}${ICUPKGDATA_DIR})
#set(ICUPKGDATA_INSTALL_LIBDIR ${DESTDIR}${libdir})

# If defined to a valid value, pkgdata will generate a data library more quickly
#set(GENCCODE_ASSEMBLY @GENCCODE_ASSEMBLY@)  # set in configure_2nd.cmake

# ICU specific directories
set(pkgdatadir ${datadir}/${PACKAGE}${ICULIBSUFFIX}/${PROJECT_VERSION})
set(pkglibdir ${libdir}/${PACKAGE}${ICULIBSUFFIX}/${PROJECT_VERSION})
set(pkgsysconfdir ${sysconfdir}/${PACKAGE}${ICULIBSUFFIX})

# Library suffix (to support different C++ compilers). Usually empty.
#set(ICULIBSUFFIX @ICULIBSUFFIX@)  # set in configure_2nd.cmake


# Various flags for the tools

# DEFS is for common macro definitions.
# configure prevents user defined DEFS, and configure's DEFS is not needed
# So we ignore the DEFS that comes from configure
# U_ATTRIBUTE_DEPRECATED is defined to hide warnings about deprecated API warnings.
set(DEFS U_ATTRIBUTE_DEPRECATED=)

# CFLAGS is for C only flags
#set(CFLAGS @CFLAGS@)  # set in configure_2nd.cmake
# CXXFLAGS is for C++ only flags
#set(CXXFLAGS @CXXFLAGS@)  # set in configure_2nd.cmake
# CPPFLAGS is for C Pre-Processor flags
#set(CPPFLAGS @CPPFLAGS@)  # set in configure_2nd.cmake
# LIBCFLAGS are the flags for static and shared libraries.
#set(LIBCFLAGS @LIBCFLAGS@)  # set in configure_2nd.cmake
# LIBCXXFLAGS are the flags for static and shared libraries.
#set(LIBCXXFLAGS @LIBCXXFLAGS@)  # set in configure_2nd.cmake
# LIBCPPFLAGS are the flags for static and shared libraries.
# set(LIBCPPFLAGS @LIBCPPFLAGS@)  # set in configure_2nd.cmake
# DEFAULT_LIBS are the default libraries to link against
set(DEFAULT_LIBS ${LIBS})
# LIB_M is for linking against the math library
#set(LIB_M @LIB_M@)  # We do not use.
set(LIB_M "")  # We do not use.
# LIB_THREAD is for linking against the threading library
#set(LIB_THREAD @LIB_THREAD@)  # We do not use.

##  How ICU libraries are named...  ex. $(LIBICU)uc$(SO)
# Prefix for the ICU library names
#set(ICUPREFIX "icu)  # set in source/CMakeLists.txt
set(LIBICU ${ICUPREFIX})

# Location of the libraries before "make install" is used
set(LIBDIR ${PROJECT_BINARY_DIR}/lib)

# Location of the executables before "make install" is used
set(BINDIR ${PROJECT_BINARY_DIR}/bin)

# Name flexibility for the library naming scheme.  Any modifications should
# be made in the mh- file for the specific platform.
set(STUBDATA_STUBNAME stubdata)
set(DATA_STUBNAME     data)
set(COMMON_STUBNAME   uc)
set(I18N_STUBNAME     i18n)
set(LAYOUTEX_STUBNAME lx)
set(IO_STUBNAME       io)
set(TOOLUTIL_STUBNAME tu)
set(CTESTFW_STUBNAME  test)

if(WIN32)
  set(DATA_STUBNAME dt)
  set(I18N_STUBNAME in)
endif()

# overridden by icucross.cmake
if(CMAKE_GENERATOR MATCHES "Visual Studio.*")
  set(CONFIG_DIR_NAME "/$<CONFIG>")
endif()
set(TOOLBINDIR ${BINDIR}${CONFIG_DIR_NAME})
set(TOOLLIBDIR ${LIBDIR}${CONFIG_DIR_NAME})

# TODO: HAVE_ICU_LE_HB set in configure_2nd.cmake
if(HAVE_ICU_LE_HB)
#  set(ICULEHB_CFLAGS @ICULEHB_CFLAGS@)
#  set(ICULEHB_CFLAGS "-I/usr/include/icu-le-hb -I/usr/include/harfbuzz -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include")
#  set(ICULEHB_LIBS @ICULEHB_LIBS@)
#  set(ICULEHB_LIBS "-licu-le-hb")
else()
  set(ICULEHB_CFLAGS "")
  set(ICULEHB_LIBS "")
endif()
if(ICULEHB_CFLAGS)
  set(USING_ICULEHB yes)
  set(ICULEHB_TRUE "")
  set(ICULEHB_FALSE "#")
  set(ICULIBS_LE ${ICULEHB_LIBS})
  set(ICULE_CFLAGS "${ICULEHB_CFLAGS} -DUSING_ICULEHB") # TODO: list(APPEND ) without "-D"
else()
  set(USING_ICULEHB no)
  set(ICULEHB_TRUE "#")
  set(ICULEHB_FALSE "")
  set(ICULIBS_LE "")
  set(ICULE_CFLAGS "")
endif()

# Just the libs.
set(ICULIBS_STUBDT   ${ICUPREFIX}${STUBDATA_STUBNAME}${ICULIBSUFFIX})
set(ICULIBS_DT       ${ICUPREFIX}${DATA_STUBNAME}${ICULIBSUFFIX})
set(ICULIBS_UC       ${ICUPREFIX}${COMMON_STUBNAME}${ICULIBSUFFIX})
set(ICULIBS_I18N     ${ICUPREFIX}${I18N_STUBNAME}${ICULIBSUFFIX})
set(ICULIBS_LX       ${ICUPREFIX}${LAYOUTEX_STUBNAME}${ICULIBSUFFIX})
set(ICULIBS_IO       ${ICUPREFIX}${IO_STUBNAME}${ICULIBSUFFIX})
set(ICULIBS_CTESTFW  ${ICUPREFIX}${CTESTFW_STUBNAME}${ICULIBSUFFIX})
set(ICULIBS_TOOLUTIL ${ICUPREFIX}${TOOLUTIL_STUBNAME}${ICULIBSUFFIX})

set(LIBICUSTUBDT    ${ICULIBS_STUBDT})
set(LIBICUDT        ${ICULIBS_DT})
set(LIBICUUC        ${ICULIBS_UC} ${ICULIBS_DT})
set(LIBICUI18N      ${ICULIBS_I18N})
#set(LIBICULE        ${ICULEHB_CFLAGS} ${ICULIBS_LE}) # Add ICULEHB_CFLAGS to ..
set(LIBICULE        ${ICULIBS_LE})
set(LIBICULX        ${ICULIBS_LX})
set(LIBCTESTFW      ${ICULIBS_CTESTFW})
set(LIBICUTOOLUTIL  ${ICULIBS_TOOLUTIL})
set(LIBICUIO        ${ICULIBS_IO})

if(NOT WIN32)
  set(PKGDATA_LIBSTATICNAME -L ${ICUPREFIX}${DATA_STUBNAME}${ICULIBSUFFIX})
  set(PKGDATA_LIBNAME -L ${ICUPREFIX}${DATA_STUBNAME}${ICULIBSUFFIX})
else()
  set(PKGDATA_LIBSTATICNAME -L ${ICUPREFIX}${DATA_STUBNAME}${PROJECT_VERSION_MAJOR}${ICULIBSUFFIX})
  set(PKGDATA_LIBNAME -L ${ICUPREFIX}${DATA_STUBNAME}${PROJECT_VERSION_MAJOR}${ICULIBSUFFIX})
endif()

# Platform-specific setup
# Values are from source/config/mh-* files.

## These are the library specific CPPFLAGS
set(CPPFLAGSICUDT "")
set(CPPFLAGSICUUC "")
set(CPPFLAGSICUI18N "")
set(CPPFLAGSICUIO "")
set(CPPFLAGSICULX "")
set(CPPFLAGSCTESTFW "")
set(CPPFLAGSICUTOOLUTIL "")

## These are the library specific LDFLAGS
set(LDFLAGSICUDT " ")
set(LDFLAGSICUUC " ")
set(LDFLAGSICUI18N " ")
set(LDFLAGSICUIO " ")
set(LDFLAGSICULX " ")
set(LDFLAGSCTESTFW " ")
set(LDFLAGSICUTOOLUTIL " ")

if(MSVC)
  # Make sure that assertions are disabled
  #list(APPEND CPPFLAGS_RELEASE U_RELEASE=1#M#)
  list(APPEND CPPFLAGS_RELEASE U_RELEASE=1)

  # Pass debugging flag through
  #list(APPEND CPPFLAGS_DEBUG _DEBUG=1#M#)
  list(APPEND CPPFLAGS_DEBUG _DEBUG=1)

  set(ICULIBSUFFIX_DEBUG $<$<CONFIG:Debug>:d>)

  # -GF pools strings and places them into read-only memory
  # -EHsc enables exception handling
  # -Zc:wchar_t makes wchar_t a native type. Required for C++ ABI compatibility.
  # -D_CRT_SECURE_NO_DEPRECATE is needed to quiet warnings about using standard C functions.
  # -utf-8 set source file encoding to utf-8.
  if(PROJECT_VERSION VERSION_GREATER 58.9)
    set(UTF8_VS_KEY -utf-8)
  endif()
  list(APPEND CFLAGS -GF ${UTF8_VS_KEY})
  list(APPEND CXXFLAGS -GF -EHsc -Zc:wchar_t ${UTF8_VS_KEY})
  list(APPEND CPPFLAGS _CRT_SECURE_NO_DEPRECATE)
  #list(APPEND DEFS WIN32)

  ## These are the library specific LDFLAGS
  # The NOENTRY option is required for creating a resource-only DLL.
  set(LDFLAGSICUDT "${LDFLAGSICUDT} -base:\"0x4ad00000\" -NOENTRY")
  set(LDFLAGSICUUC "${LDFLAGSICUUC} -base:\"0x4a800000\"")    # in-uc = 1MB
  set(LDFLAGSICUI18N "${LDFLAGSICUI18N} -base:\"0x4a900000\"")  # io-in = 2MB
  set(LDFLAGSICUIO "${LDFLAGSICUIO} -base:\"0x4ab00000\"")    # le-io = 1MB
  set(LDFLAGSICULX "${LDFLAGSICULX} -base:\"0x4ac80000\"")
  #set(LDFLAGSCTESTFW "") # Unused for now.
  # Same as layout. Layout and tools probably won't mix.
  set(LDFLAGSICUTOOLUTIL "${LDFLAGSICUTOOLUTIL} -base:\"0x4ac00000\"")

  if(WINDOWS_STORE)
    list(APPEND CPPFLAGS U_PLATFORM_HAS_WINUWP_API=1)
  endif()
endif()

if(MINGW AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
  if(PROJECT_VERSION VERSION_GREATER 58.9)
    ## ICU requires a minimum target of Windows 7, and MinGW does not set this by default.
    ## https://msdn.microsoft.com/en-us/library/aa383745.aspx
    list(APPEND CPPFLAGS WINVER=0x0601 _WIN32_WINNT=0x0601)
  endif()
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Linux" AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
  set(LDFLAGSICUDT "${LDFLAGSICUDT} -nodefaultlibs -nostdlib")
endif()

# some imported things from the cross env
if(ICU_CROSS_BUILDROOT)
  include(${ICU_CROSS_BUILDROOT}/config/icucross.cmake)
endif()
