import Physlib.QuantumMechanics.PlanckConstant
import Physlib.QuantumMechanics.OneDimension.HarmonicOscillator.Basic

lemma QuantumMechanics.OneDimension.HarmonicOscillator.ξ_div_ℏ_ne_zero
    {Q : QuantumSystem} [QuantumMechanics.OneDimension.HarmonicOscillator Q] :
    (Q.ξ / (ℏ : ℝ)) ≠ 0 :=
by
  have hξ : (Q.ξ : ℝ) ≠ 0 := ξ_ne_zero
  have hℏ : (ℏ : ℝ) ≠ 0 := Constants.ℏ_ne_zero
  have : (Q.ξ : ℝ) * (ℏ : ℝ) ≠ 0 := mul_ne_zero hξ hℏ
  intro h
  have h' : (Q.ξ : ℝ) = 0 := by
    have := congrArg (fun x => x * (ℏ : ℝ)) h
    simpa [div_eq_mul_inv, inv_mul_eq_iff_eq_mul₀ hℏ] using this
  exact hξ h'
