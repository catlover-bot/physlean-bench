#!/bin/bash
#SBATCH --job-name=gen_pv2_physval
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/gen_prompt_v2_physlib_valid_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/gen_prompt_v2_physlib_valid_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache
export TOKENIZERS_PARALLELISM=false

PROJECT=/project/nlp-work11/$USER
PROMPT=$PROJECT/prompt_experiments/prompt_v2
RUN=$PROJECT/prompt_experiments/prompt_v2_runs
ADAPTER=$PROJECT/finetune_runs/mixed_lora_full_v0/adapter

mkdir -p "$RUN/generations" "$PROJECT/physlean_logs"

INPUT=$PROMPT/physlib_valid.prompt_v2.jsonl

BASE_OUT=$RUN/generations/physlib_valid_491_base_prompt_v2.jsonl
LORA_OUT=$RUN/generations/physlib_valid_491_mixed_lora_prompt_v2.jsonl

echo "===== ENV ====="
date
hostname
nvidia-smi || true
python --version
wc -l "$INPUT"
echo "==============="

echo "===== BASE GENERATION ====="
rm -f "$BASE_OUT"

python scripts/finetune/generate_base_sft.py \
  --model deepseek-ai/DeepSeek-Prover-V2-7B \
  --input "$INPUT" \
  --output "$BASE_OUT" \
  --max-new-tokens 512

echo "===== LORA GENERATION ====="
rm -f "$LORA_OUT"

python scripts/finetune/generate_with_lora.py \
  --base-model deepseek-ai/DeepSeek-Prover-V2-7B \
  --adapter "$ADAPTER" \
  --input "$INPUT" \
  --output "$LORA_OUT" \
  --max-new-tokens 512

echo "===== DONE ====="
date
wc -l "$INPUT" "$BASE_OUT" "$LORA_OUT"
ls -lh "$BASE_OUT" "$LORA_OUT"
