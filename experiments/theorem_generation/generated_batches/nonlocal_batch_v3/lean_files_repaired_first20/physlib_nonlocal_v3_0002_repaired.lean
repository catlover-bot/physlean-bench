import Physlib.QuantumMechanics.PlanckConstant
import Physlib.Electromagnetism.Dynamics.Basic
import Mathlib.Algebra.GroupWithZero.Power

lemma Electromagnetism.FreeSpace.ε₀_nonneg :
  0 ≤ Electromagnetism.FreeSpace.ε₀ :=
by
  simpa using (Electromagnetism.FreeSpace.ε₀_pos.le)
