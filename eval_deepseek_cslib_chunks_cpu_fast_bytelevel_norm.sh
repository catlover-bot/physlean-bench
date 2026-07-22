#!/bin/bash
#SBATCH --job-name=eval_dsp_cs_bnorm
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/eval_dsp_cslib_bnorm_%A_%a.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/eval_dsp_cslib_bnorm_%A_%a.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

PROJECT=/project/nlp-work11/$USER
COUT=$PROJECT/crossdomain_trace/cslib_bench_v0
BASE_WORK=$PROJECT/cslib_eval_work/cslib_eval_built

CHUNK_DIR=$COUT/eval_chunks_deepseek_statement_only_bytelevel_normalized
EVAL_OUT_DIR=$COUT/eval_deepseek_v2_7b_statement_only_chunks_bytelevel_normalized_fast
mkdir -p "$EVAL_OUT_DIR"

IDX=$(printf "%03d" "${SLURM_ARRAY_TASK_ID}")

GEN=$CHUNK_DIR/generations_chunk_${IDX}.jsonl
META=$CHUNK_DIR/metadata_chunk_${IDX}.jsonl
OUT=$EVAL_OUT_DIR/eval_chunk_${IDX}.jsonl

TASK_WORK=$PROJECT/cslib_eval_work/chunk_eval_bnorm_${SLURM_ARRAY_JOB_ID}_${IDX}

cleanup() {
  rm -rf "$TASK_WORK"
}
trap cleanup EXIT

echo "===== ENV ====="
date
hostname
echo "IDX=$IDX"
echo "GEN=$GEN"
echo "META=$META"
echo "OUT=$OUT"
echo "TASK_WORK=$TASK_WORK"
wc -l "$GEN" "$META"
echo "==============="

test -f "$GEN"
test -f "$META"
test -d "$BASE_WORK/.lake"

rm -rf "$TASK_WORK"
mkdir -p "$TASK_WORK"

echo "===== COPY SOURCE ONLY ====="
date

rsync -a --delete \
  --exclude='.lake/' \
  --exclude='.git/' \
  "$BASE_WORK"/ "$TASK_WORK"/

ln -s "$BASE_WORK/.lake" "$TASK_WORK/.lake"

date
du -sh "$TASK_WORK" || true
ls -ld "$TASK_WORK/.lake"

echo "===== EVAL ====="
date

python scripts/eval_generated_proofs_replace.py \
  --work-repo "$TASK_WORK" \
  --generations "$GEN" \
  --metadata "$META" \
  --output "$OUT" \
  --proof-field generated_proof \
  --timeout 600

echo "===== DONE ====="
date
wc -l "$OUT"
