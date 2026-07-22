import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

lemma SMRHN.PlusU1.BL_Y.linear_combo_quadBiLin_on_cubeTriLin
    (n : ℕ) (S : (PlusU1 n).Charges) :
    (SMνACCs.quadBiLin (BL n).val S +
        (1 / (12 : ℝ)) * (SMνACCs.cubeTriLin (Y n).val (Y n).val S))
      = (1 : ℝ) * SMνACCs.accYY S
        + (3 / 2 : ℝ) * SMνACCs.accSU2 S
        - 2 * SMνACCs.accSU3 S := by
  -- use the existing anomaly-cancellation relations
  have hBL := SMRHN.PlusU1.BL.on_quadBiLin (n := n) S
  have hY  := SMRHN.PlusU1.Y.on_cubeTriLin (n := n) S
  -- rewrite the cubic term as a multiple of accYY
  have hY' :
      (1 / (12 : ℝ)) * SMνACCs.cubeTriLin (Y n).val (Y n).val S
        = (1 / 2 : ℝ) * SMνACCs.accYY S := by
    have : (SMνACCs.cubeTriLin (Y n).val (Y n).val S)
        = 6 * SMνACCs.accYY S := hY
    calc
      (1 / (12 : ℝ)) * SMνACCs.cubeTriLin (Y n).val (Y n).val S
          = (1 / (12 : ℝ)) * (6 * SMνACCs.accYY S) := by simpa [this]
      _ = ((1 / (12 : ℝ)) * 6) * SMνACCs.accYY S := by ring
      _ = (1 / 2 : ℝ) * SMνACCs.accYY S := by
            norm_num [one_div, inv_mul_eq_iff_eq_mul₀]
  -- combine everything
  calc
    SMνACCs.quadBiLin (BL n).val S +
        (1 / (12 : ℝ)) * SMνACCs.cubeTriLin (Y n).val (Y n).val S
        = (1 / 2 : ℝ) * SMνACCs.accYY S
            + (3 / 2 : ℝ) * SMνACCs.accSU2 S
            - 2 * SMνACCs.accSU3 S
            + (1 / (12 : ℝ)) * SMνACCs.cubeTriLin (Y n).val (Y n).val S := by
              simpa [hBL, add_comm, add_left_comm, add_assoc]
    _ = (1 / 2 : ℝ) * SMνACCs.accYY S
          + (1 / 2 : ℝ) * SMνACCs.accYY S
          + (3 / 2 : ℝ) * SMνACCs.accSU2 S
          - 2 * SMνACCs.accSU3 S := by
            have := hY'
            linear_combination this
    _ = (1 : ℝ) * SMνACCs.accYY S
          + (3 / 2 : ℝ) * SMνACCs.accSU2 S
          - 2 * SMνACCs.accSU3 S := by
            ring_nf
