import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma ClassicalMechanics.DampedHarmonicOscillator.ω₀_le_max_ω₀_ω
    {S : ClassicalMechanics.DampedHarmonicOscillator.System}
    (H : ClassicalMechanics.HarmonicOscillator.System)
    (hrel : (S.ω₀ : ℝ) ≤ H.ω) :
    S.ω₀ ≤ max S.ω₀ H.ω := by
  have h₁ : 0 < S.ω₀ := ClassicalMechanics.DampedHarmonicOscillator.ω₀_pos (S := S)
  have h₂ : 0 < H.ω := ClassicalMechanics.HarmonicOscillator.ω_pos (S := H)
  exact le_max_left_of_le hrel
