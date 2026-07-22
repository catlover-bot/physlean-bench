import Physlib.QuantumMechanics.PlanckConstant
import Physlib.QuantumMechanics.OneDimension.HarmonicOscillator.Basic

lemma QuantumMechanics.OneDimension.HarmonicOscillator.ξ_mul_ℏ_pos
  (Q : QuantumMechanics.OneDimension.HarmonicOscillator.System) :
  0 < (Q.ξ : ℝ) * (ℏ : ℝ) :=
by
  have hξ : 0 < (Q.ξ : ℝ) := QuantumMechanics.OneDimension.HarmonicOscillator.ξ_pos (Q := Q)
  have hℏ : 0 < (ℏ : ℝ) := Constants.ℏ_pos
  exact mul_pos hξ hℏ
