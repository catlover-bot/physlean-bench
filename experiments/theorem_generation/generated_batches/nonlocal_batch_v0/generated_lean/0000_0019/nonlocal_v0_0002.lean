import Physlib.Relativity.CliffordAlgebra
import Physlib.Relativity.PauliMatrices.Basic

lemma spaceTime.γ3_mul_γ0_iff_σ2_mul_σ1
  (hγ : spaceTime.γ3 * spaceTime.γ0 = -(spaceTime.γ0 * spaceTime.γ3))
  (hσ : PauliMatrix.σ2 * PauliMatrix.σ1 = -(PauliMatrix.σ1 * PauliMatrix.σ2)) :
  (spaceTime.γ3 * spaceTime.γ0 = -(spaceTime.γ0 * spaceTime.γ3)) ∧
    (PauliMatrix.σ2 * PauliMatrix.σ1 = -(PauliMatrix.σ1 * PauliMatrix.σ2)) :=
by
  exact ⟨hγ, hσ⟩
