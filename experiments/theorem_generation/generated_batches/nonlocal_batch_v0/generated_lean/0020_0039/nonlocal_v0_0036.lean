import Physlib.Relativity.LorentzGroup.Boosts.Apply
import Physlib.Relativity.LorentzGroup.Boosts.Basic

lemma Lorentz.Vector.boost_inr_self_eq_sub_time
  (i : Fin d) (β : ℝ) (hβ : |β| < 1) (p : Vector d) :
  (boost i β hβ • p) (Sum.inr i) =
    p (Sum.inr i) + (boost i β hβ).1 (Sum.inl 0) (Sum.inr i) * p (Sum.inl 0) :=
by
  have h₁ := Lorentz.Vector.boost_inr_self_eq (i := i) (β := β) (hβ := hβ) (p := p)
  have h₂ := LorentzGroup.boost_inl_0_inr_self (d := d) (i := i) (hβ := hβ)
  simp [h₂, mul_comm, sub_eq_add_neg, add_comm, add_left_comm, add_assoc] at h₁
  simpa [h₂, mul_comm, sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using h₁
