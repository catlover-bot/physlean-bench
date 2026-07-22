import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.accYY_add_cubeTriLin_Y_eq_zero
    (n : ℕ) (S : (PlusU1 n).LinSols) :
    accYY S.val + cubeTriLin (Y n).val (Y n).val S.val = 0 := by
  have h₁ : accYY S.val = 0 := SMRHN.PlusU1.YYsol S
  have h₂ : cubeTriLin (Y n).val (Y n).val S.val = 0 :=
    SMRHN.PlusU1.Y.on_cubeTriLin_AFL S
  simpa [h₁, h₂]
