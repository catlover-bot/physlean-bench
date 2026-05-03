#!/bin/bash
#SBATCH --job-name=dsp_v2_xdom
#SBATCH --partition=gpu_short
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:3090:1
#SBATCH -w elm53
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/dsp_v2_xdom_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/dsp_v2_xdom_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache
export TRANSFORMERS_CACHE=$HF_HOME
export HF_HUB_CACHE=$HF_HOME/hub

OUT=/project/nlp-work11/$USER/physlean_trace_rc13_week_8cpu
XOUT=$OUT/cross_domain_physlib_v0
IN=$XOUT/deepseek_prompts_cross_domain_pilot_100.statement_only.jsonl
GEN=$XOUT/deepseek_v2_7b_generations_cross_domain_pilot_100.statement_only.jsonl

mkdir -p /project/nlp-work11/$USER/physlean_logs

echo "===== ENV ====="
date
hostname
nvidia-smi || true
python -V
python - <<'PY'
import torch
print("torch", torch.__version__)
print("cuda available", torch.cuda.is_available())
if torch.cuda.is_available():
    print("gpu", torch.cuda.get_device_name(0))
PY
echo "==============="

python scripts/run_deepseek_prover_v2_smoke.py \
  --input "$IN" \
  --output "$GEN" \
  --model deepseek-ai/DeepSeek-Prover-V2-7B \
  --max-new-tokens 512 \
  --temperature 0.2 \
  --top-p 0.95 \
  --num-samples 1

echo "===== DONE ====="
date
wc -l "$GEN"
