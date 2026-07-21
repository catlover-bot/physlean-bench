import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma equal_natural_frequency_sq
  {S₁ : Physlib.ClassicalMechanics.DampedHarmonicOscillator.System}
  {S₂ : Physlib.ClassicalMechanics.HarmonicOscillator.System}
  (h_m : S₁.m = S₂.m) (h_k : S₁.k = S₂.k) :
  S₁.ω₀ ^ 2 = S₂.ω ^ 2 :=
by
  have h₁ : S₁.ω₀ ^ 2 = S₁.k / S₁.m := S₁.ω₀_sq
  have h₂ : (S₂.ω ^ 2)⁻¹ = S₂.m / S₂.k := S₂.inverse_ω_sq
  have hm' : (S₁.m : ℝ) ≠ 0 := by
    have := S₁.m_pos
    exact ne_of_gt this
  have hk' : (S₁.k : ℝ) ≠ 0 := by
    have := S₁.k_pos
    exact ne_of_gt this
  have hm₂' : (S₂.m : ℝ) ≠ 0 := by
    simpa [h_m] using hm'
  have hk₂' : (S₂.k : ℝ) ≠ 0 := by
    simpa [h_k] using hk'
  have h₂' : S₂.ω ^ 2 = S₂.k / S₂.m :=
    by
      have : (S₂.ω ^ 2) ≠ 0 :=
        by
          have hpos := S₂.ω_pos
          exact pow_ne_zero 2 (ne_of_gt hpos)
      apply inv_injective₀ this
      simpa [div_eq_mul_inv, inv_inv, mul_comm, mul_left_comm, mul_assoc]
        using congrArg (fun x => x⁻¹) h₂
  have h₂'' : S₂.ω ^ 2 = S₁.k / S₁.m :=
    by
      simpa [h_m, h_k] using h₂'
  exact h₁.trans h₂''.symm
