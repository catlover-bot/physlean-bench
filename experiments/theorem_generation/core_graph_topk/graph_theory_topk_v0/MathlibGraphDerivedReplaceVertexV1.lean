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
