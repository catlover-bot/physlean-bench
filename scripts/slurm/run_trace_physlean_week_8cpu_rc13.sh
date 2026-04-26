#!/bin/bash
#SBATCH --job-name=run_trace_physlean_rc13
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=8
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/run_trace_rc13_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/run_trace_rc13_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv/bin/activate
export PYTHONUNBUFFERED=1

# ---- important: keep Ray socket path short ----
export RAY_TMPDIR=/tmp/ray-${SLURM_JOB_ID}
export TMPDIR=/tmp/tmp-${SLURM_JOB_ID}
mkdir -p "$RAY_TMPDIR" "$TMPDIR"

# ---- persistent paths on project storage ----
export SRC_URL=https://github.com/leanprover-community/physlib.git
export REPO_PARENT=/project/nlp-work11/$USER/physlean_repos
export REPO_DIR=$REPO_PARENT/physlib
export OUT=/project/nlp-work11/$USER/physlean_trace_rc13_week_8cpu
export CACHE_DIR=/project/nlp-work11/$USER/physlean_cache_rc13
export LOGDIR=/project/nlp-work11/$USER/physlean_logs

mkdir -p "$REPO_PARENT" "$OUT" "$CACHE_DIR" "$LOGDIR"

# Fresh output for rc13
rm -rf "$OUT"
mkdir -p "$OUT"

# Clone Physlib if needed
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "Cloning physlib into $REPO_DIR"
  git clone "$SRC_URL" "$REPO_DIR"
else
  echo "Using existing physlib repo at $REPO_DIR"
fi

echo "===== ENV ====="
date
hostname
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
echo "RAY_TMPDIR=$RAY_TMPDIR"
echo "TMPDIR=$TMPDIR"
echo "REPO_DIR=$REPO_DIR"
echo "OUT=$OUT"
echo "CACHE_DIR=$CACHE_DIR"
echo "==============="

echo "===== REPO ====="
git -C "$REPO_DIR" rev-parse HEAD
git -C "$REPO_DIR" status --short
echo "==============="

physlean-bench trace-source \
  --repo-dir "$REPO_DIR" \
  --output-dir "$OUT" \
  --output-jsonl "$OUT/traced_theorems.jsonl" \
  --source-url "$SRC_URL" \
  --backend leandojo_v2 \
  --cache-dir "$CACHE_DIR"

echo "===== DONE ====="
date
ls -lh "$OUT/traced_theorems.jsonl" "$OUT/trace_run_metadata.json" 2>/dev/null || true

# cleanup local tmp only
rm -rf "$RAY_TMPDIR" "$TMPDIR"
