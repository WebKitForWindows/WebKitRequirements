# Create the data library
#
# Currently the pkgdata executable doesn't seem to have the ability to cross
# compile so instead genccode is used for creating an object file. This means
# a .so can't be made

set(ICU_DATA_DAT ${CMAKE_CURRENT_SOURCE_DIR}/in/icudt${ICU_MAJOR_VERSION}l.dat)

if (BUILD_SHARED_LIBS AND WIN32)
  message(STATUS "Building using pkgdata")

  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/data)
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/temp)

  set(ICU_DATA_LST ${CMAKE_CURRENT_BINARY_DIR}/icudata.lst)
  set(ICU_DATA_DLL ${CMAKE_CURRENT_BINARY_DIR}/icudt${ICU_MAJOR_VERSION}.dll)
  set(ICU_DATA_LIB ${CMAKE_CURRENT_BINARY_DIR}/icudt.lib)

  add_custom_command(
    OUTPUT ${ICU_DATA_LST}
    DEPENDS ${ICU_DATA_DAT}
    COMMAND icupkg
      -x * --list
      ${ICU_DATA_DAT}
      > ${ICU_DATA_LST}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  )

  add_custom_command(
    OUTPUT ${ICU_DATA_DLL} ${ICU_DATA_LIB}
    DEPENDS ${ICU_DATA_LST}
    COMMAND pkgdata
      --verbose
      --force-prefix
      --copyright
      --mode library
      --entrypoint icudt${ICU_MAJOR_VERSION}
      --name icudt${ICU_MAJOR_VERSION}
      --libname icudt${ICU_MAJOR_VERSION}
      --tempdir ${CMAKE_CURRENT_BINARY_DIR}/temp
      --destdir ${CMAKE_CURRENT_BINARY_DIR}
      --sourcedir .
      ${ICU_DATA_LST}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  )

  add_custom_target(icudt DEPENDS ${ICU_DATA_DLL})

  install(FILES ${ICU_DATA_DLL} DESTINATION ${CMAKE_INSTALL_BINDIR})
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/icudt.lib DESTINATION ${CMAKE_INSTALL_LIBDIR})
else ()
  message(STATUS "Building using genccode directly")

  if (BUILD_SHARED_LIBS)
    message(WARNING "A shared library is only supported on Windows")
  endif ()
  
  set(ICU_DATA_OBJ ${CMAKE_CURRENT_BINARY_DIR}/icudt${ICU_MAJOR_VERSION}l_dat.obj)
  
  add_custom_command(
    OUTPUT ${ICU_DATA_OBJ}
    COMMAND genccode 
      --match-arch $<TARGET_OBJECTS:stubdata> --object
      --entrypoint icudt${ICU_MAJOR_VERSION}
      --destdir ${CMAKE_CURRENT_BINARY_DIR}
      ${ICU_DATA_DAT}
    DEPENDS ${ICU_DATA_DAT}
  )
  
  add_library(icudt STATIC ${ICU_DATA_OBJ})
  set_target_properties(icudt PROPERTIES LINKER_LANGUAGE C)
  add_dependencies(icudt stubdata)

  install(
    TARGETS icudt
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  )
endif ()
