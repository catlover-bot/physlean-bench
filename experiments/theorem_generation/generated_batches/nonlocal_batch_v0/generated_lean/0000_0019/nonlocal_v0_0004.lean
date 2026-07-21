import Physlib.Relativity.CliffordAlgebra
import Physlib.Relativity.PauliMatrices.Basic

lemma spaceTime.γ3_mul_γ1_tensor_σ2_mul_σ1
  (A B C D : PauliMatrix) :
  (spaceTime.γ3 * spaceTime.γ1) ⊗ₖ (A * B) * ((spaceTime.γ1 * spaceTime.γ3) ⊗ₖ (C * D))
    = -((spaceTime.γ1 * spaceTime.γ3) ⊗ₖ (A * B) * ((spaceTime.γ3 * spaceTime.γ1) ⊗ₖ (C * D))) :=
by
  simpa [spaceTime.γ3_mul_γ1, PauliMatrix.σ2_mul_σ1, mul_comm, mul_left_comm, mul_assoc, neg_mul, mul_neg,
    Algebra.smul_mul_assoc, Algebra.mul_smul_comm, TensorProduct.mul_tmul]
