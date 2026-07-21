import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma oscillator_frequency_sq_eq_of_same_params
  {S₁ : ClassicalMechanics.DampedHarmonicOscillator}
  {S₂ : ClassicalMechanics.HarmonicOscillator}
  (h_m : S₁.m = S₂.m) (h_k : S₁.k = S₂.k) :
  S₁.ω₀ ^ 2 = S₂.ω ^ 2 :=
by
  rw [S₁.ω₀_sq, S₂.ω_sq]
  rw [h_m, h_k]
