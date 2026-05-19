#!/bin/bash
#SBATCH --job-name=dsp_cslib_xdom
#SBATCH --partition=gpu_long
#SBATCH --account=is-nlp
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/dsp_cslib_xdom_%A_%a.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/dsp_cslib_xdom_%A_%a.err

set -euo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

export PYTHONUNBUFFERED=1
export HF_HOME=/cl/work11/hf_cache

CROSS=/project/nlp-work11/$USER/crossdomain_trace/cslib_bench_v0/cross_domain_cslib_v0
CHUNK_DIR=$CROSS/deepseek_chunks_cross_domain_pilot_100
GEN_DIR=$CROSS/deepseek_v2_7b_generations_cross_domain_pilot_100_chunks

mkdir -p "$GEN_DIR"

IDX=$(printf "%03d" "$SLURM_ARRAY_TASK_ID")
INP=$CHUNK_DIR/chunk_${IDX}.jsonl
GEN=$GEN_DIR/chunk_${IDX}.jsonl

echo "===== ENV ====="
date
hostname
echo "IDX=$IDX"
echo "INP=$INP"
echo "GEN=$GEN"
nvidia-smi || true
python --version

python - <<'PY'
import sys, torch
print("torch", torch.__version__)
print("cuda available", torch.cuda.is_available())
if not torch.cuda.is_available():
    sys.exit(1)
name = torch.cuda.get_device_name(0)
cc = torch.cuda.get_device_capability(0)
mem = torch.cuda.get_device_properties(0).total_memory / 1024**3
print("gpu", name)
print("compute_capability", cc)
print("memory_gb", round(mem, 1))
if cc < (7, 5):
    print("ERROR: unsupported GPU")
    sys.exit(1)
if mem < 20:
    print("ERROR: GPU memory too small")
    sys.exit(1)
PY
echo "==============="

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
