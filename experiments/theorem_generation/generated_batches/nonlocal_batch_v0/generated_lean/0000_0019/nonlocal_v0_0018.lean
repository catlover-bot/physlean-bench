import Physlib.Relativity.Tensors.Contraction.Basic
import Physlib.Relativity.Tensors.Contraction.Pure

open TensorSpecies

lemma Tensor.contrT_comm_of_pure_dropPairEmb_comm
  {S : TensorSpecies} {n : ℕ} {c : Fin (n + 1 + 1 + 1 + 1) → S.C}
  (i1 j1 : Fin (n + 1 + 1 + 1 + 1)) (i2 j2 : Fin (n + 1 + 1))
  (hij1 : i1 ≠ j1 ∧ S.τ (c i1) = c j1)
  (hij2 : i2 ≠ j2 ∧ S.τ (c (TensorSpecies.Tensor.dropPairEmb i1 j1 i2)) =
    c (TensorSpecies.Tensor.dropPairEmb i1 j1 j2))
  (t : Tensor S c)
  (hpure :
    let i2' := (TensorSpecies.Tensor.dropPairEmb i1 j1 i2)
    let j2' := (TensorSpecies.Tensor.dropPairEmb i1 j1 j2)
    have hi2j2' : i2' ≠ j2' := by simp [i2', j2', hij2]
    let i1' := (TensorSpecies.Tensor.dropPairEmbPre i2' j2' hi2j2' i1 (by simp [i2', j2']))
    let j1' := (TensorSpecies.Tensor.dropPairEmbPre i2' j2' hi2j2' j1 (by simp [i2', j2']))
    TensorSpecies.Tensor.dropPairEmb i1 j1 ∘ TensorSpecies.Tensor.dropPairEmb i2 j2 =
      TensorSpecies.Tensor.dropPairEmb i2' j2' ∘ TensorSpecies.Tensor.dropPairEmb i1' j1') :
  let i2' := (TensorSpecies.Tensor.dropPairEmb i1 j1 i2)
  let j2' := (TensorSpecies.Tensor.dropPairEmb i1 j1 j2)
  have hi2j2' : i2' ≠ j2' := by simp [i2', j2', hij2]
  let i1' := (TensorSpecies.Tensor.dropPairEmbPre i2' j2' hi2j2' i1 (by simp [i2', j2']))
  let j1' := (TensorSpecies.Tensor.dropPairEmbPre i2' j2' hi2j2' j1 (by simp [i2', j2']))
  TensorSpecies.Tensor.contrT n i2 j2 hij2
      (TensorSpecies.Tensor.contrT (n + 1 + 1) i1 j1 hij1 t) =
    TensorSpecies.Tensor.permT id
      (TensorSpecies.Tensor.permCond_dropPairEmb_comm i1 j1 i2 j2 hij1.left hij2.left)
      (TensorSpecies.Tensor.contrT n i1' j1'
        (by simp [i1', j1', i2', j2', hij1])
        (TensorSpecies.Tensor.contrT (n + 1 + 1) i2' j2'
          (by simp [i2', j2', hij2]) t)) :=
by
  simpa using
    (TensorSpecies.Tensor.contrT_comm (S := S) (c := c)
      (i1 := i1) (j1 := j1) (i2 := i2) (j2 := j2) hij1 hij2 t)
