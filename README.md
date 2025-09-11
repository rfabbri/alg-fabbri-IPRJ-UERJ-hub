# Superbuiild for algorithms and data structure projects

all forks lie in forks

## Running tests of all forks --------------------------------------------------
```
make test-all
```
### You can also submit to CDash and visualize the test matrix
First, reconfigure with `ccmake` and set SUBMIT_TO_CDASH to ON 
Run the test above.

The results will show up at:
https://my.cdash.org/index.php?project=alg-fabbri-IPRJ-UERJ

## Benchmarking multiple forks -------------------------------------------------

Build all forks
```
make build-all-forks
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
   * This should already be read by the first plot in index.html, usualy in gh-pages/index.html

### Testng benchmarks locally

cd bench
python -m http.server

Open the following URL in your browser:
http://localhost:8000
