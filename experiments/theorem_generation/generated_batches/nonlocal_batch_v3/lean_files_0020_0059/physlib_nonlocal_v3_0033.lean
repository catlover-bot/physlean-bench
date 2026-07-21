import Physlib.QuantumMechanics.PlanckConstant
import Physlib.QuantumMechanics.OneDimension.HarmonicOscillator.Basic

lemma QuantumMechanics.OneDimension.HarmonicOscillator.ξ_mul_ℏ_nonneg
    {Q : QuantumMechanics.OneDimension.HarmonicOscillator.System} :
    0 ≤ Q.ξ * (ℏ : ℝ) :=
by
  have hξ : 0 ≤ Q.ξ := QuantumMechanics.OneDimension.HarmonicOscillator.ξ_nonneg
  have hℏ : 0 ≤ (ℏ : ℝ) := Constants.ℏ_nonneg
  exact mul_nonneg hξ hℏ
