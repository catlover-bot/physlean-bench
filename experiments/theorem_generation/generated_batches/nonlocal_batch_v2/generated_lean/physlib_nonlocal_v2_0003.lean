import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma Electromagnetism.FreeSpace.inv_add_μ₀_mul_ℏ_pos
  (𝓕 : Electromagnetism.FreeSpace) (hℏ : 0 < (ℏ : ℝ)) :
  0 < (1 + 𝓕.μ₀ * (ℏ : ℝ)) :=
by
  have hμ₀ := Electromagnetism.FreeSpace.μ₀_nonneg (𝓕 := 𝓕)
  have hμ₀ℏ : 0 ≤ 𝓕.μ₀ * (ℏ : ℝ) :=
    mul_nonneg hμ₀ Constants.ℏ_nonneg
  have h₀_le : (0 : ℝ) ≤ 1 + 𝓕.μ₀ * (ℏ : ℝ) :=
    by
      have : (0 : ℝ) ≤ 1 := by norm_num
      exact add_nonneg this hμ₀ℏ
  have h_ne : (1 + 𝓕.μ₀ * (ℏ : ℝ)) ≠ 0 :=
    by
      have hℏ_ne : (ℏ : ℝ) ≠ 0 := ne_of_gt hℏ
      intro h
      have : 𝓕.μ₀ * (ℏ : ℝ) = (-1 : ℝ) := by
        have := congrArg (fun x => x - 1) h
        simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using this
      have hμ₀_lt : 𝓕.μ₀ < 0 :=
        by
          have : (0 : ℝ) < 𝓕.μ₀ :=
            lt_of_le_of_ne hμ₀ (by
              intro hμ
              have : 𝓕.μ₀ * (ℏ : ℝ) = 0 := by simpa [hμ] using mul_zero (ℏ : ℝ)
              have : (0 : ℝ) = (-1 : ℝ) := by simpa [this] using this.symm
              norm_num at this)
          exact this
      exact lt_irrefl _ (lt_of_le_of_lt hμ₀ hμ₀_lt)
  exact lt_of_le_of_ne' h₀_le h_ne
