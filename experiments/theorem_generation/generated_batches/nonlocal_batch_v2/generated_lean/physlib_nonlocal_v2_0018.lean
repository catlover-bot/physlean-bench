import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.BL_Y_add_quad
  {n : ℕ} (S : (PlusU1 n).LinSols) (T : (PlusU1 n).QuadSols) (a b c d : ℚ) :
  accQuad (a • S.val + b • (Y n).val + (c • T.val + d • (BL n).val)) =
    a ^ 2 * accQuad S.val :=
by
  have hY := SMRHN.PlusU1.Y.add_AFL_quad (n := n) S a b
  have hBL := SMRHN.PlusU1.BL.add_quad (n := n) T c d
  have h1 : accQuad (a • S.val + b • (Y n).val) = a ^ 2 * accQuad S.val := hY
  have h2 : accQuad (c • T.val + d • (BL n).val) = 0 := hBL
  simpa [add_comm, add_left_comm, add_assoc, h1, h2]
