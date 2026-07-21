import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge
import Mathlib

lemma SMRHN.PlusU1.quadSol_add_AFQ_cube_Y_eq
    (n : ℕ) (S : (PlusU1 n).QuadSols) (a : ℚ) :
    accQuad S.val = 0 ∧ accCube (a • S.val + (Y n).val) = accCube S.val := by
  constructor
  · simpa using SMRHN.PlusU1.quadSol (n := n) S
  · have h := SMRHN.PlusU1.Y.add_AFQ_cube (n := n) S a (1 : ℚ)
    have h1 : a ^ 3 = 1 := by
      have : a = 1 := by
        have hquad := SMRHN.PlusU1.quadSol (n := n) S
        exact one_eq_one
      simpa [this]
    simpa [h1, one_mul, one_smul, add_comm] using h
