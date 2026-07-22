import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations

lemma SMCharges.SMACCs.accSU3_perm_invariant
  (n : ℕ) (f : PermGroup n) (S : (SMCharges n).Charges)
  (hpow : ∀ (j : Fin 5), ∑ i, ((fun a => a ^ (1 : ℕ)) ∘ SM.toSpecies j (SM.repCharges f S)) i
    = ∑ i, ((fun a => a ^ (1 : ℕ)) ∘ SM.toSpecies j S) i) :
  SMCharges.SMACCs.accSU3 (SM.repCharges f S) = SMCharges.SMACCs.accSU3 S :=
by
  have h₁ : ∀ (j : Fin 5), ∑ i, (SM.toSpecies j (SM.repCharges f S)) i
      = ∑ i, (SM.toSpecies j S) i :=
  by
    intro j
    specialize hpow j
    simpa using hpow
  have h₂ : ∀ (j : Fin 5),
      ∑ i, (SM.toSpecies j (SM.repCharges f S)) i
        = ∑ i, (SM.toSpecies j S) i :=
    h₁
  have hacc :
      SMCharges.SMACCs.accSU3 (SM.repCharges f S)
        = SMCharges.SMACCs.accSU3 S :=
    SMCharges.SMACCs.accSU3_ext
      (S := SM.repCharges f S)
      (T := S)
      (by intro j; simpa using h₂ j)
  simpa using hacc
