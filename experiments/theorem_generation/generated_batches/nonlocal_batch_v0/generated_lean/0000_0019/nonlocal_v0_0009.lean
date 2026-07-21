import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma Electromagnetism.FreeSpace.μ₀_mul_ℏ_nonneg
    (𝓕 : Electromagnetism.FreeSpace) :
    0 ≤ 𝓕.μ₀ * (ℏ : ℝ) :=
by
  have h₁ : 0 ≤ 𝓕.μ₀ := Electromagnetism.FreeSpace.μ₀_nonneg (𝓕 := 𝓕)
  have h₂ : 0 ≤ (ℏ : ℝ) := Constants.ℏ_nonneg
  exact mul_nonneg h₁ h₂
