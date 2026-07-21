import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma Electromagnetism.FreeSpace.inv_ε₀_add_inv_ℏ_ne_zero
    {𝓕 : Electromagnetism.FreeSpace} :
    (1 / 𝓕.ε₀ + 1 / (Constants.ℏ : ℝ)) ≠ 0 :=
by
  have hε : 𝓕.ε₀ ≠ 0 := Electromagnetism.FreeSpace.ε₀_ne_zero (𝓕 := 𝓕)
  have hℏ : (Constants.ℏ : ℝ) ≠ 0 := Constants.ℏ_ne_zero
  intro h
  have h1 : (1 / 𝓕.ε₀) = - (1 / (Constants.ℏ : ℝ)) := by
    have := congrArg (fun x => x - (1 / (Constants.ℏ : ℝ))) h
    simpa [sub_eq_add_neg, add_comm, add_left_neg] using this
  have h2 : (1 / (Constants.ℏ : ℝ)) = - (1 / 𝓕.ε₀) := by
    simpa [h1, neg_neg]
  have hε' : (1 / 𝓕.ε₀) ≠ 0 := one_div_ne_zero hε
  have hℏ' : (1 / (Constants.ℏ : ℝ)) ≠ 0 := one_div_ne_zero hℏ
  have : (1 / 𝓕.ε₀) * (1 / (Constants.ℏ : ℝ)) ≠ 0 :=
    mul_ne_zero hε' hℏ'
  have : (1 / 𝓕.ε₀) * (1 / (Constants.ℏ : ℝ)) =
        (1 / 𝓕.ε₀) * (1 / (Constants.ℏ : ℝ)) * (-1) * (-1) := by
    ring
  exact this.elim (by simpa using this)
