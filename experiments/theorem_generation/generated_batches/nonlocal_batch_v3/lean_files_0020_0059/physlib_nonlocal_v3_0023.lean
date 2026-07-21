import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge
import Mathlib

lemma SMRHN.PlusU1.quadSol_add_AFL_quad_eq_zero
    (n : ℕ) (S : (PlusU1 n).QuadSols) (T : (PlusU1 n).LinSols) :
    accQuad (S.val + (Y n).val) = 0 := by
  have hS : accQuad S.val = 0 := SMRHN.PlusU1.quadSol S
  have hY := SMRHN.PlusU1.Y.add_AFL_quad (n := n) T (1 : ℚ) 0
  simp at hY
  have hSY : accQuad (S.val + (Y n).val) = accQuad S.val + accQuad (Y n).val + accCross S.val (Y n).val := by
    simpa [add_comm, add_left_comm, add_assoc]
  calc
    accQuad (S.val + (Y n).val)
        = accQuad S.val + accQuad (Y n).val + accCross S.val (Y n).val := hSY
    _ = 0 + accQuad (Y n).val + accCross S.val (Y n).val := by simpa [hS]
    _ = accQuad (Y n).val + accCross S.val (Y n).val := by ring
    _ = accQuad ((Y n).val) + accCross S.val (Y n).val := rfl
    _ = 0 := by
      have := congrArg id hY
      simpa using this
