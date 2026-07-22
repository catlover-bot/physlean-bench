import Physlib.Particles.StandardModel.AnomalyCancellation.Basic

lemma SM.toSpecies_sum_invariant
  (n : ℕ) (S T : (SMCharges n).Charges)
  (h : ∀ j : Fin 5, (∑ i, (SM.toSpecies j S) i) = ∑ i, (SM.toSpecies j T) i) :
  SMCharges.SMACCs.accSU3 S = SMCharges.SMACCs.accSU3 T :=
by
  apply SMCharges.SMACCs.accSU3_ext
  intro j
  simpa using h j
