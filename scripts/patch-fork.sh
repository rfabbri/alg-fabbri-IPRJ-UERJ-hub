#!/bin/bash
# This script applies all necessary patches to a fork's source code.
set -e
FORK_DIR=$1

echo "Patching fork in $FORK_DIR"

# Patch 1: Change benchmark::benchmark to benchmark
sed -i.bak 's/benchmark::benchmark/benchmark/g' "$FORK_DIR/alg/merge/benchmark/CMakeLists.txt"

# Patch 3: Change GTest::gtest_main to gtest gtest_main
sed -i.bak 's/GTest::gtest_main/gtest gtest_main/g' "$FORK_DIR/alg/merge/tests/CMakeLists.txt"

echo "Patching complete."
