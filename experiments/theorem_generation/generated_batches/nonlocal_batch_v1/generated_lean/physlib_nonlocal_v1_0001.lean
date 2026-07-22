import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma ClassicalMechanics.HarmonicOscillator.ω_eq_ω₀
  {S₁ : ClassicalMechanics.HarmonicOscillator.System}
  {S₂ : ClassicalMechanics.DampedHarmonicOscillator.System}
  (hk : S₁.k = S₂.k) (hm : S₁.m = S₂.m) :
  S₁.ω = S₂.ω₀ :=
by
  have h₁ : S₁.ω ^ 2 = S₁.k / S₁.m := ClassicalMechanics.HarmonicOscillator.ω_sq (S := S₁)
  have h₂ : S₂.ω₀ ^ 2 = S₂.k / S₂.m := ClassicalMechanics.DampedHarmonicOscillator.ω₀_sq (S := S₂)
  have h₃ : S₁.k / S₁.m = S₂.k / S₂.m := by simpa [hk, hm]
  have h₄ : S₁.ω ^ 2 = S₂.ω₀ ^ 2 := by simpa [h₂] using h₁.trans h₃
  exact pow_left_injective_of_pos (by exact two_pos) (by have : (0:ℝ) < S₁.ω^2 := sq_pos_of_ne_zero _ (by intro h; simpa [h] using h₄) ; simpa using this) h₄
