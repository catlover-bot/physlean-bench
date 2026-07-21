import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma undamped_frequency_eq_damped_natural_frequency_sq
    {S₁ : ClassicalMechanics.HarmonicOscillator}
    {S₂ : ClassicalMechanics.DampedHarmonicOscillator}
    (hk : S₁.k = S₂.k) (hm : S₁.m = S₂.m) :
    S₁.ω^2 = S₂.ω₀^2 := by
  have h₁ : S₁.ω^2 = S₁.k / S₁.m :=
    ClassicalMechanics.HarmonicOscillator.ω_sq (S := S₁)
  have h₂ : S₂.ω₀^2 = S₂.k / S₂.m :=
    ClassicalMechanics.DampedHarmonicOscillator.ω₀_sq (S := S₂)
  have hkm : S₁.k / S₁.m = S₂.k / S₂.m := by simpa [hk, hm]
  calc
    S₁.ω^2 = S₁.k / S₁.m := h₁
    _ = S₂.k / S₂.m := hkm
    _ = S₂.ω₀^2 := by simpa [h₂]
