import Physlib.Relativity.CliffordAlgebra
import Physlib.Relativity.PauliMatrices.Basic

lemma spaceTime.γ2_mul_γ0_iff_PauliMatrix.σ2_mul_σ1 :
  spaceTime.γ2 * spaceTime.γ0 = -(spaceTime.γ0 * spaceTime.γ2) ↔
  PauliMatrix.σ2 * PauliMatrix.σ1 = -(PauliMatrix.σ1 * PauliMatrix.σ2) :=
by
  constructor
  · intro h
    simpa using PauliMatrix.σ2_mul_σ1
  · intro h
    simpa using spaceTime.γ2_mul_γ0
