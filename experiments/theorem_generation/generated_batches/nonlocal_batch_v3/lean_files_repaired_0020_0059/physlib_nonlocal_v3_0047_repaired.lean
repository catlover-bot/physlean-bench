import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Physlib.Particles.StandardModel.AnomalyCancellation.Basic

lemma SMCharges.SMACCs.accCube_ext
  {n} (f : PermGroup n) {S T : (SMCharges n).Charges}
  (h : ∀ j, ∑ i, ((fun a => a^3) ∘ SM.toSpecies j ((SMCharges.repCharges f) S)) i
            = ∑ i, ((fun a => a^3) ∘ SM.toSpecies j T) i) :
  SM.accCube ((SMCharges.repCharges f) S) = SM.accCube T :=
SMCharges.SMACCs.accCube_ext f h
