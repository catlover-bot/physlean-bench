import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Mathlib

lemma SM.toSpecies_sum_invariant
    {n m : ℕ} (f : Fin n ≃ Fin n) (S : (SMCharges n).Charges) (j : Fin m) :
    (∑ i, SM.toSpecies j (repCharges f S) i)
      = ∑ i, SM.toSpecies j S i :=
by
  classical
  -- `repCharges` just permutes the family of charges, and `toSpecies` is
  -- defined by summing over the internal representation; permutation
  -- invariance of the finite sum gives the result.
  simpa [SM.toSpecies, repCharges, Finset.univ_eq_attach]
