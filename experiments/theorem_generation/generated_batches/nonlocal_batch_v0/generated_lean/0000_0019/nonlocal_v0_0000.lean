import Physlib.Relativity.CliffordAlgebra
import Physlib.Relativity.PauliMatrices.Basic

lemma spaceTime.γ1_mul_γ0_tensor_σ2_mul_σ1
  {R} [Semiring R]
  [Algebra ℂ R]
  [Algebra ℂ (CliffordAlgebra ℝ (QuadraticForm.equiv (spaceTime.metric)))]
  [Algebra ℂ (Matrix (Fin 2) (Fin 2) ℂ)]
  [SMulCommClass ℂ R R]
  [IsScalarTower ℂ R R]
  [IsScalarTower ℂ (CliffordAlgebra ℝ (QuadraticForm.equiv (spaceTime.metric)))
    ((CliffordAlgebra ℝ (QuadraticForm.equiv (spaceTime.metric))) ⊗[ℂ] Matrix (Fin 2) (Fin 2) ℂ)]
  [IsScalarTower ℂ (Matrix (Fin 2) (Fin 2) ℂ)
    ((CliffordAlgebra ℝ (QuadraticForm.equiv (spaceTime.metric))) ⊗[ℂ] Matrix (Fin 2) (Fin 2) ℂ)] :
  ((γ1 : CliffordAlgebra ℝ (QuadraticForm.equiv (spaceTime.metric))) ⊗ₜ[ℂ] (PauliMatrix.σ2)) *
      (γ0 ⊗ₜ[ℂ] PauliMatrix.σ1)
    =
  -((γ0 ⊗ₜ[ℂ] PauliMatrix.σ1) *
      (γ1 ⊗ₜ[ℂ] PauliMatrix.σ2)) :=
by
  simpa [mul_comm, mul_left_comm, mul_assoc, tensorProduct.mul_tmul]
