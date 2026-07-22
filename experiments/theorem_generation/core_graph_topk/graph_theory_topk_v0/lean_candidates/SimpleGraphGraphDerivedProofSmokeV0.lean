import Mathlib.Combinatorics.SimpleGraph.Walks.Basic
import Mathlib.Combinatorics.SimpleGraph.Walks.Operations
import Mathlib.Combinatorics.SimpleGraph.Operations
import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Metric
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected
import Mathlib.Combinatorics.SimpleGraph.Clique
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Combinatorics.SimpleGraph.Walks.Maps

open scoped Sym2

namespace SimpleGraph

variable {V : Type*} {G : SimpleGraph V}

lemma graphDerived_edgeSet_cons_concat_proved
    {u v w x : V} (h₁ : G.Adj u v) (p : G.Walk v w) (h₂ : G.Adj w x) :
    ((p.cons h₁).concat h₂).edgeSet = insert s(w, x) (insert s(u, v) p.edgeSet) := by
  ext e
  simp [or_left_comm, or_assoc, or_comm]

lemma graphDerived_edgeSet_replaceVertex_adj_eq_notAdj_sdiff_proved
    [DecidableEq V] {s t : V} (ha : G.Adj s t) :
    (G.replaceVertex s t).edgeSet =
      (G.edgeSet \ G.incidenceSet t ∪ (s(·, t)) '' (G.neighborSet s)) \ {s(t, t)} := by
  simpa using (G.edgeSet_replaceVertex_of_adj ha)

lemma graphDerived_adj_iff_exists_edgeSet_subtype_proved
    {a b : V} :
    G.Adj a b ↔ ∃ e : G.edgeSet, e.1 = s(a, b) := by
  simpa using (adj_iff_exists_edge_coe (G := G) (a := a) (b := b))

lemma graphDerived_connected_exists_shortest_isPath_proved
    (hconn : G.Connected) (u v : V) :
    ∃ (p : G.Walk u v), p.IsPath ∧ p.length = G.dist u v := by
  simpa using (Connected.exists_path_of_dist (G := G) hconn u v)

lemma graphDerived_exists_mem_singleton_edges_of_not_reachable_deleteEdges_proved
    {u v : V} (w : G.Walk u v) {e : Sym2 V}
    (huv : ¬ (G.deleteEdges {e}).Reachable u v) :
    ∃ e' ∈ ({e} : Set (Sym2 V)), e' ∈ w.edges := by
  exact ⟨e, by simp, w.mem_edges_of_not_reachable_deleteEdges huv⟩

lemma graphDerived_isIndepSet_compl_compl_proved
    {s : Set V} :
    Gᶜᶜ.IsIndepSet s ↔ G.IsIndepSet s := by
  simp

lemma graphDerived_neighborFinset_compl_eq_filter_not_adj_proved
    [Fintype V] [DecidableEq V] [DecidableRel G.Adj] (v : V) :
    Gᶜ.neighborFinset v = Finset.univ.filter fun w => w ≠ v ∧ ¬ G.Adj v w := by
  ext w
  simp [neighborFinset_compl, and_left_comm, and_assoc, and_comm]

end SimpleGraph
