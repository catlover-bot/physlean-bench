import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations

lemma SM.repCharges_toSpecies_sum
    {n : ℕ} (f : PermGroup n) (S : (SMCharges n).Charges) (j : Fin 5) :
    ∑ i, (SM.toSpecies j (SM.repCharges f S)) i
      = ∑ i, (SM.toSpecies j S) i :=
by
  classical
  -- use the pointwise equality of species under `repCharges`
  have h := SM.repCharges_toSpecies f S j
  -- `h` states: `SM.toSpecies j (SM.repCharges f S) = (SM.toSpecies j S) ∘ f.invFun`
  -- sums over a finite type are invariant under permutation of the index
  simpa [h]
