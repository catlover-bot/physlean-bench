import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma Electromagnetism.FreeSpace.inv_μ₀_mul_ℏ_ne_zero {𝓕 : Electromagnetism.FreeSpace} :
  (𝓕.μ₀⁻¹ * (ℏ : ℝ)) ≠ 0 :=
by
  have hμ : (𝓕.μ₀ : ℝ) ≠ 0 := Electromagnetism.FreeSpace.μ₀_ne_zero
  have hμ_inv : (𝓕.μ₀ : ℝ)⁻¹ ≠ 0 := inv_ne_zero hμ
  exact mul_ne_zero hμ_inv Constants.ℏ_ne_zero
