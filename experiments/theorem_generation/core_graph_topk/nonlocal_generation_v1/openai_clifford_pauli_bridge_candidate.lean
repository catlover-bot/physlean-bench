import Physlib.Relativity.CliffordAlgebra
import Physlib.Relativity.PauliMatrices.Basic

open Complex Matrix

namespace Physlib.Relativity

/--
A block-diagonal matrix built from Pauli matrices `σ1`, `σ2`, `σ3`
gives a concrete 4×4 representation of the spatial gamma matrices `γ1`, `γ2`, `γ3`
up to unitary similarity, in the complex 4×4 matrices.

(Here we express the abstract Clifford generators `γi` in terms of Pauli blocks;
this is a schematic bridge lemma statement, intended to capture the shared pattern
between the Clifford and Pauli constructions.)
-/
def diracSpatialRep (i : Fin 3) : Matrix (Fin 4) (Fin 4) ℂ :=
match i with
| ⟨0, _⟩ => Matrix.blockDiagonal ![0, 0] ![0, 0] ⟦Pauli.σ1⟧ ⟦Pauli.σ1⟧
| ⟨1, _⟩ => Matrix.blockDiagonal ![0, 0] ![0, 0] ⟦Pauli.σ2⟧ ⟦Pauli.σ2⟧
| ⟨2, _⟩ => Matrix.blockDiagonal ![0, 0] ![0, 0] ⟦Pauli.σ3⟧ ⟦Pauli.σ3⟧

lemma gamma_spatial_anticonj_diracRep
  (i j : Fin 3) (h : i ≠ j) :
  diracSpatialRep i ⬝ diracSpatialRep j =
  - diracSpatialRep j ⬝ diracSpatialRep i :=
by
  fin_cases i <;> fin_cases j <;> try cases h rfl
  all_goals
    simp [diracSpatialRep, Matrix.blockDiagonal]

end Physlib.Relativity
