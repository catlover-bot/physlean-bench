#!/usr/bin/env bash
set -euo pipefail

INPUT="${1:-experiments/graph_theorem_generation/generation_inputs/graph_v1_prompts_dsp_compatible.jsonl}"
OUTDIR="${2:-/project/nlp-work11/$USER/graph_theorem_generation/v1}"
OUTPUT="$OUTDIR/graph_v1_generations.jsonl"

if [ ! -f "$INPUT" ]; then
  echo "ERROR: input not found: $INPUT"
  exit 1
fi

mkdir -p "$OUTDIR" /project/nlp-work11/$USER/physlean_logs

sbatch <<SBATCH
#!/bin/bash
#SBATCH --job-name=graph_gen_gpu
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=06:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/graph_gen_gpu_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/graph_gen_gpu_%j.err

set -euo pipefail

cd /home/is/\$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache

INPUT="$INPUT"
OUTPUT="$OUTPUT"

echo "===== GRAPH GENERATION GPU JOB ====="
date
hostname
echo "INPUT=\$INPUT"
echo "OUTPUT=\$OUTPUT"
nvidia-smi || true
python --version

echo
echo "===== GENERATION START ====="
python scripts/run_deepseek_prover_v2_smoke.py \
  --input "\$INPUT" \
  --output "\$OUTPUT" \
  --model deepseek-ai/DeepSeek-Prover-V2-7B \
  --num-samples 1 \
  --max-new-tokens 768 \
  --temperature 0.2 \
  --top-p 0.95

echo
echo "===== GENERATION DONE ====="
date
wc -l "\$OUTPUT"
SBATCH
