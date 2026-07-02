import Physlib.StatisticalMechanics.BoltzmannConstant

lemma Constants.inv_kB_pos : 0 < (1 / kB) :=
by
  have hk : 0 < kB := Constants.kB_pos
  simpa [one_div] using inv_pos.mpr hk
