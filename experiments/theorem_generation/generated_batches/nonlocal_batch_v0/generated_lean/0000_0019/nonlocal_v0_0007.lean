import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma ClassicalMechanics.DampedHarmonicOscillator.ω₀_sq_eq_ω_sq
    {S₁ : ClassicalMechanics.HarmonicOscillator.System}
    {S₂ : ClassicalMechanics.DampedHarmonicOscillator.System}
    (hk : S₁.k = S₂.k) (hm : S₁.m = S₂.m) :
    S₂.ω₀ ^ 2 = S₁.ω ^ 2 :=
by
  have h₁ : S₂.ω₀ ^ 2 = S₂.k / S₂.m := ClassicalMechanics.DampedHarmonicOscillator.ω₀_sq (S := S₂)
  have h₂ : S₁.ω ^ 2 = S₁.k / S₁.m := ClassicalMechanics.HarmonicOscillator.ω_sq (S := S₁)
  simp [h₁, h₂, hk, hm]
