add_library(stubdata OBJECT stubdata.cpp)
target_include_directories(stubdata PRIVATE
  ${CMAKE_SOURCE_DIR}/common
)
