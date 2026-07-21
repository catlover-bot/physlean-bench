import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Physlib.Particles.StandardModel.AnomalyCancellation.Basic

lemma SMCharges.accGrav_repCharges_invariant
  (n m : ℕ) (f : PermGroup n) (S : (SMCharges n).Charges) :
  accGrav (repCharges f S) = accGrav S :=
by
  refine SMCharges.SMACCs.accGrav_ext ?hj
  intro j
  have h :=
    SM.toSpecies_sum_invariant (m := 1) (f := f) (S := S) (j := j)
  simpa using h
