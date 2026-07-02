import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Combinatorics.SimpleGraph.DegreeSum
import Mathlib.Combinatorics.SimpleGraph.Hasse
import Mathlib.Combinatorics.SimpleGraph.Circulant
import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected

set_option linter.unnecessarySimpa false

open BigOperators

namespace GraphGeneratedV1

/-- K_n as the complete graph on Fin n. -/
abbrev K (n : ℕ) : SimpleGraph (Fin n) :=
  SimpleGraph.completeGraph (Fin n)

/-- Candidate 1: K_n is top. -/
theorem K_eq_top (n : ℕ) :
    K n = (⊤ : SimpleGraph (Fin n)) := by
  simpa [K] using SimpleGraph.completeGraph_eq_top (Fin n)

/-- Candidate 2: K_(n+1) is connected. -/
theorem K_connected_succ (n : ℕ) :
    (K (n + 1)).Connected := by
  simpa [K] using SimpleGraph.connected_top (V := Fin (n + 1))

/-- Candidate 3: K_n is connected whenever n > 0. -/
theorem K_connected_of_pos {n : ℕ} (h : 0 < n) :
    (K n).Connected := by
  cases n with
  | zero =>
      cases h
  | succ n =>
      simpa [K] using SimpleGraph.connected_top (V := Fin (n + 1))

/-- Candidate 4: top graph on Fin n is connected whenever n > 0. -/
theorem top_connected_of_pos {n : ℕ} (h : 0 < n) :
    (⊤ : SimpleGraph (Fin n)).Connected := by
  cases n with
  | zero =>
      cases h
  | succ n =>
      simpa [SimpleGraph.completeGraph_eq_top] using
        SimpleGraph.connected_top (V := Fin (n + 1))

/-- Candidate 5: every vertex of K_(n+1) has degree n. -/
theorem K_degree_succ (n : ℕ) (v : Fin (n + 1)) :
    (K (n + 1)).degree v = n := by
  simpa [K] using SimpleGraph.complete_graph_degree (V := Fin (n + 1)) v

/-- Candidate 6: every vertex of top on Fin (n+1) has degree n. -/
theorem top_degree_succ (n : ℕ) (v : Fin (n + 1)) :
    (⊤ : SimpleGraph (Fin (n + 1))).degree v = n := by
  simpa [SimpleGraph.completeGraph_eq_top] using
    SimpleGraph.complete_graph_degree (V := Fin (n + 1)) v

/-- Candidate 7: K_n satisfies the degree-sum formula. -/
theorem K_sum_degrees_eq_twice_edges (n : ℕ) :
    (∑ v : Fin n, (K n).degree v) = 2 * (K n).edgeFinset.card := by
  simpa [K] using
    SimpleGraph.sum_degrees_eq_twice_card_edges
      (G := SimpleGraph.completeGraph (Fin n))

/-- Candidate 8: K_n has an even number of odd-degree vertices. -/
theorem K_even_card_odd_degree_vertices (n : ℕ) :
    Even {v : Fin n | Odd ((K n).degree v)}.card := by
  simpa [K] using
    SimpleGraph.even_card_odd_degree_vertices
      (G := SimpleGraph.completeGraph (Fin n))

/-- Candidate 9: pathGraph 2 is contained in K_2. -/
theorem pathGraph_two_le_K_two :
    SimpleGraph.pathGraph 2 ≤ K 2 := by
  simp [K, SimpleGraph.pathGraph_two_eq_top, SimpleGraph.completeGraph_eq_top]

/-- Candidate 10: pathGraph (n+1) is connected and contained in cycleGraph (n+1). -/
theorem path_connected_and_le_cycle (n : ℕ) :
    (SimpleGraph.pathGraph (n + 1)).Connected ∧
      SimpleGraph.pathGraph (n + 1) ≤ SimpleGraph.cycleGraph (n + 1) := by
  constructor
  · simpa using SimpleGraph.pathGraph_connected n
  · simpa using SimpleGraph.pathGraph_le_cycleGraph (n := n + 1)

/-- Candidate 11: every cycleGraph (n+3) is connected and 2-regular. -/
theorem cycle_connected_and_degree_two (n : ℕ) :
    (SimpleGraph.cycleGraph (n + 3)).Connected ∧
      ∀ v : Fin (n + 3), (SimpleGraph.cycleGraph (n + 3)).degree v = 2 := by
  constructor
  · simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using
      SimpleGraph.cycleGraph_connected (n := n + 2)
  · intro v
    simpa using SimpleGraph.cycleGraph_degree_three_le (n := n) (v := v)

end GraphGeneratedV1
