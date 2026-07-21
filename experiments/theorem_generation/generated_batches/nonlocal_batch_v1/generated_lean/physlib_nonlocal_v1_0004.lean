import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma Constants.mul_ℏ_ε₀_ne_zero
    (𝓕 : Electromagnetism.FreeSpace) :
    (ℏ : ℝ) * 𝓕.ε₀ ≠ 0 :=
by
  exact mul_ne_zero Constants.ℏ_ne_zero 𝓕.ε₀_ne_zero
