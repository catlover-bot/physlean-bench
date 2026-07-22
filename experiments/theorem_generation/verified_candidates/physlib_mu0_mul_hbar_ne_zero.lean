import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant

open Electromagnetism
open Constants

lemma Electromagnetism.FreeSpace.μ₀_mul_ℏ_ne_zero
  (𝓕 : Electromagnetism.FreeSpace) :
  𝓕.μ₀ * (ℏ : ℝ) ≠ 0 :=
by
  exact mul_ne_zero (Electromagnetism.FreeSpace.μ₀_ne_zero (𝓕 := 𝓕)) Constants.ℏ_ne_zero
