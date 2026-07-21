#!/bin/bash
#SBATCH --job-name=phys_test_lora_eval
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=3-00:00:00
#SBATCH --output=/project/nlp-work11/%u/finetune_runs/physlib_lora_full_v0/logs/eval_physlib_test_680_physlib_lora_%j.out
#SBATCH --error=/project/nlp-work11/%u/finetune_runs/physlib_lora_full_v0/logs/eval_physlib_test_680_physlib_lora_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench

RUN=/project/nlp-work11/$USER/finetune_runs/physlib_lora_full_v0

python scripts/eval_generated_proofs_replace.py \
  --work-repo /project/nlp-work11/$USER/physlean-bench-run/data/source/physlib \
  --generations "$RUN/generations/physlib_test_680_physlib_lora_prompt_v2.eval_ready.short_theorem_id.jsonl" \
  --metadata "$RUN/eval_ready/physlib_test_680.metadata.eval_ready.short_theorem_id.jsonl" \
  --output "$RUN/eval_physlib_test_680_physlib_lora_prompt_v2.fixed_mathlib.jsonl" \
  --proof-field generated_proof \
  --timeout 300
