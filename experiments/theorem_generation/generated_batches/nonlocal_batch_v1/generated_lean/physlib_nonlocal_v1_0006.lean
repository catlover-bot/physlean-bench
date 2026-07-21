import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Tactic

lemma Electromagnetism.FreeSpace.ε₀_mul_ℏ_nonneg :
    0 ≤ (Electromagnetism.FreeSpace.𝓕.ε₀ * (Constants.ℏ : ℝ)) :=
by
  have h₁ : 0 ≤ Electromagnetism.FreeSpace.𝓕.ε₀ := Electromagnetism.FreeSpace.ε₀_nonneg
  have h₂ : 0 ≤ (Constants.ℏ : ℝ) := Constants.ℏ_nonneg
  exact mul_nonneg h₁ h₂
