#!/bin/bash
#SBATCH -J mathlib_edge_gd1
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 4
#SBATCH -o /project/nlp-work11/%u/theorem_generation/graph_theory_topk_v0/logs/mathlib_edge_gd1-%j.out
#SBATCH -e /project/nlp-work11/%u/theorem_generation/graph_theory_topk_v0/logs/mathlib_edge_gd1-%j.err

set -euo pipefail

WORK=/project/nlp-work11/$USER/physlean_eval_work/physlib_eval_smoke_built
OUT=/project/nlp-work11/$USER/theorem_generation/graph_theory_topk_v0

cd "$WORK"

cat > "$OUT/MathlibGraphDerivedEdgeSetV1.lean" <<'LEAN'
import Mathlib.Combinatorics.SimpleGraph.Walks.Operations

open scoped Sym2

namespace SimpleGraph

variable {V : Type*} {G : SimpleGraph V}

theorem graphDerived_edgeSet_cons_concat
    {u v w x : V}
    (h₁ : G.Adj u v)
    (p : G.Walk v w)
    (h₂ : G.Adj w x) :
    ((p.cons h₁).concat h₂).edgeSet =
      insert s(w, x) (insert s(u, v) p.edgeSet) := by
  rw [Walk.edgeSet_concat, Walk.edgeSet_cons]

end SimpleGraph
LEAN

lake env lean "$OUT/MathlibGraphDerivedEdgeSetV1.lean"
