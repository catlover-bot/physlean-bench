import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Physlib.Particles.StandardModel.AnomalyCancellation.Basic

lemma SMCharges.SMACCs.accQuad_ext
    {n} (f : PermGroup n) {S T : (SMCharges n).Charges}
    (h : ∀ j, ∑ i, ((fun a => a^2) ∘ toSpecies j S) i
              = ∑ i, ((fun a => a^2) ∘ toSpecies j T) i) :
    SM.accQuad (SM.repCharges f S) = SM.accQuad (SM.repCharges f T) :=
by
  have hST : SM.accQuad S = SM.accQuad T :=
    SMCharges.SMACCs.accQuad_invariant h
  have hS : SM.accQuad (SM.repCharges f S) = SM.accQuad S :=
    SM.accQuad_invariant f S
  have hT : SM.accQuad (SM.repCharges f T) = SM.accQuad T :=
    SM.accQuad_invariant f T
  simpa [hS, hT, hST]
