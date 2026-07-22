import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Physlib.Particles.StandardModel.AnomalyCancellation.Basic

lemma SM.repCharges_eq_iff
    (f : PermGroup n) (S T : (SMCharges n).Charges) :
    repCharges f S = repCharges f T ↔ S = T :=
by
  have hS := SM.repCharges_toSpecies f S
  have hT := SM.repCharges_toSpecies f T
  constructor
  · intro h
    have hspecies : ∀ i, toSpecies i S = toSpecies i T := by
      intro i
      specialize congrArg (toSpecies i) h
      simp [hS, hT] at *
    exact (SMCharges.charges_eq_toSpecies_eq S T).2 hspecies
  · intro h
    subst h
    rfl
