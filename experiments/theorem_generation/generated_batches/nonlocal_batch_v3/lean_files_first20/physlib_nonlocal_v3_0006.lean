import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Data.Real.Basic

lemma Electromagnetism.FreeSpace.ε₀_mul_ℏ_nonneg :
    0 ≤ 𝓕.ε₀ * (ℏ : ℝ) :=
by
  have hε : 0 ≤ 𝓕.ε₀ := Electromagnetism.FreeSpace.ε₀_nonneg
  have hℏ : 0 ≤ (ℏ : ℝ) := Constants.ℏ_nonneg
  exact mul_nonneg hε hℏ
