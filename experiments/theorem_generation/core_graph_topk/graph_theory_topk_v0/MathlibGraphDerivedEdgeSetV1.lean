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
