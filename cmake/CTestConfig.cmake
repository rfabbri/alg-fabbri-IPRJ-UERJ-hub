# This file is copied to the build directory of each fork.
# It was adapted from the template downloaded from CDash.

## This file should be placed in the root directory of your project.
## Then modify the CMakeLists.txt file in the root directory of your
## project to incorporate the testing dashboard.
##
## # The following are required to submit to the CDash dashboard:
##   ENABLE_TESTING()
##   INCLUDE(CTest)

set(CTEST_PROJECT_NAME alg-fabbri-IPRJ-UERJ)
set(CTEST_NIGHTLY_START_TIME "01:00:00 UTC")

if(CMAKE_VERSION VERSION_GREATER 3.14)
  set(CTEST_SUBMIT_URL https://my.cdash.org/submit.php?project=alg-fabbri-IPRJ-UERJ)
else()
  set(CTEST_DROP_METHOD "https")
  set(CTEST_DROP_SITE "my.cdash.org")
  set(CTEST_DROP_LOCATION "/submit.php?project=alg-fabbri-IPRJ-UERJ")
endif()

set(CTEST_DROP_SITE_CDASH TRUE)
