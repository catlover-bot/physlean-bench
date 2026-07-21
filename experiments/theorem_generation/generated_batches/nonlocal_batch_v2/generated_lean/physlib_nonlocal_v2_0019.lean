import Physlib.QFT.QED.AnomalyCancellation.BasisLinear
import Physlib.QFT.QED.AnomalyCancellation.Even.BasisLinear

lemma PureU1.even_finrank_eq_basisa_card
    (n : ℕ) :
    (2 : ℕ) * Module.finrank ℚ (((PureU1 n.succ).LinSols)) =
      Fintype.card ((Fin n.succ) ⊕ (Fin n)) := by
  have h₁ : Module.finrank ℚ (((PureU1 n.succ).LinSols)) = n :=
    PureU1.BasisLinear.finrank_AnomalyFreeLinear (n := n)
  have h₂ : Fintype.card ((Fin n.succ) ⊕ (Fin n)) =
      Module.finrank ℚ (PureU1 (2 * n.succ)).LinSols :=
    (PureU1.VectorLikeEvenPlane.basisa_card (n := n))
  have h₃ : Module.finrank ℚ (PureU1 (2 * n.succ)).LinSols =
      (2 : ℕ) * Module.finrank ℚ (((PureU1 n.succ).LinSols)) := by
    simpa [h₁, two_mul] using congrArg id (by rfl :
      Module.finrank ℚ (PureU1 (2 * n.succ)).LinSols =
        (2 : ℕ) * Module.finrank ℚ (((PureU1 n.succ).LinSols)))
  have h₄ := h₂.trans h₃
  simpa [h₁, two_mul] using h₄.symm
