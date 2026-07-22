import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma ClassicalMechanics.DampedHarmonicOscillator.ω₀_sq_eq_inverse_ω_sq
    (S₁ : ClassicalMechanics.DampedHarmonicOscillator.System)
    (S₂ : ClassicalMechanics.HarmonicOscillator.System)
    (h_m : S₁.m = S₂.m)
    (h_k : S₁.k = S₂.k) :
    (S₁.ω₀ ^ 2) = (S₂.ω ^ 2)⁻¹ := by
  have h₁ : S₁.ω₀ ^ 2 = S₁.k / S₁.m := ClassicalMechanics.DampedHarmonicOscillator.ω₀_sq (S := S₁)
  have h₂ : (S₂.ω ^ 2)⁻¹ = S₂.m / S₂.k := ClassicalMechanics.HarmonicOscillator.inverse_ω_sq (S := S₂)
  have h₃ : S₁.k / S₁.m = S₂.m / S₂.k := by
    simpa [h_m, h_k] using congrArg (fun x => x / x) h_m
  calc
    S₁.ω₀ ^ 2 = S₁.k / S₁.m := h₁
    _ = S₂.m / S₂.k := h₃
    _ = (S₂.ω ^ 2)⁻¹ := h₂.symm
