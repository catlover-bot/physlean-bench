import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Physlib.Particles.StandardModel.AnomalyCancellation.Basic

lemma SMCharges.charges_eq_toSpecies_eq
    {n} (S T : (SMCharges n).Charges) :
    (∀ i, (SMCharges.toSpecies i S) = (SMCharges.toSpecies i T)) ↔ S = T :=
by
  constructor
  · intro h
    -- Use the existing equivalence from Physlib (direction: toSpecies equality ⇒ charges equality)
    exact (SMCharges.charges_eq_toSpecies_eq S T).2 h
  · intro h
    -- From equality of charges we get equality of all toSpecies components
    intro i
    simpa [h]
