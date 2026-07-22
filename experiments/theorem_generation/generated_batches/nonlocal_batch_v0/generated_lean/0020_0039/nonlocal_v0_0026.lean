import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

open SMRHN

lemma SMRHN.PlusU1.accCube_Y_add_BL
    (n : ℕ) (S : (PlusU1 n).LinSols) (a b : ℚ) :
    accCube (a • (Y n).val + b • (BL n).val) =
      a ^ 2 * (a * accCube (Y n).val + 3 * b * cubeTriLin (Y n).val (Y n).val (BL n).val) := by
  simpa using PlusU1.BL.add_AFL_cube (n := n) (S := ⟨(Y n).val, rfl⟩) (a := a) (b := b)
