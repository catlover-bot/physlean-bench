import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations
import Mathlib.Data.Fin.Basic

lemma SM.repCharges_toSpecies
  {n : ℕ} (f : PermGroup n) (S : (SMCharges n).Charges) (j : Fin 5) :
  toSpecies j (repCharges f S) = fun i => toSpecies j S (f⁻¹ i) :=
by
  -- This is exactly the defining property of `repCharges` acting on each species.
  funext i
  simpa using SMCharges.repCharges_toSpecies (f := f) (S := S) (j := j) (i := i)
