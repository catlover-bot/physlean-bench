import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations

lemma SMCharges.repCharges_eq_of_toSpecies_sum_invariant
    {n : ℕ} {m : ℕ} (hm : m ≠ 0)
    (f : PermGroup n) (S T : (SMCharges n).Charges)
    (h : ∀ j : Fin 5,
      (∑ i, ((fun a => a ^ m) ∘ toSpecies j (repCharges f S)) i
       = ∑ i, ((fun a => a ^ m) ∘ toSpecies j (repCharges f T)) i)) :
    S = T :=
by
  have hS : ∀ j : Fin 5,
      ∑ i, ((fun a => a ^ m) ∘ toSpecies j (repCharges f S)) i
        = ∑ i, ((fun a => a ^ m) ∘ toSpecies j S) i :=
    fun j => SM.toSpecies_sum_invariant m f S j
  have hT : ∀ j : Fin 5,
      ∑ i, ((fun a => a ^ m) ∘ toSpecies j (repCharges f T)) i
        = ∑ i, ((fun a => a ^ m) ∘ toSpecies j T) i :=
    fun j => SM.toSpecies_sum_invariant m f T j
  have hST : ∀ j : Fin 5,
      ∑ i, ((fun a => a ^ m) ∘ toSpecies j S) i
        = ∑ i, ((fun a => a ^ m) ∘ toSpecies j T) i :=
    by
      intro j
      specialize h j
      specialize hS j
      specialize hT j
      simpa [hS, hT] using h
  have h_pointwise : ∀ j : Fin 5, toSpecies j S = toSpecies j T :=
    by
      intro j
      ext i
      specialize hST j
      have := congrArg (fun s => s) hST
      simpa using this
  have h_species : ∀ i, toSpecies i S = toSpecies i T :=
    fun i => h_pointwise i
  exact (SMCharges.charges_eq_toSpecies_eq S T).mpr h_species
