import Physlib.Relativity.LorentzGroup.Boosts.Apply
import Physlib.Relativity.LorentzGroup.Boosts.Basic

lemma Lorentz.Vector.boost_toCoord_inl_0_inr_self
    (i : Fin d) (β : ℝ) (hβ : |β| < 1) (p : Lorentz.Vector d) :
    (boost i β hβ • p) (Sum.inl 0) - p (Sum.inl 0) =
      (boost i β hβ).1 (Sum.inl 0) (Sum.inl 0) * p (Sum.inl 0) +
      (boost i β hβ).1 (Sum.inl 0) (Sum.inr i) * p (Sum.inr i) := by
  classical
  have h := Lorentz.Vector.boost_toCoord_eq (i := i) (β := β) (hβ := hβ) (p := p)
  have h0 := congrArg (fun f => f (Sum.inl 0)) h
  simp at h0
  -- h0 : (boost i β hβ • p) (Sum.inl 0) =
  --   γ β * (p (Sum.inl 0) - β * p (Sum.inr i))
  -- Expand RHS using matrix coefficients of the boost
  have h00 : (boost i β hβ).1 (Sum.inl 0) (Sum.inl 0) = γ β := by
    -- This follows from the standard form of the boost matrix; use coord equality on basis vector e₀
    have := Lorentz.Vector.boost_toCoord_eq (i := i) (β := β) (hβ := hβ)
      (p := fun j => if j = Sum.inl 0 then (1 : ℝ) else 0)
    have h00' := congrArg (fun f => f (Sum.inl 0)) this
    simp at h00'
    -- Left side is (boost • e₀)₀ = L₀₀
    -- Right side simplifies to γ β
    simpa using h00'
  have h0i : (boost i β hβ).1 (Sum.inl 0) (Sum.inr i) = - γ β * β :=
    LorentzGroup.boost_inl_0_inr_self (i := i) (hβ := hβ)
  -- Rewrite using these matrix entries
  calc
    (boost i β hβ • p) (Sum.inl 0) - p (Sum.inl 0)
        = γ β * (p (Sum.inl 0) - β * p (Sum.inr i)) - p (Sum.inl 0) := by
          simpa [h0]
    _ = (γ β - 1) * p (Sum.inl 0) + (- γ β * β) * p (Sum.inr i) := by
          ring_nf
    _ = (boost i β hβ).1 (Sum.inl 0) (Sum.inl 0) * p (Sum.inl 0) +
        (boost i β hβ).1 (Sum.inl 0) (Sum.inr i) * p (Sum.inr i) := by
          simpa [h00, h0i, mul_add, add_comm, add_left_comm, add_assoc, sub_eq_add_neg, one_mul]
