import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Data.Real.Basic

lemma Electromagnetism.FreeSpace.ε₀_mul_ℏ_ne_zero
  (𝓕 : Electromagnetism.FreeSpace) :
  (𝓕.ε₀ : ℝ) * (ℏ : ℝ) ≠ 0 :=
by
  exact mul_ne_zero (by simpa using Electromagnetism.FreeSpace.ε₀_ne_zero (𝓕 := 𝓕))
                    Constants.ℏ_ne_zero
