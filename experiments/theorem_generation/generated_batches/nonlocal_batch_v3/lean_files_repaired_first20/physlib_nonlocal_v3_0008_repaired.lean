import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Data.Real.Basic

lemma Constants.ℏ_ne_zero_real :
    (Constants.ℏ : ℝ) ≠ 0 :=
by
  have hℏ : (↑Constants.ℏ : ℝ) ≠ 0 := Constants.ℏ_ne_zero
  simpa using hℏ
