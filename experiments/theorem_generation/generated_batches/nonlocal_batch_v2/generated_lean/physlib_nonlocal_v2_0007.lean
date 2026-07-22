import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Data.Real.Basic

lemma Electromagnetism.Quantum.bridge_μ₀_ℏ_nonneg :
  0 ≤ (Electromagnetism.FreeSpace.μ₀ * (ℏ : ℝ)) :=
by
  have hμ : 0 ≤ Electromagnetism.FreeSpace.μ₀ := Electromagnetism.FreeSpace.μ₀_nonneg
  have hℏ : 0 ≤ (ℏ : ℝ) := Constants.ℏ_nonneg
  exact mul_nonneg hμ hℏ
