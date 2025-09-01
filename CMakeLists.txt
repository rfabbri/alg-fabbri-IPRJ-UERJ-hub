# This is the superbuild orchestrator for the alg project and its forks.
cmake_minimum_required(VERSION 3.10)
project(alg-hub)

include(ExternalProject)

# --- User-Facing Options ---
option(alg_BUILD_TESTS "Build tests for all projects" ON)
option(SUBMIT_TO_CDASH "Submit test results to CDash." OFF)

# --- Project Configuration ---
set(DEPS_INSTALL_DIR ${CMAKE_BINARY_DIR}/install)

# --- External Project for googletest ---
ExternalProject_Add(ep_googletest
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/googletest
  CMAKE_ARGS -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${DEPS_INSTALL_DIR}
  BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config Release
  INSTALL_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --target install --config Release
)

# --- External Project for benchmark ---
ExternalProject_Add(ep_benchmark
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/benchmark
  CMAKE_ARGS -DCMAKE_BUILD_TYPE=Release -DBENCHMARK_ENABLE_TESTING=OFF -DCMAKE_INSTALL_PREFIX=${DEPS_INSTALL_DIR} -DCMAKE_PREFIX_PATH=${DEPS_INSTALL_DIR}
  DEPENDS ep_googletest
  BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config Release
  INSTALL_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --target install --config Release
)

# --- Build all forks uniformly ---
add_custom_target(build-all-forks COMMENT "Building all external fork projects")
file(GLOB FORK_DIRS LIST_DIRECTORIES true "${CMAKE_CURRENT_SOURCE_DIR}/forks/*")

foreach(FORK_PATH ${FORK_DIRS})
  if(IS_DIRECTORY ${FORK_PATH})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/forks/" "" FORK_NAME ${FORK_PATH})
    ExternalProject_Add(fork_${FORK_NAME}
      DEPENDS ep_benchmark
      SOURCE_DIR ${FORK_PATH}
      BINARY_DIR ${CMAKE_BINARY_DIR}/fork_builds/${FORK_NAME}
      PATCH_COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/scripts/patch-forks <SOURCE_DIR>
      CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=Release
        -Dalg_BUILD_TESTS=${alg_BUILD_TESTS}
        -Dalg_BUILD_THIRD_PARTY=OFF
        -DCMAKE_PREFIX_PATH=${DEPS_INSTALL_DIR}
      INSTALL_COMMAND ""
      TEST_COMMAND ""
    )
    add_dependencies(build-all-forks fork_${FORK_NAME})
    message(STATUS "Added external project for fork: ${FORK_NAME}")
  endif()
endforeach()

# --- Custom user-facing targets ---
add_custom_target(run-benchmarks
  COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/scripts/run-benchmarks ${CMAKE_BINARY_DIR}
  DEPENDS build-all-forks
  COMMENT "Running all benchmarks and collecting results"
  VERBATIM
)

add_custom_target(test-all
  COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/scripts/run-tests ${CMAKE_BINARY_DIR} ${SUBMIT_TO_CDASH}
  DEPENDS build-all-forks
  COMMENT "Running all tests for main project and forks"
  VERBATIM
)
