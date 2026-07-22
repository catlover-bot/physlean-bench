import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Data.Real.Basic

lemma Electromagnetism.FreeSpace.μ₀_mul_ℏ_nonneg :
    0 ≤ (Electromagnetism.FreeSpace.𝓕.μ₀ : ℝ) * (ℏ : ℝ) := by
  have hμ : 0 ≤ (Electromagnetism.FreeSpace.𝓕.μ₀ : ℝ) := Electromagnetism.FreeSpace.μ₀_nonneg
  have hℏ : 0 ≤ (ℏ : ℝ) := Constants.ℏ_nonneg
  exact mul_nonneg hμ hℏ
