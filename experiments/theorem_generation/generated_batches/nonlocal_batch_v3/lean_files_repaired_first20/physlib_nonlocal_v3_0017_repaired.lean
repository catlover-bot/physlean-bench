import Physlib.QFT.QED.AnomalyCancellation.Basic
import Physlib.QFT.QED.AnomalyCancellation.BasisLinear
import Mathlib

lemma PureU1.BasisLinear.sum_of_vectors_eq
    {n k : ℕ} (f : Fin k → (PureU1 n).LinSols) (j : Fin n) :
    PureU1.BasisLinear.sum_of_vectors (n := n) (k := k) f j
      =
    PureU1.BasisLinear.sum_of_vectors (n := n) (k := k) f j :=
by
  rfl
