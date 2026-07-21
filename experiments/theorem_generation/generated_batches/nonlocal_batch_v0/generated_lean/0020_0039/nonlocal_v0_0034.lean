import Physlib.Relativity.LorentzGroup.Boosts.Apply
import Physlib.Relativity.LorentzGroup.Boosts.Basic

lemma Lorentz.Vector.boost_time_eq_sub_spatial
  (i : Fin d) (β : ℝ) (hβ : |β| < 1) (p : Lorentz.Vector d) :
  (boost i β hβ • p) (Sum.inl 0) - p (Sum.inl 0) =
    (boost i β hβ).1 (Sum.inl 0) (Sum.inl 0) * p (Sum.inl 0) +
      (boost i β hβ).1 (Sum.inl 0) (Sum.inr i) * p (Sum.inr i) :=
by
  have h0 :=
    Lorentz.Vector.boost_time_eq (d := d) i β hβ p
  have h1 :=
    LorentzGroup.boost_inl_0_inr_self (d := d) i hβ
  have hγ : γ β ≠ 0 := by
    have hlt : (0 : ℝ) < 1 - β ^ 2 := by
      have : β ^ 2 < 1 := by
        have := sq_lt_sq.mpr hβ
        simpa [abs_sq, one_pow] using this
      have h' : 1 - β ^ 2 > 0 := sub_pos.mpr this
      simpa [sub_eq, add_comm, add_left_neg] using h'
    have hden : (1 - β ^ 2) ≠ 0 := ne_of_gt hlt
    unfold γ
    have : (Real.sqrt (1 - β ^ 2)) ≠ 0 := by
      exact ne_of_gt (Real.sqrt_pos.mpr hlt)
    exact one_div_ne_zero this
  have hcoeff_time :
      (boost i β hβ).1 (Sum.inl 0) (Sum.inl 0) = γ β :=
  by
    classical
    have ht := congrArg (fun x => x - (boost i β hβ).1 (Sum.inl 0) (Sum.inr i) * p (Sum.inr i)) h0
    have hlin :
        (boost i β hβ • p) (Sum.inl 0)
          = (boost i β hβ).1 (Sum.inl 0) (Sum.inl 0) * p (Sum.inl 0)
            + (boost i β hβ).1 (Sum.inl 0) (Sum.inr i) * p (Sum.inr i) :=
    by
      -- linearity in the basis {inl 0, inr i} is encoded by the matrix action;
      -- it suffices to match coefficients using a separating family of vectors.
      -- Use the vector with only time component nonzero.
      have htvec :
          (boost i β hβ • (fun x => if x = Sum.inl 0 then (1 : ℝ) else 0)) (Sum.inl 0)
            = (boost i β hβ).1 (Sum.inl 0) (Sum.inl 0) :=
      by
        simp [Lorentz.Vector.smul, Matrix.mulVec, Matrix.dotProduct]
      have hγvec :
          (boost i β hβ • (fun x => if x = Sum.inl 0 then (1 : ℝ) else 0)) (Sum.inl 0)
            = γ β :=
      by
        have := Lorentz.Vector.boost_time_eq (d := d) i β hβ
          (fun x => if x = Sum.inl 0 then (1 : ℝ) else 0)
        simpa [htvec] using this
      simpa [htvec] using hγvec
    simpa [hlin, h1, mul_comm, mul_left_comm, mul_assoc,
      sub_eq_add_neg, add_comm, add_left_comm, add_assoc,
      left_distrib, right_distrib, mul_add, add_mul, hγ] using h0
  classical
  have hlin_full :
      (boost i β hβ • p) (Sum.inl 0)
        = (boost i β hβ).1 (Sum.inl 0) (Sum.inl 0) * p (Sum.inl 0)
          + (boost i β hβ).1 (Sum.inl 0) (Sum.inr i) * p (Sum.inr i) :=
  by
    -- use the known coefficient for the spatial part from cluster B
    have hs : (boost i β hβ).1 (Sum.inl 0) (Sum.inr i) = - γ β * β := h1
    have := Lorentz.Vector.boost_time_eq (d := d) i β hβ p
    simpa [hs, hcoeff_time, mul_comm, mul_left_comm, mul_assoc,
      sub_eq_add_neg, add_comm, add_left_comm, add_assoc,
      left_distrib, right_distrib, mul_add, add_mul] using this
  simpa [hlin_full, sub_eq_add_neg, add_comm, add_left_comm, add_assoc]
