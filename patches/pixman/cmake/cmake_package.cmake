include(CMakePackageConfigHelpers)
set(ConfigPackageLocation lib/cmake/pixman)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/pixman/PixmanConfigVersion.cmake"
  VERSION 
    ${PIXMAN_VERSION}
  COMPATIBILITY 
    AnyNewerVersion
)

export(
  EXPORT
    PixmanTargets
  FILE 
    "${CMAKE_CURRENT_BINARY_DIR}/pixman/PixmanTargets.cmake"
  NAMESPACE 
    Upstream::
)

configure_file(cmake/PixmanConfig.cmake
  "${CMAKE_CURRENT_BINARY_DIR}/pixman/PixmanConfig.cmake"
  COPYONLY
)

install(
  EXPORT
    PixmanTargets
  FILE
    PixmanTargets.cmake
  NAMESPACE
    Upstream::
  DESTINATION
    ${ConfigPackageLocation}
)

install(
  FILES
    "${CMAKE_CURRENT_BINARY_DIR}/pixman/PixmanConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/pixman/PixmanConfigVersion.cmake"
  DESTINATION
    ${ConfigPackageLocation}
  COMPONENT
    Devel
)