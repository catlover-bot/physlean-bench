#!/bin/bash
#SBATCH --job-name=eval_pv2_physval
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=8
#SBATCH --mem=96G
#SBATCH --time=24:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/eval_prompt_v2_physlib_valid_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/eval_prompt_v2_physlib_valid_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

PROJECT=/project/nlp-work11/$USER
RUN=$PROJECT/prompt_experiments/prompt_v2_runs
EVAL=$RUN/eval_ready
WORK=$PROJECT/physlean_eval_work/physlib_eval_smoke_built

BASE_GEN=$EVAL/physlib_valid_491_base_prompt_v2.eval_ready.bytelevel.jsonl
LORA_GEN=$EVAL/physlib_valid_491_mixed_lora_prompt_v2.eval_ready.bytelevel.jsonl
META=$EVAL/physlib_valid_491.metadata.eval_ready.jsonl

BASE_OUT=$RUN/eval_physlib_valid_491_base_prompt_v2.jsonl
LORA_OUT=$RUN/eval_physlib_valid_491_mixed_lora_prompt_v2.jsonl

echo "===== ENV ====="
date
hostname
echo "WORK=$WORK"
wc -l "$META" "$BASE_GEN" "$LORA_GEN"
echo "==============="

echo "===== EVAL BASE ====="
python scripts/eval_generated_proofs_replace.py \
  --work-repo "$WORK" \
  --generations "$BASE_GEN" \
  --metadata "$META" \
  --output "$BASE_OUT" \
  --proof-field generated_proof \
  --timeout 600

echo "===== EVAL LORA ====="
python scripts/eval_generated_proofs_replace.py \
  --work-repo "$WORK" \
  --generations "$LORA_GEN" \
  --metadata "$META" \
  --output "$LORA_OUT" \
  --proof-field generated_proof \
  --timeout 600

echo "===== DONE ====="
date
wc -l "$BASE_OUT" "$LORA_OUT"
