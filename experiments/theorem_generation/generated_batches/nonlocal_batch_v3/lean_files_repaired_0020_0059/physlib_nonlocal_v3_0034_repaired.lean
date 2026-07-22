import Physlib.QuantumMechanics.PlanckConstant
import Physlib.QuantumMechanics.OneDimension.HarmonicOscillator.Basic

lemma QuantumMechanics.OneDimension.HarmonicOscillator.ξ_ne_zero
    {Q : Type} [QuantumMechanics.OneDimension.HarmonicOscillator Q] :
    (QuantumMechanics.OneDimension.HarmonicOscillator.ξ (Q := Q) : ℝ) ≠ 0 :=
QuantumMechanics.OneDimension.HarmonicOscillator.ξ_ne_zero
