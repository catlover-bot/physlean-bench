import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma ClassicalMechanics.DampedHarmonicOscillator.ω₀_ge_HarmonicOscillator_ω
    {S₁ : ClassicalMechanics.DampedHarmonicOscillator.System}
    {S₂ : ClassicalMechanics.HarmonicOscillator.System}
    (h : S₂.ω ≤ S₁.ω₀) :
    0 < S₂.ω :=
by
  have hω₀ : 0 < S₁.ω₀ := ClassicalMechanics.DampedHarmonicOscillator.ω₀_pos (S := S₁)
  have hω₀' : (0 : ℝ) ≤ S₁.ω₀ := le_of_lt hω₀
  exact lt_of_le_of_lt (show (0 : ℝ) ≤ S₂.ω from le_trans (by exact le_of_eq rfl) (le_trans (le_of_lt ClassicalMechanics.HarmonicOscillator.ω_pos) h)) ClassicalMechanics.HarmonicOscillator.ω_pos
