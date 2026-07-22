#!/bin/bash
#SBATCH --job-name=lora_cslib_full
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=96G
#SBATCH --time=12:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/lora_cslib_full_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/lora_cslib_full_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache
export TOKENIZERS_PARALLELISM=false

SFT=/project/nlp-work11/$USER/finetune_data/physlib_cslib_sft_v0
OUT=/project/nlp-work11/$USER/finetune_runs/cslib_lora_full_v0

mkdir -p "$OUT" /project/nlp-work11/$USER/physlean_logs

python scripts/finetune/train_lora_sft.py \
  --model deepseek-ai/DeepSeek-Prover-V2-7B \
  --train-jsonl "$SFT/cslib_train.sft.jsonl" \
  --valid-jsonl "$SFT/cslib_valid.sft.jsonl" \
  --output-dir "$OUT" \
  --max-length 1024 \
  --epochs 3 \
  --lr 1e-4 \
  --lora-r 16 \
  --lora-alpha 32 \
  --lora-dropout 0.05

date
find "$OUT/adapter" -maxdepth 1 -type f | sort
du -sh "$OUT"
