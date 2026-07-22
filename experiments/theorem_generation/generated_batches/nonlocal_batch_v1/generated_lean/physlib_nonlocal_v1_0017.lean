import Mathlib.Algebra.BigOperators.Basic
import Physlib.QFT.QED.AnomalyCancellation.Basic
import Physlib.QFT.QED.AnomalyCancellation.BasisLinear

lemma PureU1.sum_of_anomaly_free_linear_eq_sum_of_vectors
    {n k : ℕ} (f : Fin k → (PureU1 n).LinSols) (j : Fin n) :
    @PureU1.PureU1.sum_of_anomaly_free_linear n k f j =
      @PureU1.BasisLinear.sum_of_vectors n k f j :=
rfl
