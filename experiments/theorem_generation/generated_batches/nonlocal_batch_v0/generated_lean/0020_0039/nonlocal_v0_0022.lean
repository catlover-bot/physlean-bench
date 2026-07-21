import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.quadSol_add_hyperCharge
    (n : ℕ) (S : (PlusU1 n).QuadSols) (a b : ℚ) :
    accQuad (a • S.val + b • (Y n).val) = 0 :=
by
  simpa using SMRHN.PlusU1.Y.add_quad (n := n) S a b
