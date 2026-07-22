import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Mathlib

lemma SMRHN.PlusU1.BL.quadSol_add_BL_quad
    {n : ℕ} (S : (PlusU1 n).QuadSols) (a b : ℚ) (h : a ≠ 0) :
    accQuad (S.val + b • (BL n).val) = 0 :=
by
  have hcoef : (1 : ℚ) ≠ 0 := one_ne_zero
  have hS := SMRHN.PlusU1.quadSol (n := n) S
  have hBL := SMRHN.PlusU1.BL.add_quad (n := n) S 0 b
  simpa [zero_smul, one_smul, add_comm] using hBL
