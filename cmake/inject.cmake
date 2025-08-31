# This script is injected into the configuration of external projects (forks)

if(DEFINED CMAKE_PREFIX_PATH)
  include_directories(SYSTEM ${CMAKE_PREFIX_PATH}/include)
  link_directories(${CMAKE_PREFIX_PATH}/lib)
endif()

find_package(benchmark REQUIRED)
find_package(GTest REQUIRED)
include(GoogleTest)
