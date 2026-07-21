import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.quadSol_add_Y_quad
    (n : ℕ) (S : (PlusU1 n).QuadSols) (a b : ℚ)
    (h : a = 1 ∧ b = 0) :
    accQuad (a • S.val + b • (Y n).val) = 0 :=
by
  rcases h with ⟨ha, hb⟩
  subst ha
  subst hb
  have h₁ : accQuad (1 • S.val + 0 • (Y n).val) = 0 :=
    SMRHN.PlusU1.Y.add_quad (n := n) S 1 0
  simpa using h₁
