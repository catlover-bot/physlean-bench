#!/bin/bash
#SBATCH --job-name=build_cslib
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/build_cslib_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/build_cslib_%j.err

set -euo pipefail

REPO=/home/is/$USER/workspace/cslib

cd "$REPO"

echo "===== ENV ====="
date
hostname
pwd
git rev-parse HEAD
cat lean-toolchain
echo "==============="

lake exe cache get || true
lake build

echo "===== DONE ====="
date
