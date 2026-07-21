#!/bin/bash
#SBATCH -J joint_phys_cslib
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 8
#SBATCH --mem=32G
#SBATCH -t 06:00:00
#SBATCH -o /project/nlp-work11/%u/physlean_eval_work/joint_physlib_cslib_v0/logs/%x-%j.out
#SBATCH -e /project/nlp-work11/%u/physlean_eval_work/joint_physlib_cslib_v0/logs/%x-%j.err

set -euxo pipefail

USER_NAME="$(whoami)"
ROOT="/project/nlp-work11/$USER_NAME/physlean_eval_work/joint_physlib_cslib_v0"
WORK="$ROOT/work"
JOINT="$WORK/joint_project"

PHYS_SRC="/project/nlp-work11/$USER_NAME/physlean_eval_work/physlib_eval_smoke_built"
CSLIB_SRC="/home/is/$USER_NAME/workspace/cslib"

rm -rf "$JOINT"
mkdir -p "$JOINT"

cd "$JOINT"

cat > lean-toolchain <<'EOF'
leanprover/lean4:v4.29.1
EOF

cat > lakefile.lean <<EOF
import Lake
open Lake DSL

package «JointPhyslibCslib»

require «Physlib» from "$PHYS_SRC"
require «cslib» from "$CSLIB_SRC"

@[default_target]
lean_lib JointPhyslibCslib where
EOF

mkdir -p JointPhyslibCslib

cat > JointPhyslibCslib/Smoke.lean <<'EOF'
import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic
import Cslib

#check Constants.ℏ
#check Electromagnetism.FreeSpace
EOF

echo "=== lake env ==="
lake env lean --version

echo "=== lake update ==="
lake update

echo "=== build smoke ==="
lake env lean JointPhyslibCslib/Smoke.lean
