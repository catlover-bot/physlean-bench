import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma ClassicalMechanics.HarmonicOscillator.ω_le_DampedHarmonicOscillator.ω₀
    {S₁ : ClassicalMechanics.HarmonicOscillator.System}
    {S₂ : ClassicalMechanics.DampedHarmonicOscillator.System}
    (h : S₁.ω ≤ S₂.ω₀) :
    0 < S₂.ω₀ - S₁.ω :=
by
  have hω₁ : 0 < S₁.ω := ClassicalMechanics.HarmonicOscillator.ω_pos (S := S₁)
  have hω₂ : 0 < S₂.ω₀ := ClassicalMechanics.DampedHarmonicOscillator.ω₀_pos (S := S₂)
  have hne : S₁.ω ≠ S₂.ω₀ := by
    intro hEq
    have : ¬ (S₁.ω < S₂.ω₀) := not_lt_of_ge h
    have : S₁.ω < S₂.ω₀ := by simpa [hEq] using hω₂
    exact this.elim this
  have hlt : S₁.ω < S₂.ω₀ := lt_of_le_of_ne h (Ne.symm hne)
  exact sub_pos.mpr hlt
