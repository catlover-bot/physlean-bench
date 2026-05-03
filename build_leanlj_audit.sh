#!/bin/bash
#SBATCH --job-name=build_leanlj
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/build_leanlj_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/build_leanlj_%j.err

set -euo pipefail

REPO=/home/is/$USER/workspace/LeanLJ

cd "$REPO"

echo "===== ENV ====="
date
hostname
pwd
git rev-parse HEAD
cat lean-toolchain 2>/dev/null || true
echo "==============="

lake exe cache get || true
lake build

echo "===== DONE ====="
date
