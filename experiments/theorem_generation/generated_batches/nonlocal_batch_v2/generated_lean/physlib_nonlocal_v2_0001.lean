import Physlib.ClassicalMechanics.DampedHarmonicOscillator.Basic
import Physlib.ClassicalMechanics.HarmonicOscillator.Basic

lemma ClassicalMechanics.HarmonicOscillator.ω_eq_ω₀
  {S₁ : ClassicalMechanics.HarmonicOscillator.System}
  {S₂ : ClassicalMechanics.DampedHarmonicOscillator.System}
  (hk : S₁.k = S₂.k) (hm : S₁.m = S₂.m) :
  S₁.ω = S₂.ω₀ :=
by
  have h₁ : S₁.ω^2 = S₂.k / S₂.m := by
    simpa [hk, hm] using ClassicalMechanics.HarmonicOscillator.ω_sq (S := S₁)
  have h₂ : S₂.ω₀^2 = S₂.k / S₂.m :=
    ClassicalMechanics.DampedHarmonicOscillator.ω₀_sq (S := S₂)
  have h₃ : S₁.ω^2 = S₂.ω₀^2 := by
    simpa [h₂] using h₁
  have hω : S₁.ω = S₂.ω₀ ∨ S₁.ω = -S₂.ω₀ := by
    simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using
      sub_eq_zero.1 (sq_eq_sq_iff_eq_or_eq_neg.mp h₃)
  exact hω.elim id (fun h => by
    have : S₁.ω = S₂.ω₀ := by
      simpa [h, neg_eq_iff_add_eq_zero, add_comm] using
        (eq_of_sub_eq_zero (by simpa [sub_eq_add_neg, add_comm] using rfl))
    exact this)
