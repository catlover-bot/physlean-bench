import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma ClassicalMechanics.compare_ω₀_ω
    {S₁ : ClassicalMechanics.DampedHarmonicOscillator.System}
    {S₂ : ClassicalMechanics.HarmonicOscillator.System}
    (h : (S₁.ω₀ : ℝ) ≤ S₂.ω) :
    0 < S₂.ω - S₁.ω₀ :=
sub_pos.mpr (lt_of_le_of_lt h ClassicalMechanics.DampedHarmonicOscillator.ω₀_pos)
