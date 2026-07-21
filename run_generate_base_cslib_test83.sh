#!/bin/bash
#SBATCH --job-name=gen_base_cs83
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/gen_base_cslib83_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/gen_base_cslib83_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache
export TOKENIZERS_PARALLELISM=false

SFT=/project/nlp-work11/$USER/finetune_data/physlib_cslib_sft_v0
RUN=/project/nlp-work11/$USER/finetune_runs/mixed_lora_full_v0
OUTDIR=$RUN/generations

mkdir -p "$OUTDIR" /project/nlp-work11/$USER/physlean_logs

INPUT=$SFT/cslib_test.sft.jsonl
OUTPUT=$OUTDIR/cslib_test_83_base_sft_prompt_generations.jsonl

echo "===== ENV ====="
date
hostname
nvidia-smi || true
python --version
echo "==============="

rm -f "$OUTPUT"

python scripts/finetune/generate_base_sft.py \
  --model deepseek-ai/DeepSeek-Prover-V2-7B \
  --input "$INPUT" \
  --output "$OUTPUT" \
  --max-new-tokens 512

echo "===== DONE ====="
date
wc -l "$INPUT" "$OUTPUT"
ls -lh "$OUTPUT"
