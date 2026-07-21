import Mathlib.LinearAlgebra.FiniteDimensional
import Mathlib.Data.Fintype.Card
import Physlib.QFT.QED.AnomalyCancellation.BasisLinear
import Physlib.QFT.QED.AnomalyCancellation.Even.BasisLinear

lemma PureU1.finrank_AnomalyFreeLinear_le_basisa_card
    (n : ℕ) :
    Module.finrank ℚ (((PureU1 n.succ).LinSols)) ≤
      Fintype.card ((Fin n.succ) ⊕ (Fin n.succ)) := by
  have hA := PureU1.BasisLinear.finrank_AnomalyFreeLinear
    (n := n)
  have hB := PureU1.VectorLikeEvenPlane.basisa_card
    (n := n)
  dsimp at hA hB
  have hcard :
      Fintype.card ((Fin n.succ) ⊕ (Fin n.succ)) =
        Module.finrank ℚ (PureU1 (2 * n.succ)).LinSols := by
    simpa using hB
  have hpos : 0 ≤ (n : ℤ) := by exact_mod_cast (Nat.zero_le n)
  have hcast :
      (Module.finrank ℚ (((PureU1 n.succ).LinSols))) =
        (n : ℤ) := by exact_mod_cast hA
  have hcardcast :
      (Fintype.card ((Fin n.succ) ⊕ (Fin n.succ))) =
        (2 * n.succ : ℤ) := by
    have : Fintype.card ((Fin n.succ) ⊕ (Fin n.succ)) = n.succ + n.succ := by
      simp
    have : (Fintype.card ((Fin n.succ) ⊕ (Fin n.succ)) : ℤ) =
        (n.succ + n.succ : ℕ) := by
      exact_mod_cast this.symm
    have : (Fintype.card ((Fin n.succ) ⊕ (Fin n.succ)) : ℤ) =
        (2 * n.succ : ℕ) := by
      simpa [two_mul, Nat.add_comm, Nat.add_left_comm, Nat.add_assoc] using this
    simpa using this
  have hineq :
      (n : ℤ) ≤ (2 * n.succ : ℤ) := by
    have : (n : ℤ) ≤ (2 * n.succ : ℕ) := by
      exact_mod_cast Nat.le_mul_of_pos_right (Nat.lt_succ_self _)
    simpa using this
  have hineq' :
      (Module.finrank ℚ (((PureU1 n.succ).LinSols))) ≤
        (Fintype.card ((Fin n.succ) ⊕ (Fin n.succ))) := by
    have := le_trans (by simpa [hcast] using hineq)
                      (le_of_eq (by simpa [hcardcast]))
    simpa using this
  exact_mod_cast hineq'
