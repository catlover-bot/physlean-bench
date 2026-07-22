import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations

lemma SM.repCharges_eq_iff
  {n : ℕ} (f : PermGroup n) (S T : (SMCharges n).Charges) :
  repCharges f S = repCharges f T ↔ S = T :=
by
  constructor
  · intro h
    apply (SMCharges.charges_eq_toSpecies_eq S T).mpr
    intro i
    have h' := congrArg (fun c => (SMCharges.toSpecies c i)) h
    have hS := SM.repCharges_toSpecies f S i
    have hT := SM.repCharges_toSpecies f T i
    simpa [hS, hT] using h'
  · intro h
    simpa [h]
