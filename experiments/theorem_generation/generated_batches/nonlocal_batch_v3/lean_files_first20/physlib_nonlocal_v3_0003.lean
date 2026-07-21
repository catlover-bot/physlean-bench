import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma Electromagnetism.FreeSpace.μ₀_add_ℏ_nonneg :
    0 ≤ 𝓕.μ₀ + (ℏ : ℝ) :=
by
  have h₁ : 0 ≤ 𝓕.μ₀ := Electromagnetism.FreeSpace.μ₀_nonneg
  have h₂ : 0 ≤ (ℏ : ℝ) := Constants.ℏ_nonneg
  exact add_nonneg h₁ h₂
