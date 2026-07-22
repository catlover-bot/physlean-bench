import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Data.Real.Basic

lemma Electromagnetism.FreeSpace.ε₀_mul_ℏ_ne_zero :
    (Electromagnetism.FreeSpace.𝓕.ε₀ : ℝ) * (ℏ : ℝ) ≠ 0 :=
by
  have hε : (Electromagnetism.FreeSpace.𝓕.ε₀ : ℝ) ≠ 0 := Electromagnetism.FreeSpace.ε₀_ne_zero
  have hℏ : (ℏ : ℝ) ≠ 0 := Constants.ℏ_ne_zero
  exact mul_ne_zero hε hℏ
