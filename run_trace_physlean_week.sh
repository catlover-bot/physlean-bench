#!/bin/bash
set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv/bin/activate
export PYTHONUNBUFFERED=1

export SRC_URL=https://github.com/leanprover-community/physlib.git
export WORK_ROOT=/home/is/$USER/physlean-bench-run-home
export SRC_COMMIT=$(git -C "$WORK_ROOT/data/source/physlib" rev-parse HEAD)

export HOME_TRACE_ROOT=/project/nlp-work11/$USER/physlean_trace_rc10_week
export RAY_TMPDIR=/project/nlp-work11/$USER/ray_tmp_rc10_week

rm -rf "$HOME_TRACE_ROOT"
mkdir -p "$HOME_TRACE_ROOT"
mkdir -p "$RAY_TMPDIR"

physlean-bench trace-source \
  --backend leandojo_v2 \
  --repo-dir "$WORK_ROOT/data/source/physlib" \
  --source-url "$SRC_URL" \
  --expected-source-commit "$SRC_COMMIT" \
  --output-dir "$HOME_TRACE_ROOT" \
  --output-jsonl "$HOME_TRACE_ROOT/traced_theorems.jsonl"
