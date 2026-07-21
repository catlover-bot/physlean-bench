import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Data.Real.Basic

lemma Electromagnetism.FreeSpace.μ₀_mul_ℏ_ne_zero
    {𝓕 : Electromagnetism.FreeSpace} :
    (𝓕.μ₀ * (ℏ : ℝ)) ≠ 0 :=
by
  apply mul_ne_zero
  · simpa using (Electromagnetism.FreeSpace.μ₀_ne_zero (𝓕 := 𝓕))
  · simpa using Constants.ℏ_ne_zero
