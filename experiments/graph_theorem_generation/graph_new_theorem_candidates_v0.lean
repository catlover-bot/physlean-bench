import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Combinatorics.SimpleGraph.DegreeSum
import Mathlib.Combinatorics.SimpleGraph.Hasse
import Mathlib.Combinatorics.SimpleGraph.Circulant
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected

open BigOperators

namespace GraphGenerated

/-- K_n as a complete graph on Fin n. -/
abbrev K (n : ℕ) : SimpleGraph (Fin n) :=
  SimpleGraph.completeGraph (Fin n)

/-- Candidate 1: K_n is definitionally the complete graph on Fin n. -/
theorem K_eq_completeGraph (n : ℕ) :
    K n = SimpleGraph.completeGraph (Fin n) := by
  rfl

/-- Candidate 2: K_n is top. -/
theorem K_eq_top (n : ℕ) :
    K n = (⊤ : SimpleGraph (Fin n)) := by
  simpa [K] using SimpleGraph.completeGraph_eq_top (Fin n)

/-- Candidate 3: every vertex of K_n has degree n - 1. -/
theorem K_degree (n : ℕ) (v : Fin n) :
    (K n).degree v = n - 1 := by
  simpa [K] using SimpleGraph.complete_graph_degree (V := Fin n) v

/-- Candidate 4: every vertex of top on Fin n has degree n - 1. -/
theorem top_degree_fin (n : ℕ) (v : Fin n) :
    (⊤ : SimpleGraph (Fin n)).degree v = n - 1 := by
  simpa [SimpleGraph.completeGraph_eq_top] using
    SimpleGraph.complete_graph_degree (V := Fin n) v

/-- Candidate 5: K_(n+1) is connected. -/
theorem K_connected_succ (n : ℕ) :
    (K (n + 1)).Connected := by
  simpa [K] using SimpleGraph.connected_top (V := Fin (n + 1))

/-- Candidate 6: top on Fin (n+1) is connected. -/
theorem top_connected_fin_succ (n : ℕ) :
    (⊤ : SimpleGraph (Fin (n + 1))).Connected := by
  simpa [SimpleGraph.completeGraph_eq_top] using
    SimpleGraph.connected_top (V := Fin (n + 1))

/-- Candidate 7: path graph with n+1 vertices is connected. -/
theorem path_connected_succ (n : ℕ) :
    (SimpleGraph.pathGraph (n + 1)).Connected := by
  simpa using SimpleGraph.pathGraph_connected n

/-- Candidate 8: cycle graph with n+1 vertices is connected. -/
theorem cycle_connected_succ (n : ℕ) :
    (SimpleGraph.cycleGraph (n + 1)).Connected := by
  simpa using SimpleGraph.cycleGraph_connected (n := n)

/-- Candidate 9: every vertex in cycle graph with n+3 vertices has degree 2. -/
theorem cycle_degree_two (n : ℕ) (v : Fin (n + 3)) :
    (SimpleGraph.cycleGraph (n + 3)).degree v = 2 := by
  simpa using SimpleGraph.cycleGraph_degree_three_le (n := n) (v := v)

/-- Candidate 10: path graph is a subgraph of cycle graph on the same vertex type. -/
theorem path_le_cycle (n : ℕ) :
    SimpleGraph.pathGraph n ≤ SimpleGraph.cycleGraph n := by
  simpa using SimpleGraph.pathGraph_le_cycleGraph (n := n)

end GraphGenerated
