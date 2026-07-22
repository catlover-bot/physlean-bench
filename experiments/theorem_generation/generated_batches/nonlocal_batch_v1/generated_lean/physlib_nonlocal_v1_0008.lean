import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Data.Real.Basic

lemma Electromagnetism.FreeSpace.ε₀_mul_ℏ_ne_zero :
    (𝓕.ε₀ * (ℏ : ℝ)) ≠ 0 :=
by
  exact mul_ne_zero Electromagnetism.FreeSpace.ε₀_ne_zero Constants.ℏ_ne_zero
