#!/bin/bash
#SBATCH --job-name=gen_phys_test_lora
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=96G
#SBATCH --time=12:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/gen_phys_test_lora_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/gen_phys_test_lora_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache
export TOKENIZERS_PARALLELISM=false

PROJECT=/project/nlp-work11/$USER
RUN=$PROJECT/finetune_runs/physlib_lora_full_v0

INPUT=$PROJECT/prompt_experiments/prompt_v2/physlib_test.prompt_v2.jsonl
ADAPTER=$RUN/adapter
OUTDIR=$RUN/generations
OUT=$OUTDIR/physlib_test_680_physlib_lora_prompt_v2.jsonl

mkdir -p "$OUTDIR" "$PROJECT/physlean_logs"

echo "===== ENV ====="
date
hostname
nvidia-smi || true
echo "INPUT=$INPUT"
echo "ADAPTER=$ADAPTER"
echo "OUT=$OUT"
wc -l "$INPUT"
ls -lh "$ADAPTER"
echo "==============="

python scripts/finetune/generate_with_lora.py \
  --base-model deepseek-ai/DeepSeek-Prover-V2-7B \
  --adapter "$ADAPTER" \
  --input "$INPUT" \
  --output "$OUT" \
  --max-new-tokens 512

echo "===== DONE ====="
date
wc -l "$OUT"
ls -lh "$OUT"
