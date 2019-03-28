# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

#############################################################################
# Variables
#############################################################################

set(SRCDATADIR ${PROJECT_SOURCE_DIR}/data)
set(OUTDIR ${PROJECT_BINARY_DIR}/data/out)

set(OUTTMPDIR ${OUTDIR}/tmp)
set(MAINBUILDDIR ${OUTDIR}/build)
set(BUILDDIR ${MAINBUILDDIR}/${ICUDATA_PLATFORM_NAME})
set(UNICODEDATADIR ${SRCDATADIR}/unidata)
set(LOCSRCDIR ${SRCDATADIR}/locales)
set(CURRSRCDIR ${SRCDATADIR}/curr)
set(CURRBLDDIR ${BUILDDIR}/curr)
set(LANGSRCDIR ${SRCDATADIR}/lang)
set(LANGBLDDIR ${BUILDDIR}/lang)
set(REGIONSRCDIR ${SRCDATADIR}/region)
set(REGIONBLDDIR ${BUILDDIR}/region)
set(ZONESRCDIR ${SRCDATADIR}/zone)
set(ZONEBLDDIR ${BUILDDIR}/zone)
set(UNITSRCDIR ${SRCDATADIR}/unit)
set(UNITBLDDIR ${BUILDDIR}/unit)
set(COLSRCDIR ${SRCDATADIR}/coll)
set(COLBLDDIR ${BUILDDIR}/coll)
set(RBNFSRCDIR ${SRCDATADIR}/rbnf)
set(RBNFBLDDIR ${BUILDDIR}/rbnf)
set(TRANSLITSRCDIR ${SRCDATADIR}/translit)
set(TRANSLITBLDDIR ${BUILDDIR}/translit)
set(MISCSRCDIR ${SRCDATADIR}/misc)
set(BRKSRCDIR ${SRCDATADIR}/brkitr)
set(BRKBLDDIR ${BUILDDIR}/brkitr)
set(DICTSRCDIR ${BRKSRCDIR}/dictionaries)
set(BRKRULESRCDIR ${BRKSRCDIR}/rules)
set(MISCSRCDIR ${SRCDATADIR}/misc)
set(UCMSRCDIR ${SRCDATADIR}/mappings)
set(SPREPSRCDIR ${SRCDATADIR}/sprep)
set(COMINCDIR ${PROJECT_SOURCE_DIR}/common/unicode)
#set(SRCLISTDEPS Makefile ${srcdir}/Makefile.in)

set(BUILD_DIRS
  ${OUTDIR} ${MAINBUILDDIR} ${BUILDDIR} ${CURRBLDDIR} ${LANGBLDDIR}
  ${REGIONBLDDIR} ${ZONEBLDDIR} ${UNITBLDDIR} ${BRKBLDDIR} ${COLBLDDIR}
  ${RBNFBLDDIR} ${TRANSLITBLDDIR} ${OUTTMPDIR} ${OUTTMPDIR_390STUB}
  ${OUTTMPDIR}/${CURR_TREE} ${OUTTMPDIR}/${LANG_TREE}
  ${OUTTMPDIR}/${REGION_TREE} ${OUTTMPDIR}/${ZONE_TREE}
  ${OUTTMPDIR}/${UNIT_TREE} ${OUTTMPDIR}/${COLLATION_TREE}
  ${OUTTMPDIR}/${RBNF_TREE} ${OUTTMPDIR}/${TRANSLIT_TREE}
  ${OUTTMPDIR}/${BREAK_TREE}
)

# relative lib links from pkgdata are the same as for tmp
set(TOOLDIR ${PROJECT_BINARY_DIR}/tools)

## MISC files
set(PKGDATA_LIST ${OUTTMPDIR}/icudata.lst)
set(ICUPKG_INC ${PROJECT_BINARY_DIR}/data/icupkg.inc)

