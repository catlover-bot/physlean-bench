import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Physlib.Particles.StandardModel.AnomalyCancellation.Basic

lemma SM.accCube_perm_eq_of_species_eq
  {n} (f : PermGroup n) {S T : (SMCharges n).Charges}
  (h : ∀ j, ∑ i, ((fun a => a^3) ∘ toSpecies j (repCharges f S)) i
            = ∑ i, ((fun a => a^3) ∘ toSpecies j T) i) :
  accCube S = accCube T :=
by
  have h₁ : accCube (repCharges f S) = accCube S :=
    SM.accCube_invariant f S
  have h₂ : accCube (repCharges f S) = accCube T :=
    SMCharges.SMACCs.accCube_ext h
  exact h₁.symm.trans h₂
