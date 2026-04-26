## UnitChoices.dimScale_apply

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  rcases d with ⟨⟨⟩⟩ <;>
  rcases u1 with ⟨⟨⟩⟩ <;>
  rcases u2 with ⟨⟨⟩⟩ <;>
  simp [dimScale, Nat.pow_succ, Nat.pow_zero, Nat.mul_zero, Nat.zero_mul, Nat.mul_one, Nat.one_mul]
  <;>
  norm_num
  <;>
  rfl
```

## UnitChoices.dimScale_self

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  cases u <;> cases d <;> simp [dimScale]
  <;> norm_num
  <;> rfl
```

## UnitChoices.dimScale_one

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  rcases u1 with (_ | _ | _) <;> rcases u2 with (_ | _ | _) <;> simp [dimScale]
  <;> norm_num
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
```

## UnitChoices.dimScale_ne_zero

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  cases u1 <;> cases u2 <;> cases d <;> simp [dimScale, ne_eq, Nat.cast_eq_zero, Nat.cast_ne_zero]
  <;> norm_num
  <;> aesop
```

## UnitChoices.SI_length

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  rfl
  <;> simp [SI, LengthUnit]
  <;> rfl
  <;> simp [SI, LengthUnit]
  <;> rfl
```

## UnitChoices.SI_time

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  rfl
```

## UnitChoices.SI_mass

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  rfl
```

## UnitChoices.SI_charge

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  rfl
```

## UnitChoices.SI_temperature

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  rfl
  <;> simp [SI.temperature]
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
  <;> rfl
```

## UnitChoices.Dimensionful.ext

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  cases f1
  cases f2
  congr
  <;> simp_all
  <;> aesop
```

## UnitChoices.Dimensionful.smul_apply

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  rfl
```

## UnitChoices.CarriesDimension.toDimensionful_apply_apply

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  rfl
```

## minkowskiMatrix.inl_0_inl_0

File: `Physlib/Relativity/MinkowskiMatrix.lean`

### Generated proof

```lean
by
  rfl
```

## minkowskiMatrix.mulVec_inl_0

File: `Physlib/Relativity/MinkowskiMatrix.lean`

### Generated proof

```lean
by
  simp [mulVec, dotProduct, Fin.sum_univ_succ, Matrix.of_apply, Fin.val_zero]
  <;> norm_num
  <;> rfl
```

## KroneckerDelta.sum_sum_smul_eq_zero

File: `Physlib/Mathematics/KroneckerDelta.lean`

### Generated proof

```lean
by
  simp [Finset.sum_eq_zero, hf]
  <;> aesop
```

## Physlib.PiTensorProduct.induction_tmul

File: `Physlib/Mathematics/PiTensorProduct.lean`

### Generated proof

```lean
by
  apply eq_of_heq
  aesop
```

## Physlib.PiTensorProduct.induction_assoc

File: `Physlib/Mathematics/PiTensorProduct.lean`

### Generated proof

```lean
by
  apply eq_of_heq
  <;> aesop
```

## Physlib.PiTensorProduct.pureInl_update_left

File: `Physlib/Mathematics/PiTensorProduct.lean`

### Generated proof

```lean
by
  funext i
  by_cases h : i = x <;> simp_all [Function.update, pureInl, Sum.elim_inr, Sum.elim_inl]
  <;> aesop
```

## Physlib.PiTensorProduct.pureInr_update_right

File: `Physlib/Mathematics/PiTensorProduct.lean`

### Generated proof

```lean
by
  funext y
  by_cases h : y = x <;> simp_all [Function.update, pureInr, Sum.inr.injEq]
  <;> aesop
```

## Physlib.PiTensorProduct.elimPureTensor_update_right

File: `Physlib/Mathematics/PiTensorProduct.lean`

### Generated proof

```lean
by
  funext x
  by_cases h : x = Sum.inr y
  <;> simp_all [elimPureTensor, Function.update, Function.comp_apply, Sum.inr.injEq]
  <;> aesop
```

