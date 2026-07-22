import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.Y.on_cubeTriLin_AFL_add_gravSol
    (n : ℕ) (S : (PlusU1 n).LinSols) :
    SMRHN.PlusU1.gravSol S ∧ SMRHN.PlusU1.Y.on_cubeTriLin_AFL (n := n) S :=
by
  exact And.intro (SMRHN.PlusU1.gravSol S) (SMRHN.PlusU1.Y.on_cubeTriLin_AFL (n := n) S)
