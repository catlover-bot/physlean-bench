import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma planck_perm_product_ne_zero (𝓕 : Electromagnetism.FreeSpace) :
  (ℏ : ℝ) * 𝓕.ε₀ ≠ 0 :=
by
  have h₁ : (ℏ : ℝ) ≠ 0 := Constants.ℏ_ne_zero
  have h₂ : 𝓕.ε₀ ≠ 0 := Electromagnetism.FreeSpace.ε₀_ne_zero (𝓕 := 𝓕)
  exact mul_ne_zero h₁ h₂