# Allow Windows to override these options
if(MSVC)
  set(PKGDATA_OPTS
    -f  # --force-prefix
    -v  # --verbose
  )

  if(WINDOWS_STORE)
    list(APPEND PKGDATA_OPTS
      -u  # --windows-uwp-build
    )
#    # TODO: for UWP ARM, see source/data/makedata.mak
#    if("$(CFG)" == "ARM\Release" || "$(CFG)" == "ARM\Debug")
#      list(APPEND PKGDATA_OPTS
#        -a  # --windows-uwp-arm-build
#      )
#    endif()
  endif()

else()
  set(PKGDATA_OPTS
    -O ${ICUPKG_INC}  # --bldopt
    -q  # --quiet
  )
endif()
if(MSVC)
  set(PKGDATA_VERSIONING "")
else()
  set(PKGDATA_VERSIONING
    -r ${SO_TARGET_VERSION}  # --revision
  )
endif()

# This allows all the data to be in one directory
#if(PKGDATA_MODE STREQUAL "dll")
#  set(ICUPKGDATA_OUTDIR ${libdir})
#elseif(PKGDATA_MODE STREQUAL "static")
#  set(ICUPKGDATA_OUTDIR ${libdir})
#else()
#  set(ICUPKGDATA_OUTDIR ${OUTDIR})
#endif()
# We only interested in generated assembler file.
set(ICUPKGDATA_OUTDIR ${OUTDIR})

set(PKGDATA
  ${TOOLBINDIR}/pkgdata
  ${PKGDATA_OPTS}
  -c  # --copyright
  -s ${PROJECT_BINARY_DIR}/data/out/build/${ICUDATA_PLATFORM_NAME}  # --sourcedir
  -d ${ICUPKGDATA_OUTDIR}  # --destdir
)

if(MSVC)
  set(ICUDATA_ASM_FILE ${OUTTMPDIR}/${ICUDATA_PLATFORM_NAME}_dat.obj)
else()
  set(ICUDATA_ASM_FILE ${OUTTMPDIR}/${ICUDATA_PLATFORM_NAME}_dat.S)
endif()

set(deps_icupkg "")
set(deps_pkgdata "")
if(NOT ICU_CROSS_COMPILING)
  set(deps_icupkg icupkg)
  set(deps_pkgdata pkgdata)
endif()


#############################################################################
# BUILD RULES
#############################################################################

#############################################################################
# Make the build directories
#############################################################################

# build-dir:
file(MAKE_DIRECTORY ${BUILD_DIRS})


#############################################################################
# Configure the options for pkgdata
#############################################################################

# We only interested in generated assembler file.
# Variables like compiler/ranlib/linker/... set to dummy echo commands

# icupkg.inc: pkgdataMakefile
# See source/data/pkgdataMakefile.in
if(PKGDATA_MODE STREQUAL "dll" OR PKGDATA_MODE STREQUAL "static")
  configure_file(${CMAKE_CURRENT_LIST_DIR}/icupkg.inc.cmake ${ICUPKG_INC} @ONLY)
endif()


#############################################################################
# Find the data archive and convert it if need
#############################################################################

# Find out if we have a source archive.
# If we have that, then use that instead of building everything from scratch.
# Set in root CMakeLists.txt
set(ICUDATA_SOURCE_ARCHIVE_FILE_NAME ${ICUDATA_PLATFORM_NAME}.dat)
set(ICUDATA_SOURCE_ARCHIVE
  ${CMAKE_CURRENT_LIST_DIR}/in/${ICUDATA_SOURCE_ARCHIVE_FILE_NAME}
)
if(NOT EXISTS ${ICUDATA_SOURCE_ARCHIVE})
  set(ICUDATA_SOURCE_ARCHIVE "")
