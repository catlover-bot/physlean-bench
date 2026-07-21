import Physlib.Relativity.LorentzGroup.Boosts.Apply
import Physlib.Relativity.LorentzGroup.Boosts.Basic

lemma Lorentz.Vector.boost_time_eq_boost_inr_self_inl_0
  (d : ℕ) (i : Fin d) (β : ℝ) (hβ : |β| < 1)
  (p : Lorentz.Vector d)
  (hp : p (Sum.inl 0) = 0) :
  (boost i β hβ • p) (Sum.inl 0) =
    (boost i β hβ).1 (Sum.inr i) (Sum.inl 0) * p (Sum.inr i) :=
by
  have h₁ := Lorentz.Vector.boost_time_eq (i := i) (β := β) (hβ := hβ) (p := p)
  have h₂ := LorentzGroup.boost_inr_self_inl_0 (d := d) (i := i) (hβ := hβ)
  simp [hp, h₂, mul_comm, mul_left_comm, mul_assoc] at h₁
  simpa using h₁
