import Mathlib
import Physlib.QFT.QED.AnomalyCancellation.BasisLinear
import Physlib.QFT.QED.AnomalyCancellation.Basic

lemma PureU1.sum_of_vectors_total_sum_eq_zero
  {n k : ℕ} (f : Fin k → (PureU1 n).LinSols) :
  ∑ j : Fin n, (∑ i : Fin k, (f i)).1 j = 0 := by
  classical
  have h₁ : (∑ j : Fin n, (∑ i : Fin k, (f i)).1 j)
      = ∑ j : Fin n, (∑ i : Fin k, (f i).1 j) := by
    refine Finset.sum_congr rfl ?_
    intro j hj
    simpa using PureU1.BasisLinear.sum_of_vectors (f := f) (j := j)
  have h₂ : ∑ i : Fin k, (∑ j : Fin n, (f i).1 j) = 0 := by
    classical
    have h_each : ∀ i : Fin k, ∑ j : Fin n, (f i).1 j = 0 := by
      intro i
      simpa using PureU1.pureU1_linear (S := f i)
    simpa [Finset.sum_const_zero] using
      (Finset.sum_congr rfl (by intro i hi; simpa [h_each i]))
  have h₃ :
      ∑ j : Fin n, (∑ i : Fin k, (f i).1 j)
        = ∑ i : Fin k, (∑ j : Fin n, (f i).1 j) := by
    simpa [Finset.sum_sigma'] using
      (Finset.sum_comm : ∑ j : Fin n, ∑ i : Fin k, (f i).1 j
        = ∑ i : Fin k, ∑ j : Fin n, (f i).1 j)
  calc
    ∑ j : Fin n, (∑ i : Fin k, (f i)).1 j
        = ∑ j : Fin n, (∑ i : Fin k, (f i).1 j) := h₁
    _   = ∑ i : Fin k, (∑ j : Fin n, (f i).1 j) := h₃
    _   = 0 := h₂
