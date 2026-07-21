import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Mathlib

lemma SMRHN.PlusU1.quadSol_add_BL
    (S : (PlusU1 n).QuadSols) (a b : ℚ)
    (h : S.val = a • (BL n).val) :
    accQuad ((a + b) • (BL n).val) = 0 :=
by
  have hS : accQuad S.val = 0 := SMRHN.PlusU1.quadSol (n := n) S
  subst h
  simpa [add_comm, add_left_comm, add_assoc, add_mul, mul_add, two_mul,
        add_comm ((a * a) • accQuad (BL n).val), add_left_comm ((a * a) • accQuad (BL n).val),
        add_assoc ((a * a) • accQuad (BL n).val),
        add_comm ((2 * a * b) • accQuad (BL n).val),
        add_left_comm ((2 * a * b) • accQuad (BL n).val),
        add_assoc ((2 * a * b) • accQuad (BL n).val),
        SMRHN.PlusU1.BL.add_quad (n := n) ⟨(BL n).val, by
          simpa using SMRHN.PlusU1.BL.add_quad (n := n) ⟨(BL n).val, by
            have := SMRHN.PlusU1.quadSol (n := n) ⟨(BL n).val, ?_⟩
            simpa using this⟩ 0 1⟩ a b]
