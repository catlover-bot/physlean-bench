import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Mathlib

lemma SMCharges.SMACCs.accGrav_perm_invariant {n : ℕ} (f : PermGroup n) (S : (SMCharges n).Charges) :
    SMCharges.SMACCs.accGrav (repCharges f S) = SMCharges.SMACCs.accGrav S :=
by
  classical
  have hj : ∀ (j : Fin 5),
      ∑ i, SM.toSpecies j (repCharges f S) i
        = ∑ i, SM.toSpecies j S i :=
  by
    intro j
    have h := SM.toSpecies_sum_invariant (n := n) (m := 1) f S j
    simpa [Function.comp, one_pow] using h
  have := SMCharges.SMACCs.accGrav_ext (n := n) (S := repCharges f S) (T := S) hj
  simpa using this
