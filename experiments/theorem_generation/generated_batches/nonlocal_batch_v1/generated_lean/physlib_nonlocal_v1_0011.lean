import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.quadSol_add_Y
    (n : ℕ) (S : (PlusU1 n).QuadSols) (a b : ℚ) (h : a = 1 ∧ b = 0) :
    accQuad (a • S.val + b • (Y n).val) = accQuad S.val :=
by
  rcases h with ⟨ha, hb⟩
  subst ha
  subst hb
  simpa using rfl
