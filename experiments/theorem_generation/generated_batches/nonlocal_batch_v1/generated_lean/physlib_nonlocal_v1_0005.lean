import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma Constants.ℏ_mul_μ₀_ne_zero
  (𝓕 : Electromagnetism.FreeSpace) :
  (ℏ : ℝ) * 𝓕.μ₀ ≠ 0 :=
by
  have h₁ : (ℏ : ℝ) ≠ 0 := Constants.ℏ_ne_zero
  have h₂ : 𝓕.μ₀ ≠ 0 := Electromagnetism.FreeSpace.μ₀_ne_zero (𝓕 := 𝓕)
  exact mul_ne_zero h₁ h₂
