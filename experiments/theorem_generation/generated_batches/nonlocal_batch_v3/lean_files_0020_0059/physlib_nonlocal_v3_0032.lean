import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.BL_Y.on_cubeTriLin_sum
    (n : ℕ) (S : (PlusU1 n).Charges) :
    cubeTriLin (BL n).val (BL n).val S + cubeTriLin (Y n).val S S
      = 9 * accGrav S - 24 * accSU3 S + 6 * accQuad S :=
by
  simpa [SMRHN.PlusU1.BL.on_cubeTriLin, SMRHN.PlusU1.Y.on_cubeTriLin', add_comm, add_left_comm,
    add_assoc]
