import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma planck_squared_mul_mu₀_nonneg :
  0 ≤ (ℏ : ℝ)^2 * Electromagnetism.FreeSpace.μ₀ :=
by
  have hℏ : 0 ≤ (ℏ : ℝ) := Constants.ℏ_nonneg
  have hℏsq : 0 ≤ (ℏ : ℝ)^2 := by
    have := mul_nonneg hℏ hℏ
    simpa [pow_two] using this
  have hμ : 0 ≤ Electromagnetism.FreeSpace.μ₀ :=
    Electromagnetism.FreeSpace.μ₀_nonneg
  exact mul_nonneg hℏsq hμ
