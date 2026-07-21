import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma Electromagnetism.FreeSpace.ε₀_mul_ℏ_ne_zero (𝓕 : Electromagnetism.FreeSpace) :
  (𝓕.ε₀ * (ℏ : ℝ)) ≠ 0 :=
by
  have hε : 𝓕.ε₀ ≠ 0 := Electromagnetism.FreeSpace.ε₀_ne_zero (𝓕 := 𝓕)
  have hℏ : (ℏ : ℝ) ≠ 0 := Constants.ℏ_ne_zero
  exact mul_ne_zero hε hℏ
