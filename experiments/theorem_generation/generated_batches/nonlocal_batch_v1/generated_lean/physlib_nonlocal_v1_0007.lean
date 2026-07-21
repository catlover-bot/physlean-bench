import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant

lemma Electromagnetism.FreeSpace.μ₀_mul_ℏ_nonneg :
  0 ≤ (𝓕.μ₀ * (ℏ : ℝ)) :=
by
  have hμ : 0 ≤ 𝓕.μ₀ := Electromagnetism.FreeSpace.μ₀_nonneg
  have hℏ : 0 ≤ (ℏ : ℝ) := Constants.ℏ_nonneg
  exact mul_nonneg hμ hℏ
