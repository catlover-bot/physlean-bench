#!/bin/bash
#SBATCH --job-name=eval_pv2_phys_chunk
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=8
#SBATCH --mem=96G
#SBATCH --time=12:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/eval_pv2_phys_chunk_%A_%a.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/eval_pv2_phys_chunk_%A_%a.err

set -euo pipefail

if [ -z "${MODE:-}" ]; then
  echo "ERROR: MODE is not set. Use MODE=base or MODE=lora."
  exit 1
fi

if [ "$MODE" != "base" ] && [ "$MODE" != "lora" ]; then
  echo "ERROR: MODE must be base or lora. MODE=$MODE"
  exit 1
fi

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

PROJECT=/project/nlp-work11/$USER
RUN=$PROJECT/prompt_experiments/prompt_v2_runs
CHUNK=$RUN/eval_chunks_physlib_valid_491

BASE_WORK=$PROJECT/physlean_eval_work/physlib_eval_smoke_built
TASK_WORK=$PROJECT/physlean_eval_work/physlib_eval_chunk_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}_${MODE}

IDX=$(printf "%03d" "$SLURM_ARRAY_TASK_ID")

META=$CHUNK/meta/metadata_chunk_${IDX}.jsonl
GEN=$CHUNK/$MODE/generations_chunk_${IDX}.jsonl
OUTDIR=$RUN/eval_physlib_valid_491_${MODE}_chunks
OUT=$OUTDIR/eval_chunk_${IDX}.jsonl

mkdir -p "$OUTDIR" "$PROJECT/physlean_logs"

echo "===== ENV ====="
date
hostname
echo "MODE=$MODE"
echo "IDX=$IDX"
echo "META=$META"
echo "GEN=$GEN"
echo "OUT=$OUT"
echo "BASE_WORK=$BASE_WORK"
echo "TASK_WORK=$TASK_WORK"
wc -l "$META" "$GEN"
echo "==============="

rm -rf "$TASK_WORK"
rsync -a "$BASE_WORK/" "$TASK_WORK/"

python scripts/eval_generated_proofs_replace.py \
  --work-repo "$TASK_WORK" \
  --generations "$GEN" \
  --metadata "$META" \
  --output "$OUT" \
  --proof-field generated_proof \
  --timeout 600

rm -rf "$TASK_WORK"

echo "===== DONE ====="
date
wc -l "$OUT"
