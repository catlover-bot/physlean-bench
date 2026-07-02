import Physlib.QuantumMechanics.PlanckConstant

lemma Constants.inv_ℏ_pos : 0 < (1 / (ℏ : ℝ)) :=
by
  have hh : 0 < (ℏ : ℝ) := Constants.ℏ_pos
  simpa [one_div] using inv_pos.mpr hh
