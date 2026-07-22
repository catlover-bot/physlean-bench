#!/bin/bash
#SBATCH --job-name=gen_cs_only_val
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/gen_cslib_only_lora_valid_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/gen_cslib_only_lora_valid_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache
export TOKENIZERS_PARALLELISM=false

PROJECT=/project/nlp-work11/$USER
PROMPT=$PROJECT/prompt_experiments/prompt_v2
RUN=$PROJECT/finetune_runs/cslib_lora_full_v0
ADAPTER=$RUN/adapter

mkdir -p "$RUN/generations" "$PROJECT/physlean_logs"

INPUT=$PROMPT/cslib_valid.prompt_v2.jsonl
OUTPUT=$RUN/generations/cslib_valid_41_cslib_only_lora_prompt_v2.jsonl

echo "===== ENV ====="
date
hostname
nvidia-smi || true
python --version
wc -l "$INPUT"
echo "==============="

rm -f "$OUTPUT"

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
