#!/bin/bash
#SBATCH --job-name=gen_lora_stmt83
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/gen_lora_stmt83_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/gen_lora_stmt83_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache
export TOKENIZERS_PARALLELISM=false

RUN=/project/nlp-work11/$USER/finetune_runs/mixed_lora_full_v0
ADAPTER=$RUN/adapter

INPUT=$RUN/eval_ready/cslib_test_83_statement_only_prompt_input.jsonl
OUTPUT=$RUN/generations/cslib_test_83_lora_statement_prompt_generations.jsonl

mkdir -p "$RUN/generations" /project/nlp-work11/$USER/physlean_logs

rm -f "$OUTPUT"

python scripts/finetune/generate_with_lora.py \
  --base-model deepseek-ai/DeepSeek-Prover-V2-7B \
  --adapter "$ADAPTER" \
  --input "$INPUT" \
  --output "$OUTPUT" \
  --max-new-tokens 512

date
wc -l "$INPUT" "$OUTPUT"
