import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Mathlib

lemma SMCharges.charges_eq_toSpecies_eq
    {n : ℕ} (S T : (SMCharges n).Charges) :
    S = T ↔ (∀ j : Fin 5, SMCharges.toSpecies j S = SMCharges.toSpecies j T) :=
by
  constructor
  · intro h
    subst h
    intro j
    rfl
  · intro h
    -- `SMCharges.charges_eq_iff` states that two charge assignments are equal
    -- iff all their species components are equal.
    apply (SMCharges.charges_eq_iff _ _).2
    exact h
