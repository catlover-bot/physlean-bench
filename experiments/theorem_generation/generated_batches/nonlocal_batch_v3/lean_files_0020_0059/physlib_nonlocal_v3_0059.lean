import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Mathlib.Data.Fin.Basic

lemma SMCharges.SMACCs.accSU3_perm_invariant
  {n : Nat} (f : PermGroup n) (S : (SMCharges n).Charges)
  (hf : ∀ (j : Fin 5), ∑ i, (toSpecies j) (repCharges f S) i = ∑ i, (toSpecies j) S i) :
  accSU3 (repCharges f S) = accSU3 S :=
by
  have h_ext : accSU3 (repCharges f S) = accSU3 S :=
    SMCharges.SMACCs.accSU3_ext
      (S := repCharges f S)
      (T := S)
      (by
        intro j
        simpa using hf j)
  simpa using h_ext
