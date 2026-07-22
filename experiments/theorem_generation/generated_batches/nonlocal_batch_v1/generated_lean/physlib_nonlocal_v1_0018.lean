import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.Y_BL.add_AFL_BL_quad
    (S : (PlusU1 n).LinSols) (a b c : ℚ) :
    accQuad (a • S.val + b • (Y n).val + c • (BL n).val)
      = a ^ 2 * accQuad S.val :=
by
  have h1 : accQuad (a • S.val + b • (Y n).val) = a ^ 2 * accQuad S.val :=
    SMRHN.PlusU1.Y.add_AFL_quad S a b
  have h2 : accQuad (a • S.val + b • (Y n).val + c • (BL n).val)
      = accQuad ((a • S.val + b • (Y n).val) + c • (BL n).val) := by
    simp [add_assoc]
  have h3 : accQuad ((a • S.val + b • (Y n).val) + c • (BL n).val) = 0 := by
    have hBL := SMRHN.PlusU1.BL.add_quad n (PlusU1.QuadSols.mk (a • S.val + b • (Y n).val)) 1 c
    simpa using hBL
  have h4 : accQuad (a • S.val + b • (Y n).val + c • (BL n).val) = 0 := by
    simpa [h2] using h3
  have hS : accQuad S.val = 0 := by
    have hS' := SMRHN.PlusU1.BL.add_quad n (PlusU1.QuadSols.mk S.val) 1 0
    simpa using hS'
  calc
    accQuad (a • S.val + b • (Y n).val + c • (BL n).val)
        = 0 := h4
    _ = a ^ 2 * accQuad S.val := by simpa [hS]
