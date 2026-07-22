#!/bin/bash
#SBATCH --job-name=dsp_v2_cs_all
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/dsp_v2_cslib_all_%A_%a.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/dsp_v2_cslib_all_%A_%a.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache

COUT=/project/nlp-work11/$USER/crossdomain_trace/cslib_bench_v0
CHUNK_DIR=$COUT/deepseek_chunks_statement_only
GEN_DIR=$COUT/deepseek_v2_7b_generations_test_statement_only_chunks

mkdir -p "$GEN_DIR"

IDX=$(printf "%03d" "${SLURM_ARRAY_TASK_ID}")
INP=$CHUNK_DIR/chunk_${IDX}.jsonl
GEN=$GEN_DIR/chunk_${IDX}.jsonl

echo "===== ENV ====="
date
hostname
echo "SLURM_ARRAY_TASK_ID=${SLURM_ARRAY_TASK_ID}"
echo "INP=$INP"
echo "GEN=$GEN"
nvidia-smi || true
python --version

python - <<'PY'
import sys
import torch

print("torch", torch.__version__)
print("cuda available", torch.cuda.is_available())

if not torch.cuda.is_available():
    print("ERROR: CUDA is not available", flush=True)
    sys.exit(1)

name = torch.cuda.get_device_name(0)
cc = torch.cuda.get_device_capability(0)
mem_gb = torch.cuda.get_device_properties(0).total_memory / 1024**3

print("gpu", name)
print("compute_capability", cc)
print("memory_gb", round(mem_gb, 1))

if cc < (7, 5):
    print(f"ERROR: unsupported GPU for this PyTorch build: {name}, cc={cc}", flush=True)
    sys.exit(1)

if mem_gb < 20:
    print(f"ERROR: GPU memory likely too small for 7B model: {mem_gb:.1f} GB", flush=True)
    sys.exit(1)
PY

echo "==============="

test -f "$INP"
rm -f "$GEN"

python scripts/run_deepseek_prover_v2_smoke.py \
  --input "$INP" \
  --output "$GEN" \
  --model deepseek-ai/DeepSeek-Prover-V2-7B \
  --num-samples 1 \
  --max-new-tokens 512 \
  --temperature 0.0 \
  --top-p 1.0

echo "===== DONE ====="
date
wc -l "$INP" "$GEN"
