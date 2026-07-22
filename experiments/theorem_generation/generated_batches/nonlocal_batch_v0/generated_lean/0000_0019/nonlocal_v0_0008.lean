import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic

lemma Electromagnetism.FreeSpace.inv_ε₀_le_sq_over_ℏ
    (𝓕 : Electromagnetism.FreeSpace) :
    (0 : ℝ) ≤ 1 / 𝓕.ε₀ → 0 ≤ (𝓕.ε₀ ^ 2) / (ℏ : ℝ) :=
by
  intro h
  have hε : 0 ≤ 𝓕.ε₀ := 𝓕.ε₀_nonneg
  have hℏ : 0 ≤ (ℏ : ℝ) := Constants.ℏ_nonneg
  have hεsq : 0 ≤ 𝓕.ε₀ ^ 2 := by
    have := sq_nonneg (𝓕.ε₀)
    simpa [pow_two] using this
  rcases eq_or_lt_of_le hℏ with hℏeq | hℏlt
  · have : (ℏ : ℝ) = 0 := hℏeq
    simp [this] at h
  · have hℏpos : 0 < (ℏ : ℝ) := lt_of_le_of_ne hℏ (ne_of_lt hℏlt)
    have : 0 ≤ (𝓕.ε₀ ^ 2) / (ℏ : ℝ) := div_nonneg hεsq (le_of_lt hℏpos)
    exact this
