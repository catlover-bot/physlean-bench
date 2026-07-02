import Physlib.StatisticalMechanics.BoltzmannConstant
import Physlib.QuantumMechanics.PlanckConstant

lemma Constants.kB_mul_ℏ_pos : 0 < kB * (ℏ : ℝ) :=
by
  exact mul_pos Constants.kB_pos Constants.ℏ_pos

lemma Constants.kB_div_ℏ_pos : 0 < kB / (ℏ : ℝ) :=
by
  exact div_pos Constants.kB_pos Constants.ℏ_pos

lemma Constants.ℏ_div_kB_pos : 0 < (ℏ : ℝ) / kB :=
by
  exact div_pos Constants.ℏ_pos Constants.kB_pos
