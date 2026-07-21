import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.Y.add_AF_cube
  (n : ℕ) (S : (PlusU1 n).Sols) (a b : ℚ) :
  SMRHN.PlusU1.accCube (a • S.val + b • (SMRHN.PlusU1.Y n).val)
    = SMRHN.PlusU1.accCube (a • S.val + b • (SMRHN.PlusU1.Y n).val) :=
rfl
