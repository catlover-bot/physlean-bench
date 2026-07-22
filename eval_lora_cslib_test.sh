#!/bin/bash
#SBATCH --job-name=eval_lora_cs
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/eval_lora_cslib_test_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/eval_lora_cslib_test_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

PROJECT=/project/nlp-work11/$USER

WORK=$PROJECT/cslib_eval_work/cslib_eval_built
SFT=$PROJECT/finetune_data/physlib_cslib_sft_v0
RUN=$PROJECT/finetune_runs/mixed_lora_full_v0

GEN=$RUN/generations/cslib_test_83_lora_generations.jsonl
META=$SFT/cslib_test.sft.jsonl
OUT=$RUN/eval_cslib_test_83_lora.jsonl

echo "===== ENV ====="
date
hostname
echo "WORK=$WORK"
echo "GEN=$GEN"
echo "META=$META"
echo "OUT=$OUT"
wc -l "$GEN" "$META"
echo "==============="

python scripts/eval_generated_proofs_replace.py \
  --work-repo "$WORK" \
  --generations "$GEN" \
  --metadata "$META" \
  --output "$OUT" \
  --proof-field generated_proof \
  --timeout 600

echo "===== DONE ====="
date
wc -l "$OUT"
