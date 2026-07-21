import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations

lemma SM.accCube_invariant_of_species_eq
    {n} (f : PermGroup n) {S T : (SMCharges n).Charges}
    (h : ∀ j, ∑ i, ((fun a => a^3) ∘ SMCharges.toSpecies j (SM.repCharges f S)) i
            = ∑ i, ((fun a => a^3) ∘ SMCharges.toSpecies j T) i) :
    accCube S = accCube T :=
by
  have h₁ : accCube (SM.repCharges f S) = accCube S :=
    SM.accCube_invariant f S
  have h₂ : accCube (SM.repCharges f S) = accCube T :=
    SMCharges.SMACCs.accCube_ext h
  exact h₁ ▸ h₂
