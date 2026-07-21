import Physlib.Relativity.CliffordAlgebra
import Physlib.Relativity.PauliMatrices.Basic

lemma spaceTime.γ3_mul_γ2_tensor_PauliMatrix.σ2_mul_σ1
  [Ring R]
  [Algebra R spaceTime]
  [Algebra R PauliMatrix]
  [Semiring S]
  [Algebra R S]
  :
  (algebraMap R S 1) • (spaceTime.γ3 * spaceTime.γ2) ⊗ₜ[R] (PauliMatrix.σ2 * PauliMatrix.σ1)
  =
  -(algebraMap R S 1) • (spaceTime.γ2 * spaceTime.γ3) ⊗ₜ[R] (PauliMatrix.σ1 * PauliMatrix.σ2) :=
by
  simpa [spaceTime.γ3_mul_γ2, PauliMatrix.σ2_mul_σ1, mul_comm, mul_left_comm, mul_assoc, smul_mul_assoc, mul_smul]
