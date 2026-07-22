import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.Y.quadSol_add_Y_quad
    (n : ℕ) (S : (PlusU1 n).QuadSols) (a : ℚ) :
    accQuad (S.val + a • (Y n).val) = 0 :=
by
  have hS : accQuad S.val = 0 := SMRHN.PlusU1.quadSol S
  have hY : accQuad (1 • S.val + a • (Y n).val) = 0 :=
    SMRHN.PlusU1.Y.add_quad S 1 a
  simpa [one_smul, add_comm] using hY
