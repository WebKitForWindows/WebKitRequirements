find_package(PythonInterp 2.7.0 REQUIRED)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/suffixes_dafsa.h
    DEPENDS ${PSL_SOURCE_PATH}/public_suffix_list.dat
    COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/psl-make-dafsa --output-format=cxx+ ${PSL_SOURCE_PATH}/public_suffix_list.dat ${CMAKE_CURRENT_SOURCE_DIR}/suffixes_dafsa.h
    VERBATIM)

add_custom_target(GENERATE_DAFSA DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/suffixes_dafsa.h)

list(APPEND LIBPSL_SOURCES
    lookup_string_in_fixed_set.c
    psl.c
)

add_library(psl ${LIBPSL_SOURCES})
add_dependencies(psl GENERATE_DAFSA)
target_link_libraries(psl ${LIBPSL_LIBS})
target_include_directories(psl PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

install(
    TARGETS psl
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
