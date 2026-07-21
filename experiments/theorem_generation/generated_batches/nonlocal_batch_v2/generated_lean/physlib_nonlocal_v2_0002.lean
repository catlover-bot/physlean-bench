import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma planck_perm_product_nonneg :
  0 ≤ (ℏ : ℝ) * Electromagnetism.FreeSpace.ε₀ :=
by
  have h₁ : 0 ≤ (ℏ : ℝ) := Constants.ℏ_nonneg
  have h₂ : 0 ≤ Electromagnetism.FreeSpace.ε₀ := Electromagnetism.FreeSpace.ε₀_nonneg
  exact mul_nonneg h₁ h₂
