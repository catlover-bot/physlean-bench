import Physlib.Electromagnetism.Dynamics.Basic

lemma Electromagnetism.FreeSpace.μ₀_ne_zero
    (𝓕 : Electromagnetism.FreeSpace) :
    (𝓕.μ₀ : ℝ) ≠ 0 :=
by
  have hpos : 0 < (𝓕.μ₀ : ℝ) := Electromagnetism.FreeSpace.μ₀_pos 𝓕
  exact ne_of_gt hpos
