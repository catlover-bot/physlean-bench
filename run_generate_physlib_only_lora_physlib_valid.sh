#!/bin/bash
#SBATCH --job-name=gen_phys_only_val
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/gen_physlib_only_lora_valid_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/gen_physlib_only_lora_valid_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache
export TOKENIZERS_PARALLELISM=false

PROJECT=/project/nlp-work11/$USER
PROMPT=$PROJECT/prompt_experiments/prompt_v2
RUN=$PROJECT/finetune_runs/physlib_lora_full_v0
ADAPTER=$RUN/adapter

mkdir -p "$RUN/generations" "$PROJECT/physlean_logs"

INPUT=$PROMPT/physlib_valid.prompt_v2.jsonl
OUTPUT=$RUN/generations/physlib_valid_491_physlib_only_lora_prompt_v2.jsonl

rm -f "$OUTPUT"

echo "===== ENV ====="
date
hostname
nvidia-smi || true
python --version
wc -l "$INPUT"
echo "==============="

python scripts/finetune/generate_with_lora.py \
  --base-model deepseek-ai/DeepSeek-Prover-V2-7B \
  --adapter "$ADAPTER" \
  --input "$INPUT" \
  --output "$OUTPUT" \
  --max-new-tokens 512

echo "===== DONE ====="
date
wc -l "$INPUT" "$OUTPUT"
ls -lh "$OUTPUT"
