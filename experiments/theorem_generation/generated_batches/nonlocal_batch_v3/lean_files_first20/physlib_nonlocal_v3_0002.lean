import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma Electromagnetism.FreeSpace.ε₀_mul_Constants.ℏ_nonneg :
  0 ≤ 𝓕.ε₀ * (ℏ : ℝ) :=
by
  have h₁ : 0 ≤ 𝓕.ε₀ := Electromagnetism.FreeSpace.ε₀_nonneg
  have h₂ : 0 ≤ (ℏ : ℝ) := Constants.ℏ_nonneg
  exact mul_nonneg h₁ h₂
