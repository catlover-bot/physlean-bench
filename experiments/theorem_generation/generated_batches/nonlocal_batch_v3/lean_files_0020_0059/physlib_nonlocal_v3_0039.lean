import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations

lemma SM.accQuad_eq_of_repCharges
  (f : PermGroup n)
  {S T : (SMCharges n).Charges}
  (h : ∀ j, ∑ i, ((fun a => a^2) ∘ toSpecies j (repCharges f S)) i
        = ∑ i, ((fun a => a^2) ∘ toSpecies j T) i) :
  accQuad S = accQuad T :=
by
  have h₁ : accQuad (repCharges f S) = accQuad S :=
    (SM.accQuad_invariant f S).symm
  have h₂ : accQuad (repCharges f S) = accQuad T :=
    SMCharges.SMACCs.accQuad_ext h
  exact h₁.trans h₂
