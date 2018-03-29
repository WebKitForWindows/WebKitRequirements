## # vcpkg_acquire_icu_tools
##
## Downloads prebuilt binaries for ICU tools.
##
## ## Usage
## ```cmake
## vcpkg_acquire_icu_tools(<VAR> <ICU_VERSION>)
## ```
##
## ## Parameters
## ### VAR
## This variable specifies both the program to be acquired as well as the out parameter that will be set to the path of the program executable.
##
## ## Notes
## The current list of programs includes:
##
## - GENCCODE
## - PKGDATA
function(vcpkg_acquire_icu_tools VAR)
  set(EXPANDED_VAR ${${VAR}})
  if (EXPANDED_VAR)
    return()
  endif()

  set(PATHS ${DOWNLOADS}/tools/icu/bin64)
  set(URL "http://download.icu-project.org/files/icu4c/61.1/icu4c-61_1-Win64-MSVC2017.zip")
  set(ARCHIVE "icu4c-61_1-Win64-MSVC2017.zip")
  set(HASH b4ca25935fbf191ce8ce27497d3290bae9c5fb840a8bf18b7c8eb6619f47df321449b6f2710032bdc10908eae1cadcae11faddfda87601e57b00944ffcdda400)

  if(VAR MATCHES "GENCCODE")
    set(PROGNAME genccode)
  elseif(VAR MATCHES "PKGDATA")
    set(PROGNAME pkgdata)
  else()
    message(FATAL "unknown tool ${VAR} -- unable to acquire.")
  endif()

  macro(do_find)
    find_program(${VAR} ${PROGNAME} PATHS ${PATHS})
  endmacro()

  do_find()
  if("${${VAR}}" MATCHES "-NOTFOUND")
    vcpkg_download_distfile(ARCHIVE_PATH
      URLS ${URL}
      SHA512 ${HASH}
      FILENAME ${ARCHIVE}
    )

    file(MAKE_DIRECTORY ${DOWNLOADS}/tools/icu)
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E tar xzf ${ARCHIVE_PATH}
      WORKING_DIRECTORY ${DOWNLOADS}/tools/icu
    )

    do_find()
  endif()

  set(${VAR} "${${VAR}}" PARENT_SCOPE)
endfunction()
