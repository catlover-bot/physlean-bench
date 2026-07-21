import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.BL_Y.linear_combo_quadBiLin_on_cubeTriLin
    (n : ℕ) (S : (PlusU1 n).Charges) :
    (quadBiLin (BL n).val S + (1 / (12 : ℝ)) * cubeTriLin (Y n).val (Y n).val S)
      = (1 : ℝ) * accYY S + (3 / 2 : ℝ) * accSU2 S - 2 * accSU3 S := by
  have hBL := SMRHN.PlusU1.BL.on_quadBiLin (n := n) S
  have hY := SMRHN.PlusU1.Y.on_cubeTriLin (n := n) S
  have hY' : (1 / (12 : ℝ)) * cubeTriLin (Y n).val (Y n).val S = (1 / 2 : ℝ) * accYY S := by
    simpa [hY, mul_comm, mul_left_comm, mul_assoc, one_div, inv_mul_eq_iff_eq_mul₀,
      (by norm_num : (12 : ℝ) ≠ 0)] using
      congrArg (fun x => (1 / (12 : ℝ)) * x) hY
  calc
    quadBiLin (BL n).val S + (1 / (12 : ℝ)) * cubeTriLin (Y n).val (Y n).val S
        = (1 / 2 : ℝ) * accYY S + 3 / 2 * accSU2 S - 2 * accSU3 S
          + (1 / (12 : ℝ)) * cubeTriLin (Y n).val (Y n).val S := by
            simpa [hBL]
    _ = (1 / 2 : ℝ) * accYY S + (1 / 2 : ℝ) * accYY S
          + (3 / 2 : ℝ) * accSU2 S - 2 * accSU3 S := by
            have := hY'
            linear_combination this
    _ = (1 : ℝ) * accYY S + (3 / 2 : ℝ) * accSU2 S - 2 * accSU3 S := by
      ring_nf
