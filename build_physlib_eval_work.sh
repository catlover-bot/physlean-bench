#!/bin/bash
#SBATCH --job-name=build_physlib_eval
#SBATCH --partition=lang_week
#SBATCH --account=lang
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --output=/project/nlp-work11/%u/physlean_logs/build_physlib_eval_%j.out
#SBATCH --error=/project/nlp-work11/%u/physlean_logs/build_physlib_eval_%j.err

set -euo pipefail

WORK=/project/nlp-work11/$USER/physlean_eval_work/physlib_eval_smoke_built

cd "$WORK"

echo "===== ENV ====="
date
hostname
pwd
echo "lean-toolchain:"
cat lean-toolchain
echo "==============="

echo "===== CACHE GET ====="
lake exe cache get || true

echo "===== BUILD PHYSLIB ====="
# Usually this target exists for the local Lean library.
# If it fails because the target name is unknown, the script falls back to full lake build.
if lake build Physlib; then
  echo "lake build Physlib succeeded"
else
  echo "lake build Physlib failed; trying full lake build"
  lake build
fi

echo "===== CHECK TARGET FILE ====="
lake env lean Physlib/QuantumMechanics/DDimensions/Operators/Commutation.lean

echo "===== DONE ====="
date
