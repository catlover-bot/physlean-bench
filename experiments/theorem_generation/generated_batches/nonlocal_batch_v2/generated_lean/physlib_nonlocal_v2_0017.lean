import Physlib.QFT.QED.AnomalyCancellation.Basic
import Physlib.QFT.QED.AnomalyCancellation.BasisLinear

lemma PureU1.bridge_sum_of_anomaly_free_and_basis {n k : ℕ}
  (f g : Fin k → (PureU1 n).LinSols)
  (h₁ : ∀ i j, (f i).1 j = (g i).1 j)
  (j : Fin n) :
  (∑ i : Fin k, (f i)).1 j = (∑ i : Fin k, (g i)).1 j :=
by
  have hf := PureU1.PureU1.sum_of_anomaly_free_linear f j
  have hg := PureU1.BasisLinear.sum_of_vectors g j
  simp [hf, hg, h₁]
