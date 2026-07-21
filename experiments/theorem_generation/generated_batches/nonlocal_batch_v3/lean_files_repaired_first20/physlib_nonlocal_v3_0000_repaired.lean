import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma ClassicalMechanics.HarmonicOscillator.ω_pos
    {S : ClassicalMechanics.HarmonicOscillator} :
    0 < S.ω := by
  simpa using ClassicalMechanics.DampedHarmonicOscillator.ω₀_pos (S := S.toDampedHarmonicOscillator)
