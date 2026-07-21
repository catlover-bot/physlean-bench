import Physlib.QuantumMechanics.PlanckConstant
import Physlib.QuantumMechanics.OneDimension.HarmonicOscillator.Basic
import Mathlib.Data.Real.Basic

lemma QuantumMechanics.OneDimension.HarmonicOscillator.ξ_mul_ℏ_nonneg
    (Q : Type) [QuantumMechanics.OneDimension.HarmonicOscillator.HasCoordinate Q] :
    0 ≤ QuantumMechanics.OneDimension.HarmonicOscillator.ξ (Q := Q) *
        (Constants.ℏ : ℝ) :=
by
  have hξ : 0 ≤ QuantumMechanics.OneDimension.HarmonicOscillator.ξ (Q := Q) :=
    QuantumMechanics.OneDimension.HarmonicOscillator.ξ_nonneg (Q := Q)
  have hℏ : 0 ≤ (Constants.ℏ : ℝ) :=
    by simpa using (Constants.ℏ_nonneg)
  exact mul_nonneg hξ hℏ
