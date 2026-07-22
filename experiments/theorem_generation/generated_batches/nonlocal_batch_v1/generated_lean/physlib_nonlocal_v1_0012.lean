import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge
import Mathlib

lemma SMRHN.PlusU1.cubeSol_add_hyperCharge
    (n : ℕ) (S : (PlusU1 n).Sols) :
    accCube (S.val + (Y n).val) = 0 :=
by
  simpa [one_smul, add_comm] using
    SMRHN.PlusU1.Y.add_AF_cube (n := n) S 1 1
