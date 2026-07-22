import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations

lemma SMCharges.SMACCs.accCube_perm_invariant (f : PermGroup n) (S : (SMCharges n).Charges) :
  SMCharges.SMACCs.accCube (repCharges f S) = SMCharges.SMACCs.accCube S :=
by
  have h :
    ∀ j : Fin 5,
      ∑ i, ((fun a => a ^ 3) ∘ toSpecies j (repCharges f S)) i
        = ∑ i, ((fun a => a ^ 3) ∘ toSpecies j S) i :=
  by
    intro j
    simpa using (SM.toSpecies_sum_invariant 3 f S j)
  exact SMCharges.SMACCs.accCube_ext h
