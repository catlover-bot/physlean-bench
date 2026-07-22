import Physlib.QuantumMechanics.PlanckConstant
import Physlib.QuantumMechanics.OneDimension.HarmonicOscillator.Basic

lemma QuantumMechanics.OneDimension.HarmonicOscillator.ξ_pos :
  0 < (QuantumMechanics.OneDimension.HarmonicOscillator.ξ : ℝ) :=
by
  simpa using QuantumMechanics.OneDimension.HarmonicOscillator.ξ_positive
