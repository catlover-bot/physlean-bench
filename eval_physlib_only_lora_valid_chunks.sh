#!/bin/bash
#SBATCH --job-name=eval_phys_only
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/eval_phys_only_%A_%a.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/eval_phys_only_%A_%a.err

set -euo pipefail

if [ -z "${MODE:-}" ]; then
  echo "ERROR: MODE is not set. Use MODE=base or MODE=physlib_lora."
  exit 1
fi

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

PROJECT=/project/nlp-work11/$USER
RUN=$PROJECT/finetune_runs/physlib_lora_full_v0
CHUNK=$RUN/eval_chunks_physlib_valid_491

BASE_WORK=$PROJECT/physlean_eval_work/physlib_eval_smoke_built

IDX=$(printf "%03d" "$SLURM_ARRAY_TASK_ID")

META=$CHUNK/meta/metadata_chunk_${IDX}.jsonl
GEN=$CHUNK/$MODE/generations_chunk_${IDX}.jsonl

OUTDIR=$RUN/eval_physlib_valid_491_${MODE}_chunks
OUT=$OUTDIR/eval_chunk_${IDX}.jsonl

TASK_WORK=/tmp/physlib_eval_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}_${MODE}
export TMPDIR=/tmp/tmp_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}_${MODE}

mkdir -p "$OUTDIR" "$PROJECT/physlean_logs" "$TMPDIR"

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
echo "TMPDIR=$TMPDIR"
wc -l "$META" "$GEN"
echo "==============="

echo "===== COPY WORK TO /tmp ====="
date
rm -rf "$TASK_WORK"

rsync -a \
  --exclude='docs' \
  "$BASE_WORK/" "$TASK_WORK/"

echo "===== COPY DONE ====="
date
du -sh "$TASK_WORK"

echo "===== EVAL START ====="
date

python scripts/eval_generated_proofs_replace.py \
  --work-repo "$TASK_WORK" \
  --generations "$GEN" \
  --metadata "$META" \
  --output "$OUT" \
  --proof-field generated_proof \
  --timeout 600

echo "===== EVAL DONE ====="
date
wc -l "$OUT"

rm -rf "$TASK_WORK" "$TMPDIR"

echo "===== DONE ====="
date
