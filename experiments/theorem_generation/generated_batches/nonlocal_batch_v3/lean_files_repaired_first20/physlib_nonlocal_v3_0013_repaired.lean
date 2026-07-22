import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.Y.on_cubeTriLin_AFL
    (n : ℕ) :
    cubeTriLin (Y n).val (Y n).val (BL n).val = 0 :=
by
  have h := SMRHN.PlusU1.Y.on_cubeTriLin_AFL (n := n) (S := BL n)
  simpa using h
