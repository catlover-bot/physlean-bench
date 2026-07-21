#!/bin/bash
#SBATCH --job-name=gen_lora_cs
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/gen_lora_cslib_test_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/gen_lora_cslib_test_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache
export TOKENIZERS_PARALLELISM=false

SFT=/project/nlp-work11/$USER/finetune_data/physlib_cslib_sft_v0
ADAPTER=/project/nlp-work11/$USER/finetune_runs/mixed_lora_full_v0/adapter
OUTDIR=/project/nlp-work11/$USER/finetune_runs/mixed_lora_full_v0/generations

mkdir -p "$OUTDIR" /project/nlp-work11/$USER/physlean_logs

INPUT=$SFT/cslib_test.sft.jsonl
OUTPUT=$OUTDIR/cslib_test_83_lora_generations.jsonl

echo "===== ENV ====="
date
hostname
nvidia-smi || true
python --version

python - <<'PY'
import sys, torch
print("torch", torch.__version__)
print("cuda", torch.cuda.is_available())
if not torch.cuda.is_available():
    sys.exit(1)
print("gpu", torch.cuda.get_device_name(0))
print("compute_capability", torch.cuda.get_device_capability(0))
print("memory_gb", round(torch.cuda.get_device_properties(0).total_memory / 1024**3, 1))
PY

echo "===== INPUT / OUTPUT ====="
wc -l "$INPUT"
echo "$OUTPUT"
echo "=========================="

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
