### Running tests of all forks
make test-all

#### Benchmarking multiple forks

all forks lie in third_party/forks

Build all forks
```
cmake --build build --target build_all_forks
```

Generate cohesive benchmark for all forks comparing different implementations of
the same files

```
make run-benchmarks
```

  This single command will now:
   * Build all the alg targets for your main project.
   * Build all the alg targets for every fork inside third_party/forks.
   * Execute the scripts/run-benchmarks script.
   * The script will then run the benchmark for the toplevel project and every fork.
   * It will save the individual JSON results (with names prefixed) in build/benchmark_results.
   * Finally, it will merge them all into a single build/benchmark_results/combined.json.


