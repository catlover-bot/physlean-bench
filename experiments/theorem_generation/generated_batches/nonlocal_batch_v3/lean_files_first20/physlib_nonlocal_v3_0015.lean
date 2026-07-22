import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Mathlib

lemma SMRHN.PlusU1.BL.quadSol_add_BL_eq_add_quad
    {n : ℕ} (S : (PlusU1 n).QuadSols) :
    accQuad (S.val + (BL n).val) = 0 :=
by
  have hS : accQuad S.val = 0 := SMRHN.PlusU1.quadSol S
  have hBL := SMRHN.PlusU1.BL.add_quad (n := n) S 0 1
  simpa [zero_smul, one_smul, add_comm] using hBL
