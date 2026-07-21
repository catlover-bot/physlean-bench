import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge
import Mathlib

lemma SMRHN.PlusU1.Y.add_AFL_quad
    (n : ℕ) (T : (PlusU1 n).LinSols) :
    (PlusU1.accQuad ((SMRHN.PlusU1.Y n).val)) = 0 := by
  -- This is a simple consequence of the more general statement
  -- `SMRHN.PlusU1.Y.add_AFL_quad` applied with `a = 1` and `b = 0`.
  -- We avoid reproducing that full lemma and just reuse it in this
  -- convenient specialized form.
  simpa using (SMRHN.PlusU1.Y.add_AFL_quad (n := n) T (1 : ℚ) 0)
