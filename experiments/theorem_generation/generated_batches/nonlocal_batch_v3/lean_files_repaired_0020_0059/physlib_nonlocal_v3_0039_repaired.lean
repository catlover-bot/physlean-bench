import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations

lemma SM.accQuad_invariant
  (n : ℕ) (f : PermGroup n) (S : (SMCharges n).Charges) :
  SMCharges.SMACCs.accQuad (SMCharges.repCharges f S)
    = SMCharges.SMACCs.accQuad S :=
by
  -- This is exactly `SMCharges.SMACCs.accQuad_invariant`
  simpa using (SMCharges.SMACCs.accQuad_invariant f S)
