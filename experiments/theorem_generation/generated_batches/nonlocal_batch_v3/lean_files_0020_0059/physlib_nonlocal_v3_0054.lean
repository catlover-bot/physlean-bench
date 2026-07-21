import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Mathlib

lemma SMCharges.accGrav_repCharges_eq
    {n : ℕ} (f : PermGroup n) (S : (SMCharges n).Charges) :
    accGrav (repCharges f S) = accGrav S :=
by
  have hj : ∀ (j : Fin 5), ∑ i, (toSpecies j) (repCharges f S) i = ∑ i, (toSpecies j) S i := by
    intro j
    classical
    have h := SM.repCharges_toSpecies f S j
    -- h : toSpecies j (repCharges f S) = toSpecies j S ∘ f⁻¹ j
    simpa [h, Finset.comp_right_sum]
  exact SMCharges.SMACCs.accGrav_ext hj
