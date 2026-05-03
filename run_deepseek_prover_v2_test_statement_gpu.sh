#!/bin/bash
#SBATCH --job-name=dsp_v2_test_stmt
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:q6000:1
#SBATCH -w elm26
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/dsp_v2_test_stmt_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/dsp_v2_test_stmt_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache
export TRANSFORMERS_CACHE=$HF_HOME
export HF_HUB_CACHE=$HF_HOME/hub

OUT=/project/nlp-work11/$USER/physlean_trace_rc13_week_8cpu
IN=$OUT/eval_subsets/deepseek_prompts_test_statement_only.jsonl
GEN=$OUT/eval_subsets/deepseek_v2_7b_generations_test_statement_only.jsonl

mkdir -p /project/nlp-work11/$USER/physlean_logs
mkdir -p $OUT/eval_subsets

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
