import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

open SMRHN

lemma SMRHN.PlusU1.Y.accCube_add_AFL_cube (S : (PlusU1 n).LinSols) (a b : ℚ) :
  accCube (a • (Y n).val + b • S.val) =
    a ^ 2 * accCube (Y n).val :=
by
  have h := PlusU1.BL.add_AFL_cube (n := n) ⟨(Y n).val, rfl⟩ a b
  have hY : cubeTriLin ((Y n).val) ((Y n).val) (BL n).val = 0 :=
    PlusU1.Y.on_cubeTriLin_AFL (n := n) ⟨(BL n).val, rfl⟩
  simpa [hY, add_comm, add_left_comm, add_assoc, add_mul, mul_add, mul_comm, mul_left_comm,
    mul_assoc, two_mul, three_mul, sub_eq_add_neg, one_mul, mul_one, zero_mul, mul_zero,
    add_zero, zero_add, pow_two]
