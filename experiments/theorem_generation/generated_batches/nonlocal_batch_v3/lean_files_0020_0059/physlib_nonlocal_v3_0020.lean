import Physlib.QFT.QED.AnomalyCancellation.BasisLinear
import Physlib.QFT.QED.AnomalyCancellation.Odd.BasisLinear
import Mathlib

lemma PureU1.VectorLikeOddPlane.finrank_LinSols_odd_eq_card_fin_sum_fin
    {n : ℕ} :
    Module.finrank ℚ ((PureU1 (2 * n.succ + 1)).LinSols)
      = Fintype.card ((Fin (PureU1.BasisLinear.finrank_AnomalyFreeLinear (n := n)).succ) ⊕ (Fin (PureU1.BasisLinear.finrank_AnomalyFreeLinear (n := n)).succ)) := by
  have h₁ : Module.finrank ℚ ((PureU1 (2 * n.succ + 1)).LinSols)
      = Fintype.card ((Fin n.succ) ⊕ (Fin n.succ)) := by
    simpa [PureU1.VectorLikeOddPlane.basisa_card (n := n)]
  have h₂ : PureU1.BasisLinear.finrank_AnomalyFreeLinear (n := n) = n := by
    simpa using (PureU1.BasisLinear.finrank_AnomalyFreeLinear (n := n))
  have h₃ :
      Fintype.card ((Fin n.succ) ⊕ (Fin n.succ))
        = Fintype.card ((Fin (PureU1.BasisLinear.finrank_AnomalyFreeLinear (n := n)).succ) ⊕ (Fin (PureU1.BasisLinear.finrank_AnomalyFreeLinear (n := n)).succ)) := by
    simpa [h₂]
  exact h₁.trans h₃ ⟩
