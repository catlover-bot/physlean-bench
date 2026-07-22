import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

open SMRHN

lemma SMRHN.PlusU1.cubeSol_add_AF_cube
    {n : ℕ} (S : (PlusU1 n).Sols) (a b : ℚ) :
    accCube (a • S.val + b • (Y n).val) = 0 :=
by
  simpa using PlusU1.Y.add_AF_cube (n := n) S a b
