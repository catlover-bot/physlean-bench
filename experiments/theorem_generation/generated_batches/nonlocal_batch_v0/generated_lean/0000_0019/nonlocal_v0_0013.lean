import Physlib.Electromagnetism.Dynamics.Basic
import Physlib.QuantumMechanics.PlanckConstant
import Mathlib.Algebra.Order.Field.Basic

open Electromagnetism
open Electromagnetism.FreeSpace
open Constants

lemma ℏ_mul_μ₀_nonneg : 0 ≤ (ℏ : ℝ) * 𝓕.μ₀ :=
by
  have h₁ : 0 ≤ (ℏ : ℝ) := ℏ_nonneg
  have h₂ : 0 ≤ 𝓕.μ₀ := μ₀_nonneg
  exact mul_nonneg h₁ h₂
