# This script is executed by ctest -S to submit results to CDash.
# It can operate in two modes, controlled by the REPORT_MODE variable.
#
# TestOnly (default): Assumes the project is already built. Only runs ctest_test().
# FullReport: Performs a clean configure, build, and test cycle.

# --- Common Configuration ---
set(CTEST_SOURCE_DIRECTORY "${FORK_PATH}")
set(CTEST_BINARY_DIRECTORY "${FORK_BUILD_DIR}")
set(CTEST_SITE "${SITE_NAME}")
set(CTEST_BUILD_NAME "${FORK_NAME}")

if(SUBMIT_FLAG STREQUAL "NO_SUBMIT")
  set(DO_SUBMIT FALSE)
else()
  set(DO_SUBMIT TRUE)
endif()

# --- Mode-Specific Logic ---
ctest_start("Experimental")

if(REPORT_MODE STREQUAL "FullReport")
  # FullReport Mode: Configure, build, test, and submit.
  message(STATUS "Processing fork in FullReport mode: ${FORK_NAME}")
  set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
  list(APPEND CTEST_CONFIGURE_options
    "-DCMAKE_BUILD_TYPE=Release"
    "-Dalg_BUILD_TESTS=ON"
    "-Dalg_BUILD_THIRD_PARTY=OFF"
    "-DCMAKE_PREFIX_PATH=${DEPS_INSTALL_DIR}"
    "-DCMAKE_PROJECT_INCLUDE=${PROJECT_ROOT}/cmake/inject.cmake"
  )
  ctest_configure(OPTIONS "${CTEST_CONFIGURE_options}")

  # Force verbose output from the build tool to get detailed error messages
  set(CTEST_BUILD_COMMAND "${CMAKE_CTEST_COMMAND} --build-and-test ${CTEST_SOURCE_DIRECTORY} ${CTEST_BINARY_DIRECTORY} --build-makeprogram ${CMAKE_MAKE_PROGRAM} --build-options -v")
  if(NOT CTEST_BUILD_COMMAND)
    set(CTEST_BUILD_COMMAND "${CMAKE_MAKE_PROGRAM} VERBOSE=1")
  endif()

  ctest_build(CAPTURE_CMAKE_ERROR CTEST_BUILD_ERROR)

  if(CTEST_BUILD_RESULT EQUAL 0)
    message(STATUS "Build successful for ${FORK_NAME}. Running tests...")
    ctest_test()
  else()
    message(STATUS "Build failed for ${FORK_NAME}. Skipping tests.")
  endif()

else()
  # TestOnly Mode (default): Just run tests.
  message(STATUS "Running tests for fork: ${FORK_NAME}")
  ctest_test()
endif()

# --- Submission ---
if(DO_SUBMIT)
  ctest_submit()
else()
  message(STATUS "Skipping CDash submission (DO_SUBMIT is FALSE).")
endif()
