cmake_minimum_required(VERSION 3.3)

project(pthreads-win32 VERSION 2.10.0 LANGUAGES C)

include(GNUInstallDirs)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    add_definitions(-DPTW32_ARCHAMD64)
else()
    add_definitions(-DPTW32_ARCHX86)
endif()

if(MSVC)
    add_definitions(-DPTW32_RC_MSC)
    set(pthreads_compiler V)
elseif(CMAKE_COMPILER_IS_GNUCXX)
    set(pthreads_compiler G)
else()
    message("WARNING: pthreads-win32 doesn't recognize your compiler!")
endif()

if(PTHREADS_BUILD_CPP)
    set(pthreads_exception_scheme CE)
    add_definitions(-D__CLEANUP_CXX)
    message("Building pthreads-win32 with C++ exception handling.")
elseif(PTHREADS_BUILD_SEH)
    set(pthreads_exception_scheme SE)
    add_definitions(-D__CLEANUP_SEH)
    message("Building pthreads-win32 with Microsoft SEH exception handling.")
else()
    # defaults to C - setjmp/longjmp
    set(pthreads_exception_scheme C)
    add_definitions(-D__CLEANUP_C)
    message("Building pthreads-win32 with C setjmp/longjmp (default/recommended exception scheme).")
endif()
set(pthreads_compatibility_version 2)

set(pthreads_public_header
    _ptw32.h
    pthread.h
    sched.h
    semaphore.h
)

add_library(pthreads SHARED
    pthread.c
    version.rc
    ${pthreads_public_header}
)

target_compile_definitions(pthreads PRIVATE HAVE_CONFIG_H)
target_include_directories(pthreads PRIVATE .)

set_target_properties(pthreads PROPERTIES
    OUTPUT_NAME
    "pthreads${pthreads_compiler}${pthreads_exception_scheme}${pthreads_compatibility_version}"
    PUBLIC_HEADER
    "${pthreads_public_header}"
)

install(TARGETS pthreads
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR} COMPONENT headers)
