import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma ClassicalMechanics.equal_mass_to_stiffness_ratio
    {S₁ : ClassicalMechanics.DampedHarmonicOscillator.System}
    {S₂ : ClassicalMechanics.HarmonicOscillator.System}
    (h_m : S₁.m = S₂.m) (h_k : S₁.k = S₂.k) :
    (S₁.ω₀ ^ 2)⁻¹ = (S₂.ω ^ 2)⁻¹ := by
  have h₁ : (S₁.ω₀ ^ 2)⁻¹ = S₁.m / S₁.k := by
    have hω₀ : S₁.ω₀ ^ 2 = S₁.k / S₁.m := ClassicalMechanics.DampedHarmonicOscillator.ω₀_sq (S := S₁)
    have hω₀_inv : (S₁.ω₀ ^ 2)⁻¹ = (S₁.k / S₁.m)⁻¹ := by simpa [hω₀]
    simpa [div_eq_mul_inv, inv_mul_eq_iff_eq_mul₀, mul_inv_rev₀, inv_inv, mul_comm, mul_left_comm,
      mul_assoc, mul_left_cancel₀] using hω₀_inv
  have h₂ : (S₂.ω ^ 2)⁻¹ = S₂.m / S₂.k :=
    ClassicalMechanics.HarmonicOscillator.inverse_ω_sq (S := S₂)
  simp [h₁, h₂, h_m, h_k]
