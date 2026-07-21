import Physlib.Particles.StandardModel.AnomalyCancellation.Basic

lemma SMCharges.SMACCs.accGrav_ext
  {n : ℕ} {S₁ S₂ : (SMCharges n).Charges}
  (h : ∀ j, (SMCharges.SMACCs.accGravFun S₁ j) =
            (SMCharges.SMACCs.accGravFun S₂ j)) :
  SMCharges.SMACCs.accGrav S₁ = SMCharges.SMACCs.accGrav S₂ :=
by
  funext j
  exact h j
