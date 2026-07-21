import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations

lemma SM.repCharges_eq_iff
  {n : ℕ} (f : PermGroup n) (S T : (SMCharges n).Charges) :
  repCharges f S = repCharges f T ↔ S = T :=
by
  constructor
  · intro h
    have h_species :
      ∀ i, toSpecies i S = toSpecies i T :=
    by
      intro i
      have h' := congrArg (toSpecies i) h
      have hS := SM.repCharges_toSpecies f S i
      have hT := SM.repCharges_toSpecies f T i
      dsimp at h' hS hT
      simpa [hS, hT] using h'
    exact (SMCharges.charges_eq_toSpecies_eq S T).mpr h_species
  · intro h
    simpa [h]
