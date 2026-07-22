import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Data.Real.Basic

lemma Electromagnetism.FreeSpace.mul_μ₀_ℏ_ne_zero
    (𝓕 : Electromagnetism.FreeSpace) :
    (𝓕.μ₀ : ℝ) * (ℏ : ℝ) ≠ 0 :=
by
  have hμ : (𝓕.μ₀ : ℝ) ≠ 0 := Electromagnetism.FreeSpace.μ₀_ne_zero (𝓕 := 𝓕)
  have hℏ : (ℏ : ℝ) ≠ 0 := Constants.ℏ_ne_zero
  exact mul_ne_zero hμ hℏ
