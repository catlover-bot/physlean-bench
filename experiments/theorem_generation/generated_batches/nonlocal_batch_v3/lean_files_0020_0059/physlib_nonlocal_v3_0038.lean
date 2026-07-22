import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Physlib.Particles.StandardModel.AnomalyCancellation.Basic

lemma SM.accQuad_perm_iff
    {n} (f : PermGroup n) {S T : (SMCharges n).Charges}
    (h : ∀ j, ∑ i, ((fun a => a^2) ∘ toSpecies j S) i
              = ∑ i, ((fun a => a^2) ∘ toSpecies j T) i) :
    accQuad (repCharges f S) = accQuad (repCharges f T) :=
by
  have hST : accQuad S = accQuad T :=
    SMCharges.SMACCs.accQuad_ext h
  have hS : accQuad (repCharges f S) = accQuad S :=
    SM.accQuad_invariant f S
  have hT : accQuad (repCharges f T) = accQuad T :=
    SM.accQuad_invariant f T
  simpa [hS, hT, hST]
