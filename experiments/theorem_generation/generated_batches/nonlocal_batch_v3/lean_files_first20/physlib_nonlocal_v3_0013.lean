import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.Y_BL_mixed_cube
    (S : (PlusU1 n).LinSols) :
    accCube ((Y n).val + (BL n).val) =
      accCube (BL n).val +
        3 * cubeTriLin (BL n).val (BL n).val (Y n).val :=
by
  have h1 := SMRHN.PlusU1.BL.add_AFL_cube (n := n) (S := (Y n)) (a := (1 : ℚ)) (b := (1 : ℚ))
  have h2 := SMRHN.PlusU1.Y.on_cubeTriLin_AFL (n := n) (S := BL n)
  simp only [one_mul, one_pow, zero_add, mul_one, add_zero, add_comm, add_left_comm,
    add_assoc, mul_comm, mul_left_comm, mul_assoc, add_right_comm] at h1
  have h3 : cubeTriLin (Y n).val (Y n).val (BL n).val = 0 := h2
  simp [h3] at h1
  exact h1
