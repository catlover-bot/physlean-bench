import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations

lemma SMCharges.SMACCs.accSU2_perm_invariant
  (n : ℕ) (f : PermGroup n) (S : (SMCharges n).Charges)
  (hpow : ∀ (j : Fin 5), ∀ i, ((fun a => a ^ (1 : ℕ)) ∘ SM.toSpecies j (SM.repCharges f S)) i
    = ((fun a => a ^ (1 : ℕ)) ∘ SM.toSpecies j S) i) :
  SMCharges.SMACCs.accSU2 (SM.repCharges f S) = SMCharges.SMACCs.accSU2 S :=
by
  classical
  have hj : ∀ (j : Fin 5), ∑ i, (SM.toSpecies j (SM.repCharges f S)) i
      = ∑ i, (SM.toSpecies j S) i :=
  by
    intro j
    have h₁ := SM.toSpecies_sum_invariant 1 f S j
    simpa using h₁
  refine SMCharges.SMACCs.accSU2_ext ?h
  intro j
  have := hj j
  simpa using this
