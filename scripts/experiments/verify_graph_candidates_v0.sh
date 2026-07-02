#!/usr/bin/env bash
set -euo pipefail

CSLIB_DIR="${CSLIB_DIR:-/home/is/$USER/workspace/cslib}"
BENCH_DIR="${BENCH_DIR:-/home/is/$USER/workspace/physlean-bench}"

cd "$CSLIB_DIR"
lake env lean "$BENCH_DIR/experiments/graph_theorem_generation/graph_new_theorem_candidates_v0.lean"
