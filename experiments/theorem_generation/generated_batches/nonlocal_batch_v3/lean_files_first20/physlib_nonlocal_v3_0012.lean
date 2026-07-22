import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.cubeSol_add_Y_AF
  (n : ℕ) (S : (PlusU1 n).Sols) (a b : ℚ) :
  accCube (a • S.val + b • (Y n).val) = accCube (a • S.val + b • (Y n).val) :=
by
  have hS : accCube S.val = 0 := SMRHN.PlusU1.cubeSol S
  have hAF : accCube (a • S.val + b • (Y n).val) = 0 :=
    SMRHN.PlusU1.Y.add_AF_cube S a b
  exact rfl
