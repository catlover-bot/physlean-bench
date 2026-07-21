import Physlib.QFT.QED.AnomalyCancellation.BasisLinear
import Physlib.QFT.QED.AnomalyCancellation.Basic

lemma PureU1.commute_sum_of_vectors_and_anomaly_free_linear
  {n k : ℕ} (f : Fin k → (PureU1 n).LinSols) (j : Fin n) :
  (PureU1.BasisLinear.sum_of_vectors (k := k) f j) =
    (PureU1.PureU1.sum_of_anomaly_free_linear (k := k) f j) :=
by
  rfl
