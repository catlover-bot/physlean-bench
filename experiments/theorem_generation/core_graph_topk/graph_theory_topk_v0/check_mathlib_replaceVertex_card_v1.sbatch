#!/bin/bash
#SBATCH -J mathlib_card_gd1
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 4
#SBATCH -o /project/nlp-work11/%u/theorem_generation/graph_theory_topk_v0/logs/mathlib_card_gd1-%j.out
#SBATCH -e /project/nlp-work11/%u/theorem_generation/graph_theory_topk_v0/logs/mathlib_card_gd1-%j.err

set -euo pipefail

WORK=/project/nlp-work11/$USER/physlean_eval_work/physlib_eval_smoke_built
OUT=/project/nlp-work11/$USER/theorem_generation/graph_theory_topk_v0

cd "$WORK"

cat > "$OUT/MathlibGraphDerivedReplaceVertexV1.lean" <<'LEAN'
import Mathlib.Combinatorics.SimpleGraph.Operations
import Mathlib.Combinatorics.SimpleGraph.Finite

namespace SimpleGraph

variable {V : Type*} {G : SimpleGraph V}

theorem graphDerived_card_edgeFinset_replaceVertex_adj_add_one
    [Fintype V] [DecidableEq V] [DecidableRel G.Adj]
    {s t : V} (ha : G.Adj s t) :
    (G.replaceVertex s t).edgeFinset.card + 1 =
      G.edgeFinset.card + G.degree s - G.degree t := by
  have hcard := G.card_edgeFinset_replaceVertex_of_adj ha
  have hdeg_pos : 0 < G.degree s := ha.degree_pos_left
  have hdeg_le : G.degree t ≤ G.edgeFinset.card :=
    G.degree_le_card_edgeFinset t
  omega

end SimpleGraph
LEAN

lake env lean "$OUT/MathlibGraphDerivedReplaceVertexV1.lean"
