import Physlib.Relativity.LorentzGroup.Boosts.Apply
import Physlib.Relativity.LorentzGroup.Boosts.Basic
import Mathlib

lemma LorentzGroup.boost_inr_self_inl_0_apply
    (i : Fin d) {β : ℝ} (hβ : |β| < 1) (p : Lorentz.Vector d) :
    (boost i β hβ • p) (Sum.inr i) =
      p (Sum.inr i) + (boost i β hβ).1 (Sum.inr i) (Sum.inl 0) * p (Sum.inl 0) :=
by
  classical
  have hcoord := Lorentz.Vector.boost_toCoord_eq (d := d) (i := i) β hβ p
  have hmat := LorentzGroup.boost_inr_self_inl_0 (d := d) i hβ
  specialize hcoord (Sum.inr i)
  simp [Lorentz.Vector.boost_toCoord_eq] at hcoord
  by_cases h : i = i
  · simp [h] at hcoord
    have : (boost i β hβ).1 (Sum.inr i) (Sum.inl 0) * p (Sum.inl 0)
        = - (γ β * β) * p (Sum.inl 0) := by simpa [hmat]
    simp [this, hcoord, mul_comm, mul_left_comm, mul_assoc]
  · exact (h (rfl))
