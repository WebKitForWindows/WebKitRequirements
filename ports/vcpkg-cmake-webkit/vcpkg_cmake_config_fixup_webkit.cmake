include_guard(GLOBAL)

function(vcpkg_cmake_config_fixup)
    if (NOT VCPKG_DISABLE_CMAKE_FIXUP)
        _vcpkg_cmake_config_fixup(${ARGV})
        return()
    endif ()

    message(STATUS "Fixing CMake config files disabled. Files will be removed!")
    cmake_parse_arguments(PARSE_ARGV 0 "arg" "" "PACKAGE_NAME;CONFIG_PATH" "")

    if(NOT arg_PACKAGE_NAME)
        set(arg_PACKAGE_NAME "${PORT}")
    endif()
    if(NOT arg_CONFIG_PATH)
        set(arg_CONFIG_PATH "share/${arg_PACKAGE_NAME}")
    endif()

    file(GLOB cmake_files "${CURRENT_PACKAGES_DIR}/${arg_CONFIG_PATH}/*.cmake")
    file(GLOB cmake_debug_files "${CURRENT_PACKAGES_DIR}/debug/${arg_CONFIG_PATH}/*.cmake")
    file(REMOVE ${cmake_files} ${cmake_debug_files})
endfunction()
