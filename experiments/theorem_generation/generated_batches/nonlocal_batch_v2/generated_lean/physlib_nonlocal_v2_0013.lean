import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.BL.Y_add_AFL_cube_eq_BL_add_AFL_cube
    (S : (PlusU1 n).LinSols) (a : ℚ) :
    accCube (a • S.val + (Y n).val) =
      a ^ 2 * (a * accCube S.val + 3 * cubeTriLin S.val S.val (BL n).val) :=
by
  have hBL := SMRHN.PlusU1.BL.add_AFL_cube (n := n) S a (1 : ℚ)
  have hY := SMRHN.PlusU1.Y.on_cubeTriLin_AFL (n := n) S
  have hY' : cubeTriLin S.val S.val (Y n).val = 0 := by
    simpa [cubeTriLin_perm_123] using hY
  have hYterm : cubeTriLin S.val S.val ((BL n).val + (Y n).val) =
      cubeTriLin S.val S.val (BL n).val :=
  by
    have := cubeTriLin_add_z S.val S.val (BL n).val (Y n).val
    simpa [hY', add_comm] using this
  have hadd :
      accCube (a • S.val + 1 • (BL n).val) =
        accCube (a • S.val + (BL n).val) := by
    simpa using rfl
  have hBL' := hBL.trans hadd
  simpa [hYterm] using hBL'