endif()
if(NOT ICUDATA_SOURCE_ARCHIVE)
  file(GLOB ICUDATA_ARCHIVE_FILES LIST_DIRECTORIES false
     ${CMAKE_CURRENT_LIST_DIR}/in/${ICUDATA_BASENAME_VERSION}*.dat
  )
  list(GET ICUDATA_ARCHIVE_FILES 0 ICUDATA_ARCHIVE)
  # We don't have the data in the current endianess or charset.
  # See if we can find data of any archive type,
  # and convert it to the current type.
  if(ICUDATA_ARCHIVE)
    set(ICUDATA_SOURCE_ARCHIVE ${OUTDIR}/${ICUDATA_SOURCE_ARCHIVE_FILE_NAME})
    add_custom_command(OUTPUT ${ICUDATA_SOURCE_ARCHIVE}
      COMMAND ${TOOLBINDIR}/icupkg
        -t${ICUDATA_CHAR}  # --type
        ${ICUDATA_ARCHIVE} ${ICUDATA_SOURCE_ARCHIVE}
      DEPENDS ${deps_icupkg} ${ICUDATA_ARCHIVE} # ${OUTDIR}
      COMMENT
        "Convert ${ICUDATA_ARCHIVE} to ${ICUDATA_SOURCE_ARCHIVE}"
    )
  endif()
else()
  if(NOT ENABLE_STATIC)
    if(PKGDATA_MODE STREQUAL "common")
      # We have a source data common archive in the native endianess,
      # and it's what we want to build. Try to not run any of ICU's tools.
      set(ICUDATA_SOURCE_IS_NATIVE_TARGET YES)
    endif()
  endif()
endif()


#############################################################################
# Unpack the data archive and generate the list of data files
#############################################################################

if(CMAKE_HOST_WIN32 AND NOT (CMAKE_GENERATOR STREQUAL "MSYS Makefiles"))
  # protection not needed
  set(extract_pattern *)
else()
  set(extract_pattern \\*)
endif()

if(NOT ICUDATA_SOURCE_ARCHIVE)
  # TODO: data building from scratch.
  error_message("TODO: data building from scratch is not support now.")
elseif(PKGDATA_MODE STREQUAL "dll" OR PKGDATA_MODE STREQUAL "static")
  #build-local: build-dir $(SO_VERSION_DATA) $(PKGDATA_LIST) $(OS390LIST)
  #${PKGDATA_LIST}: ${SRCLISTDEPS} ${ICUDATA_SOURCE_ARCHIVE}
  if(NOT ICUDATA_SOURCE_IS_NATIVE_TARGET)
    add_custom_command(OUTPUT ${PKGDATA_LIST}
      COMMAND ${CMAKE_COMMAND} -E remove -f ${PKGDATA_LIST}
      COMMAND ${TOOLBINDIR}/icupkg
        -d ${BUILDDIR}  # --destdir
        --list
        -x ${extract_pattern}  # --extract
        ${ICUDATA_SOURCE_ARCHIVE}
        -o ${PKGDATA_LIST}  # --outlist
      DEPENDS ${deps_icupkg} ${ICUDATA_SOURCE_ARCHIVE} # ${BUILD_DIRS}
      COMMENT
        "Unpacking ${ICUDATA_SOURCE_ARCHIVE} and generating ${PKGDATA_LIST} (list of data files)"
    )
  else()
    #@echo "${PKGDATA_LIST}" > ${PKGDATA_LIST}
    file(WRITE ${PKGDATA_LIST} ${PKGDATA_LIST})
  endif()
endif()


#############################################################################
# Generate the assembler file
#############################################################################

# We only interested in generated assembler file.
# Variables like compiler/ranlib/linker/... set to dummy echo commands

#packagedata: icupkg.inc ${PKGDATA_LIST} build-local
if(PKGDATA_MODE STREQUAL "dll" OR PKGDATA_MODE STREQUAL "static")
  if(ENABLE_STATIC)
    if(PKGDATA_MODE STREQUAL "dll")
      set(ADD_icudata_asm_target YES)
      set(asm_PKGDATA_MODE static)
      set(asm_PKGDATA_LIBNAME ${PKGDATA_LIBSTATICNAME})
    endif()
  endif()
  if(NOT ICUDATA_SOURCE_IS_NATIVE_TARGET)
    set(ADD_icudata_asm_target YES)
    set(asm_PKGDATA_MODE ${PKGDATA_MODE})
    set(asm_PKGDATA_LIBNAME ${PKGDATA_LIBNAME})
  endif()
