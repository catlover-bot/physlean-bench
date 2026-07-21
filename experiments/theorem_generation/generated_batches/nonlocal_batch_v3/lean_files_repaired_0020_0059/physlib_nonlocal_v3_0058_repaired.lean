import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Mathlib

lemma SM.toSpecies_sum_invariant
    (n : ℕ) (S T : (SMCharges n).Charges)
    (h : ∀ j : Fin 5, ∑ i, (SM.toSpecies j S) i = ∑ i, (SM.toSpecies j T) i) :
    SMCharges.SMACCs.accYY S = SMCharges.SMACCs.accYY T := by
  classical
  exact SMCharges.SMACCs.accYY_ext (S := S) (T := T) h
