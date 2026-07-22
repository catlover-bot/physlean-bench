import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant
import Mathlib

lemma Electromagnetism.FreeSpace.dimless_coupling_ne_zero
    (𝓕 : Electromagnetism.FreeSpace) :
    (𝓕.μ₀ * (ℏ : ℝ))⁻¹ ≠ 0 :=
by
  have hμ : 𝓕.μ₀ ≠ 0 := Electromagnetism.FreeSpace.μ₀_ne_zero (𝓕 := 𝓕)
  have hℏ : (ℏ : ℝ) ≠ 0 := Constants.ℏ_ne_zero
  have hmul : 𝓕.μ₀ * (ℏ : ℝ) ≠ 0 := mul_ne_zero hμ hℏ
  exact inv_ne_zero hmul
