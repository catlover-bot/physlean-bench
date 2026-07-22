import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Mathlib

lemma SM.toSpecies_sum_invariant_iff
    {n m : ℕ} (f : PermGroup n) (S T : (SMCharges n).Charges) (j : Fin 5) :
    (∑ i, ((fun a => a ^ m) ∘ toSpecies j (repCharges f S)) i
      = ∑ i, ((fun a => a ^ m) ∘ toSpecies j (repCharges f T)) i) ↔
    (∑ i, ((fun a => a ^ m) ∘ toSpecies j S) i
      = ∑ i, ((fun a => a ^ m) ∘ toSpecies j T) i) :=
by
  constructor
  · intro h
    have hS := SM.toSpecies_sum_invariant m f S j
    have hT := SM.toSpecies_sum_invariant m f T j
    have := congrArg id h
    simpa [hS, hT]
  · intro h
    have hS := SM.toSpecies_sum_invariant m f S j
    have hT := SM.toSpecies_sum_invariant m f T j
    have := congrArg id h
    simpa [hS, hT]
