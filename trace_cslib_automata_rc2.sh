#!/bin/bash
#SBATCH --job-name=trace_cslib_auto
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/trace_cslib_automata_rc2_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/trace_cslib_automata_rc2_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv/bin/activate
export PYTHONUNBUFFERED=1

export REPO=/home/is/$USER/workspace/cslib
export OUT=/project/nlp-work11/$USER/crossdomain_trace/cslib_automata_rc2
export CACHE=/project/nlp-work11/$USER/cslib_cache_rc2
export TMPDIR=/tmp/cslib-auto-rc2-${SLURM_JOB_ID}
export RAY_TMPDIR=/tmp/ray-cslib-auto-rc2-${SLURM_JOB_ID}

rm -rf "$OUT"
mkdir -p "$OUT" "$CACHE" "$TMPDIR" "$RAY_TMPDIR"

echo "===== ENV ====="
date
hostname
echo "REPO=$REPO"
echo "OUT=$OUT"
echo "CACHE=$CACHE"
echo "TMPDIR=$TMPDIR"
echo "RAY_TMPDIR=$RAY_TMPDIR"
git -C "$REPO" rev-parse HEAD
cat "$REPO/lean-toolchain"
echo "==============="

physlean-bench trace-source \
  --repo-dir "$REPO" \
  --output-dir "$OUT" \
  --backend leandojo_v2 \
  --include-prefixes Cslib/Computability/Automata \
  --cache-dir "$CACHE" \
  --tmp-dir "$TMPDIR"

echo "===== DONE ====="
date
find "$OUT" -maxdepth 2 -type f | sort
ls -lh "$OUT"/traced_theorems.jsonl "$OUT"/trace_run_metadata.json 2>/dev/null || true
