# - Try to find FONTCONFIG
# Once done this will define
#
#  FONTCONFIG_ROOT_DIR - Set this variable to the root installation of FONTCONFIG
#  FONTCONFIG_FOUND - system has FONTCONFIG
#  FONTCONFIG_INCLUDE_DIRS - the FONTCONFIG include directory
#  FONTCONFIG_LIBRARIES - Link these to use FONTCONFIG
#
#  Copyright (c) 2008 Joshua L. Blocher <verbalshadow at gmail dot com>
#  Copyright (c) 2012 Dmitry Baryshnikov <polimax at mail dot ru>
#  Copyright (c) 2013 Michael Pavlyshko <pavlushko at tut dot by>
#
# Distributed under the OSI-approved BSD License
#

if (NOT (${CMAKE_SYSTEM_NAME} MATCHES "Windows"))
    find_package(PkgConfig)
    if (PKG_CONFIG_FOUND)
        pkg_check_modules(_FONTCONFIG fontconfig)
    endif (PKG_CONFIG_FOUND)
endif (NOT WIN32)

SET(_FONTCONFIG_ROOT_HINTS
    $ENV{FONTCONFIG}
    ${CMAKE_FIND_ROOT_PATH}
    ${FONTCONFIG_ROOT_DIR}
) 

SET(_FONTCONFIG_ROOT_PATHS
    $ENV{FONTCONFIG}/src
    /usr
    /usr/local
)

SET(_FONTCONFIG_ROOT_HINTS_AND_PATHS
    HINTS ${_FONTCONFIG_ROOT_HINTS}
    PATHS ${_FONTCONFIG_ROOT_PATHS}
)

FIND_PATH(FONTCONFIG_INCLUDE_DIR
    NAMES
        "fontconfig/fontconfig.h"
    HINTS
        ${_FONTCONFIG_INCLUDEDIR}
        ${_FONTCONFIG_ROOT_HINTS_AND_PATHS}
    PATH_SUFFIXES
        include
)  


FIND_LIBRARY(FONTCONFIG_LIBRARY
    NAMES
        fontconfig
    HINTS
        ${_FONTCONFIG_LIBDIR}
        ${_FONTCONFIG_ROOT_HINTS_AND_PATHS}
    PATH_SUFFIXES
        "lib"
        "local/lib"
) 

SET(FONTCONFIG_LIBRARIES 
    ${FONTCONFIG_LIBRARY}
)

SET(FONTCONFIG_INCLUDE_DIRS
    ${FONTCONFIG_INCLUDE_DIR}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FONTCONFIG
    REQUIRED_VARS FONTCONFIG_LIBRARIES FONTCONFIG_INCLUDE_DIRS
    FAIL_MESSAGE "Could NOT find FONTCONFIG, try to set the path to FONTCONFIG root folder in the system variable FONTCONFIG"
)

MARK_AS_ADVANCED(FONTCONFIG_INCLUDE_DIR FONTCONFIG_INCLUDE_DIRS FONTCONFIG_LIBRARY FONTCONFIG_LIBRARIES)
