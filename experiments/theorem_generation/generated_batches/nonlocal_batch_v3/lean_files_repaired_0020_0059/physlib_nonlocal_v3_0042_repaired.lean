import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.Y.on_cubeTriLin_AFL
    (n : ℕ) (S : (PlusU1 n).LinSols) :
    SMRHN.PlusU1.cubeTriLin (SMRHN.PlusU1.Y n).val (SMRHN.PlusU1.Y n).val S.val = 0 :=
SMRHN.PlusU1.Y.on_cubeTriLin_AFL S
