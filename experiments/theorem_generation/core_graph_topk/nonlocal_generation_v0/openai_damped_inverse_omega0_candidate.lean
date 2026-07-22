lemma inverse_ω₀_sq : (S.ω₀ ^ 2)⁻¹ = S.m / S.k := by
  have h := S.ω₀_sq
  have hk : S.k ≠ 0 := by
    have hω : S.ω₀ ≠ 0 := S.ω₀_ne_zero
    intro hk
    have : S.ω₀ ^ 2 = 0 := by simpa [hk] using h
    have : S.ω₀ = 0 := pow_eq_zero this
    exact hω this
  have hm : S.m ≠ 0 := by
    intro hm
    have : S.ω₀ ^ 2 = 0 := by simpa [hm] using h
    have hω : S.ω₀ ≠ 0 := S.ω₀_ne_zero
    have : S.ω₀ = 0 := pow_eq_zero this
    exact hω this
  field_simp [h, hk, hm]
