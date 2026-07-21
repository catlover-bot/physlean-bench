#!/bin/bash
#SBATCH -J sg_typecheck
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 2
#SBATCH --mem=8G
#SBATCH -t 01:00:00
#SBATCH -o /project/nlp-work11/%u/theorem_generation/graph_theory_topk_v0/logs/%x-%j.out
#SBATCH -e /project/nlp-work11/%u/theorem_generation/graph_theory_topk_v0/logs/%x-%j.err

set -euxo pipefail

WORK=/project/nlp-work11/$USER/physlean_eval_work/physlib_eval_smoke_built
SRC=/project/nlp-work11/$USER/theorem_generation/graph_theory_topk_v0/lean_candidates/SimpleGraphGraphDerivedCandidatesV0.lean

cd "$WORK"
cp "$SRC" SimpleGraphGraphDerivedCandidatesV0.lean

echo "=== lean typecheck with sorry on compute node ==="
lake env lean SimpleGraphGraphDerivedCandidatesV0.lean
