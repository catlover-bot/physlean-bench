#!/bin/bash
#SBATCH --job-name=trace_cslib_pref
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/trace_cslib_prefix_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/trace_cslib_prefix_%j.err

set -euo pipefail

if [ -z "${PREFIX:-}" ]; then
  echo "ERROR: PREFIX is not set"
  exit 1
fi

if [ -z "${NAME:-}" ]; then
  NAME=$(echo "$PREFIX" | tr '/' '_' | tr '[:upper:]' '[:lower:]')
fi

cd /home/is/$USER/workspace/physlean-bench
source .venv/bin/activate
export PYTHONUNBUFFERED=1

export REPO=/home/is/$USER/workspace/cslib
export OUT=/project/nlp-work11/$USER/crossdomain_trace/cslib_parts/$NAME
export CACHE=/project/nlp-work11/$USER/cslib_cache_parts/$NAME
export TMPDIR=/tmp/t${SLURM_JOB_ID}
export RAY_TMPDIR=/tmp/r${SLURM_JOB_ID}

rm -rf "$OUT"
mkdir -p "$OUT" "$CACHE" "$TMPDIR" "$RAY_TMPDIR" /project/nlp-work11/$USER/physlean_logs

echo "===== ENV ====="
date
hostname
echo "PREFIX=$PREFIX"
echo "NAME=$NAME"
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
  --output-jsonl "$OUT/traced_theorems.jsonl" \
  --backend leandojo_v2 \
  --include-prefixes "$PREFIX" \
  --cache-dir "$CACHE" \
  --tmp-dir "$TMPDIR"

echo "===== DONE ====="
date
find "$OUT" -maxdepth 2 -type f | sort
wc -l "$OUT/traced_theorems.jsonl" 2>/dev/null || true
ls -lh "$OUT"/traced_theorems.jsonl "$OUT"/trace_run_metadata.json "$OUT"/trace_stats.json 2>/dev/null || true
