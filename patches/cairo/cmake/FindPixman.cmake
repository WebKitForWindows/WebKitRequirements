# - Try to find PIXMAN
# Once done this will define
#
#  PIXMAN_ROOT_DIR - Set this variable to the root installation of PIXMAN
#  PIXMAN_FOUND - system has PIXMAN
#  PIXMAN_INCLUDE_DIRS - the PIXMAN include directory
#  PIXMAN_LIBRARIES - Link these to use PIXMAN
#
#  Copyright (c) 2008 Joshua L. Blocher <verbalshadow at gmail dot com>
#  Copyright (c) 2011 Ralf Habacker, <ralf dot habacker at freenet dot de>
#  Copyright (c) 2012 Dmitry Baryshnikov <polimax at mail dot ru>
#  Copyright (c) 2015 Mikhail Paulyshka <pavlyshko-m at yandex dot by>
#
# Distributed under the OSI-approved BSD License
#

if (NOT WIN32)
    find_package(PkgConfig)
    if (PKG_CONFIG_FOUND)
        pkg_check_modules(_PIXMAN pixman)
        SET(PIXMAN_VERSION ${_PIXMAN_VERSION})
    endif (PKG_CONFIG_FOUND)
endif (NOT WIN32)

SET(_PIXMAN_ROOT_HINTS
    $ENV{PIXMAN}
    ${CMAKE_FIND_ROOT_PATH}
    ${PIXMAN_ROOT_DIR}
) 

SET(_PIXMAN_ROOT_PATHS
    $ENV{PIXMAN}/src
    /usr
    /usr/local
)

SET(_PIXMAN_ROOT_HINTS_AND_PATHS
    HINTS ${_PIXMAN_ROOT_HINTS}
    PATHS ${_PIXMAN_ROOT_PATHS}
)

FIND_PATH(PIXMAN_INCLUDE_DIR
    NAMES
        "pixman.h"
    HINTS
        ${_PIXMAN_INCLUDEDIR}
        ${_PIXMAN_ROOT_HINTS_AND_PATHS}
    PATH_SUFFIXES
        include
        "include/pixman-1"
)  

FIND_LIBRARY(PIXMAN_LIBRARY
    NAMES
        pixman-1 
        pixman-1d
        pixman-1_static
        pixman-1_staticd 
    HINTS
        ${_PIXMAN_LIBDIR}
        ${_PIXMAN_ROOT_HINTS_AND_PATHS}
    PATH_SUFFIXES
        "lib"
        "local/lib"
) 

SET(PIXMAN_LIBRARIES 
    ${PIXMAN_LIBRARY}
)

SET(PIXMAN_INCLUDE_DIRS
    ${PIXMAN_INCLUDE_DIR}
)

if (NOT PIXMAN_VERSION)
    if (EXISTS "${PIXMAN_INCLUDE_DIRS}/pixman-version.h")
        file(READ "${PIXMAN_INCLUDE_DIRS}/pixman-version.h" PIXMAN_VERSION_CONTENT)

        string(REGEX MATCH "#define +PIXMAN_VERSION_MAJOR +([0-9]+)" _dummy "${PIXMAN_VERSION_CONTENT}")
        set(PIXMAN_VERSION_MAJOR "${CMAKE_MATCH_1}")

        string(REGEX MATCH "#define +PIXMAN_VERSION_MINOR +([0-9]+)" _dummy "${PIXMAN_VERSION_CONTENT}")
        set(PIXMAN_VERSION_MINOR "${CMAKE_MATCH_1}")

        string(REGEX MATCH "#define +PIXMAN_VERSION_MICRO +([0-9]+)" _dummy "${PIXMAN_VERSION_CONTENT}")
        set(PIXMAN_VERSION_MICRO "${CMAKE_MATCH_1}")

        set(PIXMAN_VERSION "${PIXMAN_VERSION_MAJOR}.${PIXMAN_VERSION_MINOR}.${PIXMAN_VERSION_MICRO}")
    endif (EXISTS "${PIXMAN_INCLUDE_DIRS}/pixman-version.h")
endif(NOT PIXMAN_VERSION)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PIXMAN
    REQUIRED_VARS PIXMAN_LIBRARIES PIXMAN_INCLUDE_DIRS
    VERSION_VAR PIXMAN_VERSION
    FAIL_MESSAGE "Could NOT find PIXMAN, try to set the path to PIXMAN root folder in the system variable PIXMAN"
)

MARK_AS_ADVANCED(PIXMAN_CONFIG_INCLUDE_DIR PIXMAN_INCLUDE_DIR PIXMAN_INCLUDE_DIRS PIXMAN_LIBRARY PIXMAN_LIBRARIES)