endif()

if(ADD_icudata_asm_target)
  add_custom_command(OUTPUT ${ICUDATA_ASM_FILE}
    COMMAND ${PKGDATA}
      -e ${ICUDATA_ENTRY_POINT}  # --entrypoint
      -T ${OUTTMPDIR}            # --tempdir
      -p ${ICUDATA_NAME}         # --name
      -m ${asm_PKGDATA_MODE}     # --mode
      ${PKGDATA_VERSIONING}
      ${asm_PKGDATA_LIBNAME}
      ${PKGDATA_LIST}
    DEPENDS ${deps_pkgdata} ${PKGDATA_LIST} # ${ICUPKG_INC}
    COMMENT
      "Packing data to the asm file ${ICUDATA_ASM_FILE}"
  )
  add_custom_target(icudata_asm_target DEPENDS ${ICUDATA_ASM_FILE})
endif()

#if(ICUDATA_SOURCE_IS_NATIVE_TARGET)
#  #${INSTALL_DATA} ${ICUDATA_SOURCE_ARCHIVE} ${OUTDIR}
#  install(FILES ${ICUDATA_SOURCE_ARCHIVE} DESTINATION ${OUTDIR})
#endif()


#############################################################################
# Make and install the data library
#############################################################################

if(PKGDATA_MODE STREQUAL "dll" OR PKGDATA_MODE STREQUAL "static")
  set(lib_NAME ${ICULIBS_DT})
  set(lib_NAME_SUFFIX ${DATA_STUBNAME})
  set(lib_OUTPUT_NAME ${lib_NAME}${ICULIBSUFFIX_DEBUG})

  if(NOT WIN32)
    set(lib_RUNTIME_OUTPUT_NAME ${lib_OUTPUT_NAME})
  else()
    set(lib_RUNTIME_OUTPUT_NAME ${lib_NAME}${PROJECT_VERSION_MAJOR}${ICULIBSUFFIX_DEBUG})
  endif()

  add_library(${lib_NAME} "")

  set_target_properties(${lib_NAME} PROPERTIES
    LINKER_LANGUAGE C
    EXPORT_NAME ${lib_NAME_SUFFIX}
    OUTPUT_NAME ${lib_OUTPUT_NAME}
    RUNTIME_OUTPUT_NAME ${lib_RUNTIME_OUTPUT_NAME})

  ### Common libraries options
  include(${PROJECT_SOURCE_DIR}/common_icu_lib_flags.cmake)
  #include(${PROJECT_SOURCE_DIR}/common_icu_lib_includes.cmake)  # Not included.

  ### Library's specific flags
  set_property(TARGET ${lib_NAME} APPEND_STRING PROPERTY
    LINK_FLAGS ${LDFLAGSICUDT}
  )

  ### Include directories
  # PRIVATE
  target_include_directories(${lib_NAME} PRIVATE
    ${PROJECT_SOURCE_DIR}/common
    ${PROJECT_BINARY_DIR}/common
  )

  ### Dependencies
  add_dependencies(${lib_NAME} icudata_asm_target)

  target_sources(${lib_NAME}
    PRIVATE
      ${ICUDATA_ASM_FILE}
  )

  install(
    TARGETS ${lib_NAME}
    EXPORT "${TARGETS_EXPORT_NAME}"
    ARCHIVE  DESTINATION "${libdir}"
    LIBRARY  DESTINATION "${libdir}"
    RUNTIME  DESTINATION "${bindir}"
    INCLUDES DESTINATION "${includedir}"
  )

elseif(PKGDATA_MODE STREQUAL "common")
  install(FILES ${ICUDATA_SOURCE_ARCHIVE} DESTINATION ${ICUPKGDATA_DIR})
endif()
