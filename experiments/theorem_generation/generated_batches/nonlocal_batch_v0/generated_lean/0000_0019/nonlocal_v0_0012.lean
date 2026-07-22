import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Data.Real.Basic

open Electromagnetism

lemma Electromagnetism.FreeSpace.ε₀_mul_ℏ_nonneg :
  0 ≤ (𝓕.ε₀ : ℝ) * ℏ :=
by
  have hε : 0 ≤ (𝓕.ε₀ : ℝ) := ε₀_nonneg
  have hℏ : 0 ≤ (ℏ : ℝ) := Constants.ℏ_nonneg
  exact mul_nonneg hε hℏ
