import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma Electromagnetism.FreeSpace.inv_μ₀_add_inv_ℏ_pos
    (𝓕 : Electromagnetism.FreeSpace) :
    0 < (1 / 𝓕.μ₀ + 1 / (ℏ : ℝ)) :=
by
  have hμ₀ : 0 < 𝓕.μ₀ :=
    lt_of_le_of_ne (le_of_not_gt (by
      intro h
      have : 𝓕.μ₀ = 0 := le_antisymm (le_of_lt h) (le_of_lt (by exact h))
      exact Electromagnetism.FreeSpace.μ₀_ne_zero 𝓕 this))
      (Electromagnetism.FreeSpace.μ₀_ne_zero 𝓕)
  have hℏ₀ : 0 < (ℏ : ℝ) ∨ (ℏ : ℝ) < 0 :=
    lt_trichotomy (0 : ℝ) ℏ
  have hℏ : 0 < |(ℏ : ℝ)| :=
    abs_pos.mpr Constants.ℏ_ne_zero
  have h_inv_μ₀ : 0 < 1 / 𝓕.μ₀ :=
    one_div_pos.mpr hμ₀
  have h_inv_ℏ : 0 < |1 / (ℏ : ℝ)| :=
    by
      have : 1 / (ℏ : ℝ) ≠ 0 :=
        one_div_ne_zero Constants.ℏ_ne_zero
      exact abs_pos.mpr this
  have h_inv_ℏ_nonneg : 0 ≤ 1 / (ℏ : ℝ) + |1 / (ℏ : ℝ)| :=
    by
      have := le_abs_self (1 / (ℏ : ℝ))
      exact add_nonneg_of_nonneg_of_nonneg (le_of_lt (lt_of_le_of_lt (le_abs_self _) (lt_of_le_of_lt (le_of_eq rfl) h_inv_ℏ))) (abs_nonneg _)
  have : 1 / 𝓕.μ₀ + 1 / (ℏ : ℝ) ≥ 1 / 𝓕.μ₀ - |1 / (ℏ : ℝ)| :=
    by
      have := sub_le_iff_le_add'.mpr (le_of_lt (lt_of_le_of_lt (le_of_eq rfl) h_inv_ℏ))
      have h' : 1 / (ℏ : ℝ) ≥ -|1 / (ℏ : ℝ)| :=
        by
          have := neg_le_abs (1 / (ℏ : ℝ))
          simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using this
      exact
        le_trans
          (by
            have := add_le_add_left h' (1 / 𝓕.μ₀)
            simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using this)
          (le_of_eq (by ring))
  have h_lower : 0 < 1 / 𝓕.μ₀ - |1 / (ℏ : ℝ)| ∨ 1 / 𝓕.μ₀ - |1 / (ℏ : ℝ)| ≤ 0 :=
    lt_or_ge 0 (1 / 𝓕.μ₀ - |1 / (ℏ : ℝ)|)
  refine lt_of_le_of_lt ?_ ?_
  · exact le_trans (by linarith) this
  · exact lt_of_le_of_lt (by have := le_of_lt h_inv_μ₀; linarith) (by linarith)
