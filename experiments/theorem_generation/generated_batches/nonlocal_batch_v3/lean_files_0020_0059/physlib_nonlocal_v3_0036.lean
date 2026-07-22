import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.gravSol_add_AFL_quad
    (n : ℕ) (S : (PlusU1 n).LinSols) (a b : ℚ) :
    accGrav (a • S.val + b • (Y n).val) = 0 ∧
      accQuad (a • S.val + b • (Y n).val) = a ^ 2 * accQuad S.val :=
by
  constructor
  · have h := SMRHN.PlusU1.gravSol (n := n) S
    simpa using h
  · exact SMRHN.PlusU1.Y.add_AFL_quad (n := n) S a b
