import Physlib.Relativity.CliffordAlgebra
import Physlib.Relativity.PauliMatrices.Basic

lemma spaceTime.γ2_mul_γ1_iff_PauliMatrix.σ2_mul_σ1 :
  spaceTime.γ2 * spaceTime.γ1 = -(spaceTime.γ1 * spaceTime.γ2) ↔
  PauliMatrix.σ2 * PauliMatrix.σ1 = -(PauliMatrix.σ1 * PauliMatrix.σ2) :=
by
  constructor
  · intro h
    simpa [PauliMatrix.σ2_mul_σ1]
  · intro h
    simpa [spaceTime.γ2_mul_γ1]
