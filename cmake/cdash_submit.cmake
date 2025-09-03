# cmake/cdash_submit.cmake
# This script is executed by ctest -S to submit results to CDash.

# These variables are passed from the calling script (e.g., run-tests) via ctest -S -DVAR=VALUE

set(CTEST_SOURCE_DIRECTORY "${FORK_PATH}")
set(CTEST_BINARY_DIRECTORY "${FORK_BUILD_DIR}")
set(CTEST_BUILD_NAME "${FORK_NAME}")

if(SUBMIT_FLAG STREQUAL "NO_SUBMIT")
  set(DO_SUBMIT FALSE)
else()
  set(DO_SUBMIT TRUE)
endif()

# Run tests and submit
message(STATUS "Running tests for fork: ${FORK_NAME}")

ctest_start("Experimental")
ctest_test()

if(DO_SUBMIT)
  ctest_submit()
else()
  message(STATUS "Skipping CDash submission (DO_SUBMIT is FALSE).")
endif()
