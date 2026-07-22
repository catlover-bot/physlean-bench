import Physlib.QFT.QED.AnomalyCancellation.LowDim.Three
import Physlib.QFT.QED.AnomalyCancellation.Basic
import Mathlib

lemma PureU1.Three.three_sol_zero_cube_sum
  (S : (PureU1 3).Sols) :
  (S.val (0 : Fin 3)) ^ 3 = 0 ∨ (S.val (1 : Fin 3)) ^ 3 = 0 ∨ (S.val (2 : Fin 3)) ^ 3 = 0 :=
by
  have hcube := PureU1.pureU1_cube (n := 3) S
  have hzero := PureU1.Three.three_sol_zero S
  classical
  revert hcube
  have hfin : (Finset.univ : Finset (Fin 3)) = {0, 1, 2} := by
    ext i
    fin_cases i <;> simp
  intro hcube
  have : ∑ i : Fin 3, (S.val i) ^ 3 = (S.val 0) ^ 3 + (S.val 1) ^ 3 + (S.val 2) ^ 3 := by
    simpa [hfin, Finset.sum_insert, Finset.sum_singleton, Finset.mem_singleton,
      Finset.mem_insert, not_false]
  have hsum := congrArg id hcube
  have hsum' : (S.val 0) ^ 3 + (S.val 1) ^ 3 + (S.val 2) ^ 3 = 0 := by
    simpa [this] using hcube
  cases hzero with
  | inl h0 =>
      left
      simpa [h0]
  | inr hrest =>
      cases hrest with
      | inl h1 =>
          right
          left
          simpa [h1]
      | inr h2 =>
          right
          right
          simpa [h2]
