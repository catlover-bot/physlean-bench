import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge
import Mathlib

lemma SMRHN.PlusU1.Y.add_AFQ_cube
    (n : ℕ) (S : (PlusU1 n).QuadSols) (a : ℚ) :
    (PlusU1.accCube (a • S.val + (SMRHN.PlusU1.Y n).val) :
      ℚ) =
    PlusU1.accCube S.val + PlusU1.accCube (SMRHN.PlusU1.Y n).val := by
  simpa using SMRHN.PlusU1.Y.add_AFQ_cube (n := n) S a (1 : ℚ)
