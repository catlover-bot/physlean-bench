import Physlib.QFT.QED.AnomalyCancellation.LowDim.Three
import Physlib.QFT.QED.AnomalyCancellation.Basic
import Mathlib.Data.Fin.Basic
import Mathlib.Algebra.BigOperators.Basic

lemma PureU1.Three.cubicACC_eq_zero_of_linear_and_cube_for_linSol'
  (S : (PureU1 3).LinSols)
  (h : ∑ i : Fin 3, S.val i = 0) :
  (PureU1 3).cubicACC S.val = 0 :=
by
  have h₁ := (PureU1.pureU1_linear (n := 3) S)
  have h₂ := (PureU1.Three.cube_for_linSol' S)
  have : 3 * S.val (0 : Fin 3) * S.val (1 : Fin 3) * S.val (2 : Fin 3) = 0 :=
    by
      exact (h₁.trans h.symm ▸ rfl)
  exact (h₂.mp this)
