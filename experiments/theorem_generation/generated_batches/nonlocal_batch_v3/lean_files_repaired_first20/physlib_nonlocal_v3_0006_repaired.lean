import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Data.Real.Basic

theorem Constants.ℏ_nonneg_real : 0 ≤ (ℏ : ℝ) :=
by
  simpa using (Constants.ℏ_nonneg : 0 ≤ (ℏ : ℝ))
