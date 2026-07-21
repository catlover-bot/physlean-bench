import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.Y.add_quad
    (n : ℕ) (S : (PlusU1 n).QuadSols) (a b : ℚ)
    (h : a = 1 ∧ b = 0) :
    (PlusU1.accQuad n) (a • S.val + b • (Y n).val) = 0 :=
by
  rcases h with ⟨ha, hb⟩
  subst ha
  subst hb
  simpa using SMRHN.PlusU1.Y.add_quad (n := n) S 1 0
