import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.gravSol_add_on_cubeTriLin_AFL
    (n : ℕ) (S : (PlusU1 n).LinSols) :
    accGrav S.val + cubeTriLin (Y n).val (Y n).val S.val = 0 :=
by
  have h₁ : accGrav S.val = (0 : ℝ) :=
    SMRHN.PlusU1.gravSol S
  have h₂ : cubeTriLin (Y n).val (Y n).val S.val = (0 : ℝ) :=
    SMRHN.PlusU1.Y.on_cubeTriLin_AFL (n := n) S
  simpa [h₁, h₂]
