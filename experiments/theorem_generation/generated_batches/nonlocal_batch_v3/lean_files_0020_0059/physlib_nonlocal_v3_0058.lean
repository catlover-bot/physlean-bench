import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Mathlib

lemma SMCharges.SMACCs.accYY_perm_invariant
    (n : ℕ) (f : PermGroup n) (S : (SMCharges n).Charges)
    (h1 : ∀ (j : Fin 5), ∑ i, (toSpecies j (repCharges f S)) i = ∑ i, (toSpecies j S) i)
    (h2 : ∀ (j : Fin 5), ∑ i, ((fun a => a ^ 1) ∘ toSpecies j (repCharges f S)) i
        = ∑ i, ((fun a => a ^ 1) ∘ toSpecies j S) i) :
    SMCharges.SMACCs.accYY (repCharges f S) = SMCharges.SMACCs.accYY S := by
  classical
  have h_invariant : ∀ (j : Fin 5),
      ∑ i, (toSpecies j (repCharges f S)) i = ∑ i, (toSpecies j S) i := by
    intro j
    simpa using h1 j
  have h_acc := SMCharges.SMACCs.accYY_ext (S := repCharges f S) (T := S) h_invariant
  simpa using h_acc
