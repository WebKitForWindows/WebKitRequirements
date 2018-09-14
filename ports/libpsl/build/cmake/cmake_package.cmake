include(CMakePackageConfigHelpers)
set(ConfigPackageLocation share/libpsl/cmake)


write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/libpsl/LibPSLConfigVersion.cmake"
  VERSION 
    ${LIBPSL_VERSION}
  COMPATIBILITY 
    AnyNewerVersion
)

export(
  EXPORT
    LibPSLTargets
  FILE 
    "${CMAKE_CURRENT_BINARY_DIR}/libpsl/LibPSLTargets.cmake"
  NAMESPACE 
    Upstream::
)

configure_file(cmake/LibPSLConfig.cmake
  "${CMAKE_CURRENT_BINARY_DIR}/libpsl/LibPSLConfig.cmake"
  COPYONLY
)

install(
  EXPORT
    LibPSLTargets
  FILE
    LibPSLTargets.cmake
  NAMESPACE
    Upstream::
  DESTINATION
    ${ConfigPackageLocation}
)

install(
  FILES
    "${CMAKE_CURRENT_BINARY_DIR}/libpsl/LibPSLConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/libpsl/LibPSLConfigVersion.cmake"
  DESTINATION
    ${ConfigPackageLocation}
  COMPONENT
    Devel
)