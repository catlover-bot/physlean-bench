#!/bin/bash
#SBATCH --job-name=eval_cs_xdom
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/eval_cs_xdom_%A_%a.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/eval_cs_xdom_%A_%a.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

PROJECT=/project/nlp-work11/$USER
CROSS=$PROJECT/crossdomain_trace/cslib_bench_v0/cross_domain_cslib_v0
BASE_WORK=$PROJECT/cslib_eval_work/cslib_eval_built

IDX=$(printf "%03d" "$SLURM_ARRAY_TASK_ID")

GEN=$CROSS/eval_chunks_cross_domain_pilot_100/generations_chunk_${IDX}.jsonl
META=$CROSS/eval_chunks_cross_domain_pilot_100/metadata_chunk_${IDX}.jsonl
OUT_DIR=$CROSS/eval_deepseek_v2_7b_cross_domain_pilot_100_chunks
OUT=$OUT_DIR/eval_chunk_${IDX}.jsonl

TASK_WORK=$PROJECT/cslib_eval_work/eval_cs_xdom_${SLURM_ARRAY_JOB_ID}_${IDX}

mkdir -p "$OUT_DIR"
rm -rf "$TASK_WORK"
mkdir -p "$TASK_WORK"

cleanup() {
  rm -rf "$TASK_WORK"
}
trap cleanup EXIT

echo "===== ENV ====="
date
hostname
echo "IDX=$IDX"
wc -l "$GEN" "$META"
echo "==============="

rsync -a --delete \
  --exclude='.lake/' \
  --exclude='.git/' \
  "$BASE_WORK"/ "$TASK_WORK"/

ln -s "$BASE_WORK/.lake" "$TASK_WORK/.lake"

python scripts/eval_generated_proofs_replace.py \
  --work-repo "$TASK_WORK" \
  --generations "$GEN" \
  --metadata "$META" \
  --output "$OUT" \
  --proof-field generated_proof \
  --timeout 600

date
wc -l "$OUT"
