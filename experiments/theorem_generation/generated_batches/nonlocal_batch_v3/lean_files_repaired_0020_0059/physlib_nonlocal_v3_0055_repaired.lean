import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations

lemma SM.toSpecies_sum_invariant_one
    {n : ℕ} (f : SMCharges.PermGroup n) (S : (SMCharges n).Charges)
    (j : Fin 5) :
    ∑ i, (SM.toSpecies j (SMCharges.repCharges f S) i)
      = ∑ i, (SM.toSpecies j S i) :=
by
  simpa using (SM.toSpecies_sum_invariant 1 f S j)
