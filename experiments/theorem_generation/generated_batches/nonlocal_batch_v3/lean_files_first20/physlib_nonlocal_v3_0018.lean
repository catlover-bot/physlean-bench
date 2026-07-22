import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.Y.add_AFL_quad_BL
    (S : (PlusU1 n).LinSols) (Q : (PlusU1 n).QuadSols) (a b c : ℚ) :
    accQuad (a • S.val + b • (Y n).val + c • (BL n).val) =
      a ^ 2 * accQuad S.val :=
by
  have hY := SMRHN.PlusU1.Y.add_AFL_quad (n := n) S a b
  have hBL := SMRHN.PlusU1.BL.add_quad (n := n) Q (1 : ℚ) c
  have hBL' : accQuad (a • S.val + b • (Y n).val + c • (BL n).val) =
      accQuad (a • S.val + b • (Y n).val) :=
  by
    have : a • S.val + b • (Y n).val + c • (BL n).val =
        (a • S.val + b • (Y n).val) + c • (BL n).val :=
      by abel
    calc
      accQuad (a • S.val + b • (Y n).val + c • (BL n).val)
          = accQuad ((a • S.val + b • (Y n).val) + c • (BL n).val) := by simpa [this]
      _ = accQuad ((1 : ℚ) • Q.val + c • (BL n).val) := by
            have : accQuad (a • S.val + b • (Y n).val) =
                accQuad ((1 : ℚ) • Q.val) :=
              by
                have hBL0 := SMRHN.PlusU1.BL.add_quad (n := n) Q 1 0
                simpa using hBL0
            simpa [one_smul]
      _ = 0 := hBL
      _ = accQuad (a • S.val + b • (Y n).val) := by
            have hBL0 := SMRHN.PlusU1.BL.add_quad (n := n) Q 1 0
            simpa using hBL0.symm
  simpa [hBL'] using hY
