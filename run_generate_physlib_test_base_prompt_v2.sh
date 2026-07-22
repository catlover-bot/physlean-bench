#!/bin/bash
#SBATCH --job-name=gen_phys_test_base
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=96G
#SBATCH --time=12:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/gen_phys_test_base_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/gen_phys_test_base_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache
export TOKENIZERS_PARALLELISM=false

PROJECT=/project/nlp-work11/$USER
INPUT=$PROJECT/prompt_experiments/prompt_v2/physlib_test.prompt_v2.jsonl
OUTDIR=$PROJECT/prompt_experiments/prompt_v2_runs/generations
OUT=$OUTDIR/physlib_test_680_base_prompt_v2.jsonl

mkdir -p "$OUTDIR" "$PROJECT/physlean_logs"

echo "===== ENV ====="
date
hostname
nvidia-smi || true
echo "INPUT=$INPUT"
echo "OUT=$OUT"
wc -l "$INPUT"
echo "==============="

python scripts/finetune/generate_base_sft.py \
  --model deepseek-ai/DeepSeek-Prover-V2-7B \
  --input "$INPUT" \
  --output "$OUT" \
  --max-new-tokens 512

echo "===== DONE ====="
date
wc -l "$OUT"
ls -lh "$OUT"
