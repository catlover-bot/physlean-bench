import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma ClassicalMechanics.DampedHarmonicOscillator.ω₀_sq_eq_inverse_ω_sq
    {S₁ : ClassicalMechanics.HarmonicOscillator.System}
    {S₂ : ClassicalMechanics.DampedHarmonicOscillator.System}
    (h_m : S₂.m = S₁.m) (h_k : S₂.k = S₁.k) :
    (S₂.ω₀ ^ 2)⁻¹ = S₁.ω ^ 2⁻¹ :=
by
  have h1 : S₂.ω₀ ^ 2 = S₂.k / S₂.m := ClassicalMechanics.DampedHarmonicOscillator.ω₀_sq (S := S₂)
  have h2 : (S₁.ω ^ 2)⁻¹ = S₁.m / S₁.k := ClassicalMechanics.HarmonicOscillator.inverse_ω_sq (S := S₁)
  have h3 : (S₂.ω₀ ^ 2)⁻¹ = S₂.m / S₂.k := by
    have hk_ne : S₂.k ≠ 0 := by
      intro hk
      have : (S₂.k / S₂.m) = 0 := by simpa [hk] using (zero_div (S₂.m))
      have : S₂.ω₀ ^ 2 = 0 := by simpa [h1, this]
      have : (S₂.ω₀ ^ 2)⁻¹ = 0⁻¹ := by simpa [this]
      simpa using this
    have hm_ne : S₂.m ≠ 0 := by
      intro hm
      have : (S₂.k / S₂.m) = 0 := by simpa [hm, div_zero] using (rfl : (S₂.k / S₂.m) = S₂.k / S₂.m)
      have : S₂.ω₀ ^ 2 = 0 := by simpa [h1, this]
      have : (S₂.ω₀ ^ 2)⁻¹ = 0⁻¹ := by simpa [this]
      simpa using this
    have : (S₂.ω₀ ^ 2)⁻¹ = (S₂.k / S₂.m)⁻¹ := by simpa [h1]
    simpa [div_eq_mul_inv, inv_mul_eq_iff_eq_mul₀, mul_comm, hk_ne, hm_ne] using this
  have h4 : S₂.m / S₂.k = S₁.m / S₁.k := by
    simpa [h_m, h_k]
  have : (S₂.ω₀ ^ 2)⁻¹ = S₁.m / S₁.k := by simpa [h4] using h3
  have : (S₂.ω₀ ^ 2)⁻¹ = (S₁.ω ^ 2)⁻¹ := by simpa [h2] using this
  simpa using this
