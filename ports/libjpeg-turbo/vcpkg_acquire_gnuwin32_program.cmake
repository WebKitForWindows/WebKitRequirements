## # vcpkg_acquire_gnuwin32_program
##
## Downloads prebuilt binaries for gnuwin32 tools.
##
## ## Usage
## ```cmake
## vcpkg_acquire_gnuwin32_program(<VAR>)
## ```
##
## ## Parameters
## ### VAR
## This variable specifies both the program to be acquired as well as the out parameter that will be set to the path of the program executable.
##
## ## Notes
## The current list of programs includes:
##
## - GREP
## - SED
function(vcpkg_acquire_gnuwin32_program VAR)
  set(EXPANDED_VAR ${${VAR}})
  if (EXPANDED_VAR)
    return()
  endif()

  if (VAR MATCHES "GREP")
    set(PROGNAME grep)
    set(URL "http://downloads.sourceforge.net/gnuwin32/grep-2.5.4-bin.zip")
    set(ARCHIVE "grep-2.5.4-bin.zip")
    set(HASH 8c1304e6dd4d5d3ab60206dfc5775845cfefd79157e41d4cdba3b20f76543c8d0118a23e792c1e6fcb84f4cc35fc03e72e67fbb35ab843eb27c309c2fbb024a6)
    set(DEP_URL "http://downloads.sourceforge.net/gnuwin32/grep-2.5.4-dep.zip")
    set(DEP_ARCHIVE "grep-2.5.4-dep.zip")
    set(DEP_HASH 2608d02297a84a103d1ca3243990f8714310863f9e3ba0beeef20527ffe67678d01f3deea98b5c3e0142eef2dbcd340fdac263727f8b940932632919be515cca)
  elseif (VAR MATCHES "SED")
    set(PROGNAME sed)
    set(URL "http://downloads.sourceforge.net/gnuwin32/sed-4.2.1-bin.zip")
    set(ARCHIVE "sed-4.2.1-bin.zip")
    set(HASH 3a5c87d21f1faee7579f97ddcdfeb87fdd3389fafd73ceef81299f9e2c44d63fca74a9ab656f2db1a95491aca63965116d51361b9630d00fa39f76bd990d2204)
    set(DEP_URL "http://downloads.sourceforge.net/gnuwin32/sed-4.2.1-dep.zip")
    set(DEP_ARCHIVE "sed-4.2.1-dep.zip")
    set(DEP_HASH c8d222410011e75744ed1a3c51460200f9b863e3562ee3c506cca06a5e708d04fb9ec32e8d2427665d61b6724ca594deb9407733b15b9ba48a16838d7c7c4ddc)
  else ()
    message(FATAL "unknown tool ${VAR} -- unable to acquire.")
  endif()

  macro(do_find)
    find_program(${VAR} ${PROGNAME} PATHS ${DOWNLOADS}/tools/${PROGNAME}/bin)
  endmacro()

  do_find()
  if("${${VAR}}" MATCHES "-NOTFOUND")
    file(MAKE_DIRECTORY ${DOWNLOADS}/tools/${PROGNAME})

    # Get distribution
    vcpkg_download_distfile(ARCHIVE_PATH
      URLS ${URL}
      SHA512 ${HASH}
      FILENAME ${ARCHIVE}
    )

    execute_process(
      COMMAND ${CMAKE_COMMAND} -E tar xzf ${ARCHIVE_PATH}
      WORKING_DIRECTORY ${DOWNLOADS}/tools/${PROGNAME}
    )

    # Get dependencies
    # WinGNU files do not distribute dependenices in the archive
    vcpkg_download_distfile(DEP_ARCHIVE_PATH
      URLS ${DEP_URL}
      SHA512 ${DEP_HASH}
      FILENAME ${DEP_ARCHIVE}
    )

    execute_process(
      COMMAND ${CMAKE_COMMAND} -E tar xzf ${DEP_ARCHIVE_PATH}
      WORKING_DIRECTORY ${DOWNLOADS}/tools/${PROGNAME}
    )

    do_find()
  endif()

  set(${VAR} "${${VAR}}" PARENT_SCOPE)
endfunction()
