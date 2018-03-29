cmake_minimum_required(VERSION 3.10)

include(GNUInstallDirs)

set(ICU_MAJOR_VERSION 61)
set(ICU_MINOR_VERSION 1)

project(ICU VERSION ${ICU_MAJOR_VERSION}.${ICU_MINOR_VERSION} LANGUAGES C CXX)

if (MSVC)
  set(RTTI_FLAG "/GR")
  set(ICU_DEFINITIONS
    _CRT_SECURE_NO_DEPRECATE
    U_PLATFORM_USES_ONLY_WIN32_API=1
  )
else ()
  set(RTTI_FLAG "-frtti")
endif ()

add_subdirectory(stubdata)
add_subdirectory(data)
add_subdirectory(common)
add_subdirectory(i18n)
