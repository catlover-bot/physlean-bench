import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Data.Real.Basic

lemma Electromagnetism.FreeSpace.ε₀_mul_ℏ_ne_zero
    (𝓕 : Electromagnetism.FreeSpace) :
    𝓕.ε₀ * (ℏ : ℝ) ≠ 0 :=
by
  apply mul_ne_zero
  · simpa using 𝓕.ε₀_ne_zero
  · simpa using Constants.ℏ_ne_zero
