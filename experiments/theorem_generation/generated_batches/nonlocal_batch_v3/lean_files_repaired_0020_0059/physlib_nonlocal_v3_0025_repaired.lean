import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Mathlib.Data.Fintype.Card

lemma SM.toSpecies_sum_invariant
    {n : ℕ} (m : ℕ) (f : Equiv.Perm (Fin n)) (S : (SMCharges n).Charges)
    (j : Fin 5) :
    (∑ i, ((fun a => a ^ m) (SM.toSpecies j (SMCharges.repCharges f S) i)))
      = ∑ i, ((fun a => a ^ m) (SM.toSpecies j S i)) :=
by
  classical
  -- rewrite the LHS using `repCharges` as a permutation of the `Fin n` index
  have hperm :
      (∑ i, (fun a => a ^ m) (SM.toSpecies j (SMCharges.repCharges f S) i))
        = ∑ i, (fun a => a ^ m) (SM.toSpecies j S (f i)) :=
    by
      -- `repCharges` just permutes the generation index `i` by `f`
      simpa [SMCharges.repCharges, Function.comp]  -- uses the library lemma

  -- now use sum over a permutation of a finite type
  -- we rewrite the RHS sum by changing index `i` to `f i`
  have hperm_sum :
      (∑ i, (fun a => a ^ m) (SM.toSpecies j S (f i)))
        = ∑ i, (fun a => a ^ m) (SM.toSpecies j S i) :=
    by
      simpa using
        (Fintype.sum_bijective _ f.bijective
          (fun i => (fun a => a ^ m) (SM.toSpecies j S (f i)))
          (fun i => (fun a => a ^ m) (SM.toSpecies j S i)))

  simpa [hperm] using hperm_sum
