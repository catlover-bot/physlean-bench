#!/bin/bash
#SBATCH --job-name=run_trace_physlean_rc12
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=8
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/run_trace_rc12_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/run_trace_rc12_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv/bin/activate
export PYTHONUNBUFFERED=1

# ---- important: keep Ray socket path short ----
export RAY_TMPDIR=/tmp/ray-${SLURM_JOB_ID}
export TMPDIR=/tmp/tmp-${SLURM_JOB_ID}
mkdir -p "$RAY_TMPDIR" "$TMPDIR"

# ---- output/cache on project storage ----
export OUT=/project/nlp-work11/$USER/physlean_trace_rc12_week_8cpu
export LOGDIR=/project/nlp-work11/$USER/physlean_logs
mkdir -p "$OUT" "$LOGDIR"

# Optional cleanup of previous rc12 only
rm -rf "$OUT"
mkdir -p "$OUT"

export SRC_URL=https://github.com/leanprover-community/physlib.git

echo "===== ENV ====="
date
hostname
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
echo "RAY_TMPDIR=$RAY_TMPDIR"
echo "TMPDIR=$TMPDIR"
echo "OUT=$OUT"
echo "==============="

physlean-bench trace-source \
  --src-url "$SRC_URL" \
  --out-dir "$OUT" \
  --backend leandojo_v2

echo "===== DONE ====="
date

# cleanup local tmp
rm -rf "$RAY_TMPDIR" "$TMPDIR"
