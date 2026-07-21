#!/bin/bash
#SBATCH --job-name=lora_mix_full
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=96G
#SBATCH --time=24:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/lora_mix_full_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/lora_mix_full_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache
export TOKENIZERS_PARALLELISM=false

SFT=/project/nlp-work11/$USER/finetune_data/physlib_cslib_sft_v0
OUT=/project/nlp-work11/$USER/finetune_runs/mixed_lora_full_v0

mkdir -p /project/nlp-work11/$USER/physlean_logs
mkdir -p "$OUT"

echo "===== ENV ====="
date
hostname
nvidia-smi || true
python --version

python - <<'PY'
import sys
import torch

print("torch", torch.__version__)
print("cuda", torch.cuda.is_available())

if not torch.cuda.is_available():
    print("ERROR: CUDA is not available")
    sys.exit(1)

print("gpu", torch.cuda.get_device_name(0))
print("compute_capability", torch.cuda.get_device_capability(0))
print("memory_gb", round(torch.cuda.get_device_properties(0).total_memory / 1024**3, 1))
PY

echo "===== TRAIN ====="

python scripts/finetune/train_lora_sft.py \
  --model deepseek-ai/DeepSeek-Prover-V2-7B \
  --train-jsonl "$SFT/mixed_train.sft.jsonl" \
  --valid-jsonl "$SFT/mixed_valid.sft.jsonl" \
  --output-dir "$OUT" \
  --max-length 1024 \
  --epochs 1 \
  --lr 2e-4 \
  --lora-r 16 \
  --lora-alpha 32 \
  --lora-dropout 0.05

echo "===== DONE ====="
date
find "$OUT" -maxdepth 3 -type f | sort | tail -80
du -sh "$OUT"
