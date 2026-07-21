#!/bin/bash
#SBATCH --job-name=dsp_v2_cs
#SBATCH --partition=gpu_short
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/dsp_v2_cslib_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/dsp_v2_cslib_%j.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache

COUT=/project/nlp-work11/$USER/crossdomain_trace/cslib_bench_v0
INP=$COUT/deepseek_prompts_test_statement_only.jsonl
GEN=$COUT/deepseek_v2_7b_generations_test_statement_only_smoke20.jsonl

echo "===== ENV ====="
date
hostname
nvidia-smi || true
python --version
python - <<'PY'
import torch
print("torch", torch.__version__)
print("cuda available", torch.cuda.is_available())
if torch.cuda.is_available():
    print("gpu", torch.cuda.get_device_name(0))
PY
echo "==============="

python scripts/run_deepseek_prover_v2_smoke.py \
  --input "$INP" \
  --output "$GEN" \
  --model deepseek-ai/DeepSeek-Prover-V2-7B \
  --limit 20 \
  --num-samples 1 \
  --max-new-tokens 512 \
  --temperature 0.0 \
  --top-p 1.0

echo "===== DONE ====="
date
wc -l "$GEN"
