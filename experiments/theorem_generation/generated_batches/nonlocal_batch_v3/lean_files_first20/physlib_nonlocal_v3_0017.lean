import Physlib.QFT.QED.AnomalyCancellation.Basic
import Physlib.QFT.QED.AnomalyCancellation.BasisLinear
import Mathlib

lemma PureU1.sum_of_anomaly_free_linear_eq_sum_of_vectors
    {n k : ℕ} (f : Fin k → (PureU1 n).LinSols) (j : Fin n) :
    (PureU1.PureU1.sum_of_anomaly_free_linear (n := n) (k := k) f j)
      =
    (PureU1.BasisLinear.sum_of_vectors (n := n) (k := k) f j) :=
by
  have h₁ := PureU1.PureU1.sum_of_anomaly_free_linear (n := n) (k := k) f j
  have h₂ := PureU1.BasisLinear.sum_of_vectors (n := n) (k := k) f j
  simpa [h₂] using h₁
