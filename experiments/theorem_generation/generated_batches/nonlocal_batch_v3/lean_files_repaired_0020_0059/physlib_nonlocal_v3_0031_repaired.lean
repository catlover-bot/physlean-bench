import Mathlib
import Physlib.QFT.QED.AnomalyCancellation.BasisLinear
import Physlib.QFT.QED.AnomalyCancellation.Basic

lemma PureU1.pureU1_linear
  {n : ℕ} (S : (PureU1 n).LinSols) :
  ∑ j : Fin n, S.1 j = 0 := by
  classical
  simpa using PureU1.BasisLinear.total_sum_eq_zero (S := S)
