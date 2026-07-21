import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.cubeSol_add_Y
    (n : ℕ) (S : (PlusU1 n).Sols) :
    accCube (S.val + (Y n).val) = 0 :=
by
  have h1 : accCube S.val = 0 :=
    SMRHN.PlusU1.cubeSol S
  have h2 : accCube (1 • S.val + 1 • (Y n).val) = 0 :=
    SMRHN.PlusU1.Y.add_AF_cube S 1 1
  simpa using h2
