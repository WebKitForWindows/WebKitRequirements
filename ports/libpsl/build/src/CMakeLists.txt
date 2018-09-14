find_package(PythonInterp 2.7.0 REQUIRED)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/suffixes_dafsa.c
    DEPENDS ${PSL_SOURCE_PATH}/public_suffix_list.dat
    COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/psl-make-dafsa --output-format=cxx+ ${PSL_SOURCE_PATH}/public_suffix_list.dat ${CMAKE_CURRENT_SOURCE_DIR}/suffixes_dafsa.c
    VERBATIM)

add_custom_target(GENERATE_DAFSA DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/suffixes_dafsa.c)

list(APPEND LIBPSL_SOURCES
    lookup_string_in_fixed_set.c
    psl.c
)

add_library(libpsl ${LIBPSL_SOURCES})
add_dependencies(libpsl GENERATE_DAFSA)
target_link_libraries(libpsl ${LIBPSL_LIBS})
target_include_directories(libpsl PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

install(
    TARGETS libpsl
    EXPORT LibPSLTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
