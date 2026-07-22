import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.YYsol_and_on_quadBiLin_AFL_eq_zero
    (n : ℕ) (S : (PlusU1 n).LinSols) :
    accYY S.val + quadBiLin (Y n).val S.val = 0 :=
by
  have h1 : accYY S.val = 0 := SMRHN.PlusU1.YYsol S
  have h2 : quadBiLin (Y n).val S.val = 0 := SMRHN.PlusU1.Y.on_quadBiLin_AFL S
  simpa [h1, h2]
