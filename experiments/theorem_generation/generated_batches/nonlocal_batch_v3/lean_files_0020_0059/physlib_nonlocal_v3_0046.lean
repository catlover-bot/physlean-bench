import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge
import Mathlib

lemma SMRHN.PlusU1.Y.YYsol_of_add_AFL_quad_eq
    {n : ℕ} (S : (PlusU1 n).LinSols) (a : ℚ)
    (h : accQuad (a • S.val + (Y n).val) = accQuad S.val) :
    accYY S.val = 0 :=
by
  have h' := SMRHN.PlusU1.Y.add_AFL_quad (n := n) S a (1 : ℚ)
  have hcomp : a ^ 2 * accQuad S.val = accQuad S.val := by
    have := congrArg id h
    simpa [h'] using this.symm
  classical
  by_cases hS : accQuad S.val = 0
  · simpa using SMRHN.PlusU1.YYsol (n := n) S
  · have hfac : a ^ 2 = (1 : ℚ) := by
      have := mul_left_cancel₀ hS hcomp
      simpa using this
    simpa using SMRHN.PlusU1.YYsol (n := n) S
