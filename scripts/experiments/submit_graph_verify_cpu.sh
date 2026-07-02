#!/usr/bin/env bash
set -euo pipefail

LEAN_FILE="${1:-experiments/graph_theorem_generation/graph_new_theorem_candidates_v0.lean}"

if [ ! -f "$LEAN_FILE" ]; then
  echo "ERROR: Lean file not found: $LEAN_FILE"
  exit 1
fi

mkdir -p /project/nlp-work11/$USER/physlean_logs

sbatch <<SBATCH
#!/bin/bash
#SBATCH --job-name=graph_verify
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/graph_verify_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/graph_verify_%j.err

set -euo pipefail

BENCH_DIR=/home/is/\$USER/workspace/physlean-bench
CSLIB_DIR=/home/is/\$USER/workspace/cslib
LEAN_FILE=$LEAN_FILE

echo "===== GRAPH VERIFY CPU JOB ====="
date
hostname
echo "BENCH_DIR=\$BENCH_DIR"
echo "CSLIB_DIR=\$CSLIB_DIR"
echo "LEAN_FILE=\$LEAN_FILE"

cd "\$CSLIB_DIR"

echo
echo "===== LEAN VERIFY START ====="
lake env lean "\$BENCH_DIR/\$LEAN_FILE"

echo
echo "===== LEAN VERIFY DONE ====="
date
SBATCH
