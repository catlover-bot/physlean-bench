import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations

lemma SM.toSpecies_sum_invariant
  (n : ℕ) (p : ℕ) (f : SMCharges.PermGroup n) (S : (SMCharges n).Charges)
  (j : Fin 5) :
  (∑ i, (SM.toSpecies j (SM.repCharges f S)) i ^ p) =
    ∑ i, (SM.toSpecies j S) i ^ p :=
by
  classical
  simpa using SMCharges.toSpecies_sum_invariant (n := n) (p := p) (f := f) (S := S) (j := j)
