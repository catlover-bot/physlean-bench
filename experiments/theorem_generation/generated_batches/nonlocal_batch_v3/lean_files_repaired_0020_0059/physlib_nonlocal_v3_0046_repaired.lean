import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge
import Mathlib

lemma SMRHN.PlusU1.Y.add_AFL_quad
    {n : ℕ} (S : (PlusU1 n).LinSols) (a b : ℚ) :
    SMRHN.PlusU1.Y.accQuad ((a • S.val) + (b • (SMRHN.PlusU1.Y.Y n).val))
      = a ^ 2 * SMRHN.PlusU1.Y.accQuad S.val :=
by
  simpa using SMRHN.PlusU1.Y.add_AFL_quad (n := n) S a b
