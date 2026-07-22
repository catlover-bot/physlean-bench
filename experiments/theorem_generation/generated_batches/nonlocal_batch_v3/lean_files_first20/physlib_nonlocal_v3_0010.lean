import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic
import Mathlib.Data.Real.Basic

lemma ClassicalMechanics.compare_damped_natfreq_inv_sq_to_undamped_inv_ω_sq
    {S₁ : ClassicalMechanics.DampedHarmonicOscillator.System}
    {S₂ : ClassicalMechanics.HarmonicOscillator.System}
    (hk₁ : S₁.k = S₂.k) (hm₁ : S₁.m = S₂.m) :
    (S₁.ω₀ ^ 2)⁻¹ = (S₂.ω ^ 2)⁻¹ := by
  have h₁ : (S₁.ω₀ ^ 2)⁻¹ = S₁.m / S₁.k := by
    have hω₀ : S₁.ω₀ ^ 2 = S₁.k / S₁.m := ClassicalMechanics.DampedHarmonicOscillator.ω₀_sq (S := S₁)
    have hω₀' : (S₁.ω₀ ^ 2)⁻¹ = (S₁.k / S₁.m)⁻¹ := by simpa [hω₀]
    simpa [inv_div] using hω₀'
  have h₂ : (S₂.ω ^ 2)⁻¹ = S₂.m / S₂.k :=
    ClassicalMechanics.HarmonicOscillator.inverse_ω_sq (S := S₂)
  simpa [hk₁, hm₁, h₂] using h₁
