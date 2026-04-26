## UnitChoices.dimScale_transitive

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  cases u1 <;> cases u2 <;> cases u3 <;> simp [dimScale, mul_assoc, mul_comm, mul_left_comm]
  <;> rfl
```

### Error tail

```text
(time✝² / time✝¹) ^ ↑d.time *
        ((time✝¹ / time✝) ^ ↑d.time *
          ((mass✝² / mass✝¹) ^ ↑d.mass *
            ((mass✝¹ / mass✝) ^ ↑d.mass *
              ((charge✝² / charge✝¹) ^ ↑d.charge *
                ((charge✝¹ / charge✝) ^ ↑d.charge *
                  ((temperature✝² / temperature✝¹) ^ ↑d.temperature *
                    (temperature✝¹ / temperature✝) ^ ↑d.temperature))))))))
is not definitionally equal to the right-hand side
  (length✝² / length✝) ^ ↑d.length *
    ((time✝² / time✝) ^ ↑d.time *
      ((mass✝² / mass✝) ^ ↑d.mass *
        ((charge✝² / charge✝) ^ ↑d.charge * (temperature✝² / temperature✝) ^ ↑d.temperature)))

case mk.mk.mk
d : Dimension
length✝² : LengthUnit
time✝² : TimeUnit
mass✝² : MassUnit
charge✝² : ChargeUnit
temperature✝² : TemperatureUnit
length✝¹ : LengthUnit
time✝¹ : TimeUnit
mass✝¹ : MassUnit
charge✝¹ : ChargeUnit
temperature✝¹ : TemperatureUnit
length✝ : LengthUnit
time✝ : TimeUnit
mass✝ : MassUnit
charge✝ : ChargeUnit
temperature✝ : TemperatureUnit
⊢ (length✝² / length✝¹) ^ ↑d.length *
      ((length✝¹ / length✝) ^ ↑d.length *
        ((time✝² / time✝¹) ^ ↑d.time *
          ((time✝¹ / time✝) ^ ↑d.time *
            ((mass✝² / mass✝¹) ^ ↑d.mass *
              ((mass✝¹ / mass✝) ^ ↑d.mass *
                ((charge✝² / charge✝¹) ^ ↑d.charge *
                  ((charge✝¹ / charge✝) ^ ↑d.charge *
                    ((temperature✝² / temperature✝¹) ^ ↑d.temperature *
                      (temperature✝¹ / temperature✝) ^ ↑d.temperature)))))))) =
    (length✝² / length✝) ^ ↑d.length *
      ((time✝² / time✝) ^ ↑d.time *
        ((mass✝² / mass✝) ^ ↑d.mass *
          ((charge✝² / charge✝) ^ ↑d.charge * (temperature✝² / temperature✝) ^ ↑d.temperature)))
Physlib/Units/Basic.lean:138:68: warning: This simp argument is unused:
  mul_comm

Hint: Omit it from the simp argument list.
  simp [dimScale, mul_assoc, m̵u̵l̵_̵c̵o̵m̵m̵,̵ ̵mul_left_comm]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`

```

## UnitChoices.dimScale_mul_symm

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  cases u1 <;> cases u2 <;> cases d <;> simp [dimScale, mul_comm]
  <;> norm_num
  <;> rfl
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Units/Basic.lean:157:6: error: Tactic `rfl` failed: The left-hand side
  (length✝² / length✝¹) ^ ↑length✝ * (time✝² / time✝¹) ^ ↑time✝ * (mass✝² / mass✝¹) ^ ↑mass✝ *
        (charge✝² / charge✝¹) ^ ↑charge✝ *
      (temperature✝² / temperature✝¹) ^ ↑temperature✝ *
    ((length✝¹ / length✝²) ^ ↑length✝ * (time✝¹ / time✝²) ^ ↑time✝ * (mass✝¹ / mass✝²) ^ ↑mass✝ *
        (charge✝¹ / charge✝²) ^ ↑charge✝ *
      (temperature✝¹ / temperature✝²) ^ ↑temperature✝)
is not definitionally equal to the right-hand side
  1

case mk.mk.mk
length✝² : LengthUnit
time✝² : TimeUnit
mass✝² : MassUnit
charge✝² : ChargeUnit
temperature✝² : TemperatureUnit
length✝¹ : LengthUnit
time✝¹ : TimeUnit
mass✝¹ : MassUnit
charge✝¹ : ChargeUnit
temperature✝¹ : TemperatureUnit
length✝ time✝ mass✝ charge✝ temperature✝ : ℚ
⊢ (length✝² / length✝¹) ^ ↑length✝ * (time✝² / time✝¹) ^ ↑time✝ * (mass✝² / mass✝¹) ^ ↑mass✝ *
          (charge✝² / charge✝¹) ^ ↑charge✝ *
        (temperature✝² / temperature✝¹) ^ ↑temperature✝ *
      ((length✝¹ / length✝²) ^ ↑length✝ * (time✝¹ / time✝²) ^ ↑time✝ * (mass✝¹ / mass✝²) ^ ↑mass✝ *
          (charge✝¹ / charge✝²) ^ ↑charge✝ *
        (temperature✝¹ / temperature✝²) ^ ↑temperature✝) =
    1
Physlib/Units/Basic.lean:155:56: warning: This simp argument is unused:
  mul_comm

Hint: Omit it from the simp argument list.
  simp [dimScale,̵ ̵m̵u̵l̵_̵c̵o̵m̵m̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`

```

## UnitChoices.dimScale_coe_mul_symm

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  cases u1 <;> cases u2 <;> cases d <;> simp [dimScale, toReal, Nat.cast_mul]
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;> ring
  <;> norm_num
  <;>
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Units/Basic.lean:218:5: error: unexpected token '@['; expected '[' or tactic

```

## UnitChoices.dimScale_symm

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  cases u1 <;> cases u2 <;> simp_all [dimScale, dimUnit, dimAux, dimAux, dimAux, dimAux, dimAux, dimAux, dimAux, dimAux]
  <;> rfl
```

### Error tail

```text
an:172:48: error(lean.unknownIdentifier): Unknown identifier `dimUnit`
Physlib/Units/Basic.lean:172:57: error(lean.unknownIdentifier): Unknown identifier `dimAux`
Physlib/Units/Basic.lean:172:65: error(lean.unknownIdentifier): Unknown identifier `dimAux`
Physlib/Units/Basic.lean:172:73: error(lean.unknownIdentifier): Unknown identifier `dimAux`
Physlib/Units/Basic.lean:172:81: error(lean.unknownIdentifier): Unknown identifier `dimAux`
Physlib/Units/Basic.lean:172:89: error(lean.unknownIdentifier): Unknown identifier `dimAux`
Physlib/Units/Basic.lean:172:97: error(lean.unknownIdentifier): Unknown identifier `dimAux`
Physlib/Units/Basic.lean:172:105: error(lean.unknownIdentifier): Unknown identifier `dimAux`
Physlib/Units/Basic.lean:172:113: error(lean.unknownIdentifier): Unknown identifier `dimAux`
Physlib/Units/Basic.lean:173:6: error: Tactic `rfl` failed: The left-hand side
  (length✝¹ / length✝) ^ ↑d.length * (time✝¹ / time✝) ^ ↑d.time * (mass✝¹ / mass✝) ^ ↑d.mass *
      (charge✝¹ / charge✝) ^ ↑d.charge *
    (temperature✝¹ / temperature✝) ^ ↑d.temperature
is not definitionally equal to the right-hand side
  ((temperature✝ / temperature✝¹) ^ ↑d.temperature)⁻¹ *
    (((charge✝ / charge✝¹) ^ ↑d.charge)⁻¹ *
      (((mass✝ / mass✝¹) ^ ↑d.mass)⁻¹ * (((time✝ / time✝¹) ^ ↑d.time)⁻¹ * ((length✝ / length✝¹) ^ ↑d.length)⁻¹)))

case mk.mk
d : Dimension
length✝¹ : LengthUnit
time✝¹ : TimeUnit
mass✝¹ : MassUnit
charge✝¹ : ChargeUnit
temperature✝¹ : TemperatureUnit
length✝ : LengthUnit
time✝ : TimeUnit
mass✝ : MassUnit
charge✝ : ChargeUnit
temperature✝ : TemperatureUnit
⊢ (length✝¹ / length✝) ^ ↑d.length * (time✝¹ / time✝) ^ ↑d.time * (mass✝¹ / mass✝) ^ ↑d.mass *
        (charge✝¹ / charge✝) ^ ↑d.charge *
      (temperature✝¹ / temperature✝) ^ ↑d.temperature =
    ((temperature✝ / temperature✝¹) ^ ↑d.temperature)⁻¹ *
      (((charge✝ / charge✝¹) ^ ↑d.charge)⁻¹ *
        (((mass✝ / mass✝¹) ^ ↑d.mass)⁻¹ * (((time✝ / time✝¹) ^ ↑d.time)⁻¹ * ((length✝ / length✝¹) ^ ↑d.length)⁻¹)))

```

## UnitChoices.dimScale_of_inv_eq_swap

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  rcases u1 with (_ | _ | _) <;> rcases u2 with (_ | _ | _) <;> rfl
```

### Error tail

```text
mk (⇑CauSeq.equiv) a✝¹ }, property := property✝¹ }, time := time✝¹,
          mass := mass✝¹, charge := charge✝¹, temperature := temperature✝¹ }.dimScale
      { length := { val := { cauchy := Quot.mk (⇑CauSeq.equiv) a✝ }, property := property✝ }, time := time✝,
        mass := mass✝, charge := charge✝, temperature := temperature✝ })
    d⁻¹
is not definitionally equal to the right-hand side
  ({ length := { val := { cauchy := Quot.mk (⇑CauSeq.equiv) a✝ }, property := property✝ }, time := time✝, mass := mass✝,
          charge := charge✝, temperature := temperature✝ }.dimScale
      { length := { val := { cauchy := Quot.mk (⇑CauSeq.equiv) a✝¹ }, property := property✝¹ }, time := time✝¹,
        mass := mass✝¹, charge := charge✝¹, temperature := temperature✝¹ })
    d

case mk.mk
d : Dimension
time✝¹ : TimeUnit
mass✝¹ : MassUnit
charge✝¹ : ChargeUnit
temperature✝¹ : TemperatureUnit
cauchy✝¹ : CauSeq.Completion.Cauchy abs
a✝¹ : CauSeq ℚ abs
property✝¹ : 0 < { cauchy := Quot.mk (⇑CauSeq.equiv) a✝¹ }
time✝ : TimeUnit
mass✝ : MassUnit
charge✝ : ChargeUnit
temperature✝ : TemperatureUnit
cauchy✝ : CauSeq.Completion.Cauchy abs
a✝ : CauSeq ℚ abs
property✝ : 0 < { cauchy := Quot.mk (⇑CauSeq.equiv) a✝ }
⊢ ({ length := { val := { cauchy := Quot.mk (⇑CauSeq.equiv) a✝¹ }, property := property✝¹ }, time := time✝¹,
            mass := mass✝¹, charge := charge✝¹, temperature := temperature✝¹ }.dimScale
        { length := { val := { cauchy := Quot.mk (⇑CauSeq.equiv) a✝ }, property := property✝ }, time := time✝,
          mass := mass✝, charge := charge✝, temperature := temperature✝ })
      d⁻¹ =
    ({ length := { val := { cauchy := Quot.mk (⇑CauSeq.equiv) a✝ }, property := property✝ }, time := time✝,
            mass := mass✝, charge := charge✝, temperature := temperature✝ }.dimScale
        { length := { val := { cauchy := Quot.mk (⇑CauSeq.equiv) a✝¹ }, property := property✝¹ }, time := time✝¹,
          mass := mass✝¹, charge := charge✝¹, temperature := temperature✝¹ })
      d

```

## UnitChoices.smul_dimScale_injective

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  constructor
  · intro h
    simp_all [mul_dimScale_injective]
    <;> aesop
  · intro h
    simp_all [mul_dimScale_injective]
    <;> aesop
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Units/Basic.lean:193:14: error(lean.unknownIdentifier): Unknown identifier `mul_dimScale_injective`
Physlib/Units/Basic.lean:193:4: error: simp_all made no progress
Physlib/Units/Basic.lean:196:14: error(lean.unknownIdentifier): Unknown identifier `mul_dimScale_injective`

```

## UnitChoices.dimScale_pos

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  cases u1 <;> cases u2 <;> cases d <;> simp [dimScale, pow_pos, Nat.zero_lt_one]
  <;> norm_num
  <;> aesop
```

### Error tail

```text
e_1 : TimeUnit
mass_1 : MassUnit
charge_1 : ChargeUnit
temperature_1 : TemperatureUnit
length_2 time_2 mass_2 charge_2 temperature_2 : ℚ
⊢ 0 < (length / length_1) ^ ↑length_2

case left.left.left.right
length : LengthUnit
time : TimeUnit
mass : MassUnit
charge : ChargeUnit
temperature : TemperatureUnit
length_1 : LengthUnit
time_1 : TimeUnit
mass_1 : MassUnit
charge_1 : ChargeUnit
temperature_1 : TemperatureUnit
length_2 time_2 mass_2 charge_2 temperature_2 : ℚ
⊢ 0 < (time / time_1) ^ ↑time_2

case left.left.right
length : LengthUnit
time : TimeUnit
mass : MassUnit
charge : ChargeUnit
temperature : TemperatureUnit
length_1 : LengthUnit
time_1 : TimeUnit
mass_1 : MassUnit
charge_1 : ChargeUnit
temperature_1 : TemperatureUnit
length_2 time_2 mass_2 charge_2 temperature_2 : ℚ
⊢ 0 < (mass / mass_1) ^ ↑mass_2

case left.right
length : LengthUnit
time : TimeUnit
mass : MassUnit
charge : ChargeUnit
temperature : TemperatureUnit
length_1 : LengthUnit
time_1 : TimeUnit
mass_1 : MassUnit
charge_1 : ChargeUnit
temperature_1 : TemperatureUnit
length_2 time_2 mass_2 charge_2 temperature_2 : ℚ
⊢ 0 < (charge / charge_1) ^ ↑charge_2

case right
length : LengthUnit
time : TimeUnit
mass : MassUnit
charge : ChargeUnit
temperature : TemperatureUnit
length_1 : LengthUnit
time_1 : TimeUnit
mass_1 : MassUnit
charge_1 : ChargeUnit
temperature_1 : TemperatureUnit
length_2 time_2 mass_2 charge_2 temperature_2 : ℚ
⊢ 0 < (temperature / temperature_1) ^ ↑temperature_2
Physlib/Units/Basic.lean:199:56: warning: This simp argument is unused:
  pow_pos

Hint: Omit it from the simp argument list.
  simp [dimScale, p̵o̵w̵_̵p̵o̵s̵,̵ ̵Nat.zero_lt_one]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
Physlib/Units/Basic.lean:199:65: warning: This simp argument is unused:
  Nat.zero_lt_one

Hint: Omit it from the simp argument list.
  simp [dimScale, pow_pos,̵ ̵N̵a̵t̵.̵z̵e̵r̵o̵_̵l̵t̵_̵o̵n̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`

```

## UnitChoices.dimScale_SI_SIPrimed

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  rcases d with ⟨_, _, _, _⟩
  rfl
```

### Error tail

```text
work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Units/Basic.lean:254:2: error: Tactic `rfl` failed: The left-hand side
  (SI.dimScale SIPrimed)
    { length := length✝, time := time✝, mass := mass✝, charge := charge✝, temperature := temperature✝ }
is not definitionally equal to the right-hand side
  2⁻¹ ^ ↑{ length := length✝, time := time✝, mass := mass✝, charge := charge✝, temperature := temperature✝ }.length *
          3⁻¹ ^
            ↑{ length := length✝, time := time✝, mass := mass✝, charge := charge✝, temperature := temperature✝ }.time *
        5⁻¹ ^
          ↑{ length := length✝, time := time✝, mass := mass✝, charge := charge✝, temperature := temperature✝ }.mass *
      7⁻¹ ^
        ↑{ length := length✝, time := time✝, mass := mass✝, charge := charge✝, temperature := temperature✝ }.charge *
    11⁻¹ ^
      ↑{ length := length✝, time := time✝, mass := mass✝, charge := charge✝, temperature := temperature✝ }.temperature

length✝ time✝ mass✝ charge✝ temperature✝ : ℚ
⊢ (SI.dimScale SIPrimed)
      { length := length✝, time := time✝, mass := mass✝, charge := charge✝, temperature := temperature✝ } =
    2⁻¹ ^ ↑{ length := length✝, time := time✝, mass := mass✝, charge := charge✝, temperature := temperature✝ }.length *
            3⁻¹ ^
              ↑{ length := length✝, time := time✝, mass := mass✝, charge := charge✝,
                    temperature := temperature✝ }.time *
          5⁻¹ ^
            ↑{ length := length✝, time := time✝, mass := mass✝, charge := charge✝, temperature := temperature✝ }.mass *
        7⁻¹ ^
          ↑{ length := length✝, time := time✝, mass := mass✝, charge := charge✝, temperature := temperature✝ }.charge *
      11⁻¹ ^
        ↑{ length := length✝, time := time✝, mass := mass✝, charge := charge✝, temperature := temperature✝ }.temperature

```

## UnitChoices.dimScale_SIPrimed_SI

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  rfl
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Units/Basic.lean:264:2: error: Tactic `rfl` failed: The left-hand side
  (SIPrimed.dimScale SI) d
is not definitionally equal to the right-hand side
  2 ^ ↑d.length * 3 ^ ↑d.time * 5 ^ ↑d.mass * 7 ^ ↑d.charge * 11 ^ ↑d.temperature

d : Dimension
⊢ (SIPrimed.dimScale SI) d = 2 ^ ↑d.length * 3 ^ ↑d.time * 5 ^ ↑d.mass * 7 ^ ↑d.charge * 11 ^ ↑d.temperature

```

## UnitChoices.hasDimension_iff

File: `Physlib/Units/Basic.lean`

### Generated proof

```lean
by
  by_cases h : u1 = u2 <;> simp_all [UnitChoices.dimScale, HasDimension]
  <;> aesop
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Units/Basic.lean:315:15: error(lean.unknownIdentifier): Unknown identifier `u1`
Physlib/Units/Basic.lean:315:20: error(lean.unknownIdentifier): Unknown identifier `u2`
Physlib/Units/Basic.lean:314:0: error: unsolved goals
M : Type
inst✝ : CarriesDimension M
f : UnitChoices → M
⊢ HasDimension f ↔ ∀ (u1 u2 : UnitChoices), f u2 = (u1.dimScale u2) (dim M) • f u1

```

## minkowskiMatrix.as_diagonal

File: `Physlib/Relativity/MinkowskiMatrix.lean`

### Generated proof

```lean
by
  ext i j
  by_cases h : i = j <;> simp_all [minkowskiMatrix, diagonal, Sum.elim, Fin.sum_univ_succ, mul_comm]
  <;> aesop
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Relativity/MinkowskiMatrix.lean:89:6: warning: aesop: failed to prove the goal after exhaustive search.
Physlib/Relativity/MinkowskiMatrix.lean:89:6: warning: aesop: failed to prove the goal after exhaustive search.
Physlib/Relativity/MinkowskiMatrix.lean:86:0: error: unsolved goals
case pos.inl
d : ℕ
val : Fin 1
⊢ LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin d) ℝ (Sum.inl val) (Sum.inl val) = 1

case pos.inr
d : ℕ
val_1 : Fin d
⊢ LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin d) ℝ (Sum.inr val_1) (Sum.inr val_1) = -1

case neg.inl.inl
d : ℕ
val val_1 : Fin 1
h : ¬val = val_1
⊢ LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin d) ℝ (Sum.inl val) (Sum.inl val_1) = 0

case neg.inr.inr
d : ℕ
val_1 val_2 : Fin d
h : ¬val_1 = val_2
⊢ LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin d) ℝ (Sum.inr val_1) (Sum.inr val_2) = 0
Physlib/Relativity/MinkowskiMatrix.lean:88:72: warning: This simp argument is unused:
  Fin.sum_univ_succ

Hint: Omit it from the simp argument list.
  simp_all [minkowskiMatrix, diagonal, Sum.elim, F̵i̵n̵.̵s̵u̵m̵_̵u̵n̵i̵v̵_̵s̵u̵c̵c̵,̵ ̵mul_comm]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
Physlib/Relativity/MinkowskiMatrix.lean:88:91: warning: This simp argument is unused:
  mul_comm

Hint: Omit it from the simp argument list.
  simp_all [minkowskiMatrix, diagonal, Sum.elim, Fin.sum_univ_succ,̵ ̵m̵u̵l̵_̵c̵o̵m̵m̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`

```

## minkowskiMatrix.as_block

File: `Physlib/Relativity/MinkowskiMatrix.lean`

### Generated proof

```lean
by
  ext i j
  fin_cases i <;> fin_cases j <;> rfl
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Relativity/MinkowskiMatrix.lean:89:6: error: (kernel) declaration has metavariables 'minkowskiMatrix.as_block'

```

## minkowskiMatrix.inr_i_inr_i

File: `Physlib/Relativity/MinkowskiMatrix.lean`

### Generated proof

```lean
by
  simp [minkowskiMatrix, Fin.sum_univ_succ, Fin.sum_univ_zero]
  <;> aesop
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Relativity/MinkowskiMatrix.lean:123:6: error: tactic 'aesop' failed, made no progress
Initial goal:
  d : ℕ
  i : Fin d
  ⊢ LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin d) ℝ (Sum.inr i) (Sum.inr i) = -1
Physlib/Relativity/MinkowskiMatrix.lean:122:25: warning: This simp argument is unused:
  Fin.sum_univ_succ

Hint: Omit it from the simp argument list.
  simp [minkowskiMatrix, Fin.sum_univ_s̵u̵c̵c̵,̵ ̵F̵i̵n̵.̵s̵u̵m̵_̵u̵n̵i̵v̵_̵zero]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
Physlib/Relativity/MinkowskiMatrix.lean:122:44: warning: This simp argument is unused:
  Fin.sum_univ_zero

Hint: Omit it from the simp argument list.
  simp [minkowskiMatrix, Fin.sum_univ_succ,̵ ̵F̵i̵n̵.̵s̵u̵m̵_̵u̵n̵i̵v̵_̵z̵e̵r̵o̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`

```

## minkowskiMatrix.off_diag_zero

File: `Physlib/Relativity/MinkowskiMatrix.lean`

### Generated proof

```lean
by
  cases h <;> simp_all
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Relativity/MinkowskiMatrix.lean:127:2: error: Tactic `cases` failed: major premise type is not an inductive type
  μ = ν → False

Explanation: the `cases` tactic is for constructor-based reasoning as well as for applying custom cases principles with a 'using' clause or a registered '@[cases_eliminator]' theorem. The above type neither is an inductive type nor has a registered theorem.

d : ℕ
μ ν : Fin 1 ⊕ Fin d
h : μ ≠ ν
⊢ η μ ν = 0

```

## minkowskiMatrix.η_diag_ne_zero

File: `Physlib/Relativity/MinkowskiMatrix.lean`

### Generated proof

```lean
by
  intro i
  exact (by decide)
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Relativity/MinkowskiMatrix.lean:132:12: error: Tactic `decide` proved that the proposition
  False
is false

```

## minkowskiMatrix.sq

File: `Physlib/Relativity/MinkowskiMatrix.lean`

### Generated proof

```lean
by
  ext i j
  simp [minkowskiMatrix, Matrix.mul_apply, Fin.sum_univ_succ, Finset.sum_ite_eq, Finset.filter_and,
    Finset.filter_or, Finset.filter_eq, Finset.filter_eq', Finset.sum_const, Finset.card_univ]
  <;> fin_cases i <;> fin_cases j <;>
    simp_all [Fin.sum_univ_succ, Finset.sum_ite_eq, Finset.filter_and, Finset.filter_or, Finset.filter_eq,
      Finset.filter_eq', Finset.sum_const, Finset.card_univ]
  <;> aesop
```

### Error tail

```text
inset.filter_and,
      Finset.filter_o̵r̵,̵ ̵F̵i̵n̵s̵et̵.̵f̵i̵l̵t̵e̵r̵_̵e̵q, Finset.filter_eq', Finset.sum_const, Finset.card_univ]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
Physlib/Relativity/MinkowskiMatrix.lean:146:22: warning: This simp argument is unused:
  Finset.filter_eq

Hint: Omit it from the simp argument list.
  simp [minkowskiMatrix, Matrix.mul_apply, Fin.sum_univ_succ, Finset.sum_ite_eq, Finset.filter_and,
      Finset.filter_or, Finset.filter_eq,̵ ̵F̵i̵n̵s̵e̵t̵.̵f̵i̵l̵t̵e̵r̵_̵e̵q̵', Finset.sum_const, Finset.card_univ]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
Physlib/Relativity/MinkowskiMatrix.lean:146:40: warning: This simp argument is unused:
  Finset.filter_eq'

Hint: Omit it from the simp argument list.
  simp [minkowskiMatrix, Matrix.mul_apply, Fin.sum_univ_succ, Finset.sum_ite_eq, Finset.filter_and,
      Finset.filter_or, Finset.filter_eq, Finset.f̵i̵l̵t̵e̵r̵_̵e̵q̵'̵,̵ ̵F̵i̵n̵se̵t̵.̵s̵um_const, Finset.card_univ]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
Physlib/Relativity/MinkowskiMatrix.lean:146:59: warning: This simp argument is unused:
  Finset.sum_const

Hint: Omit it from the simp argument list.
  simp [minkowskiMatrix, Matrix.mul_apply, Fin.sum_univ_succ, Finset.sum_ite_eq, Finset.filter_and,
      Finset.filter_or, Finset.filter_eq, Finset.filter_eq', Finset.s̵u̵m̵_̵co̵n̵s̵t̵,̵ ̵F̵i̵n̵s̵e̵t̵.̵c̵ard_univ]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
Physlib/Relativity/MinkowskiMatrix.lean:146:77: warning: This simp argument is unused:
  Finset.card_univ

Hint: Omit it from the simp argument list.
  simp [minkowskiMatrix, Matrix.mul_apply, Fin.sum_univ_succ, Finset.sum_ite_eq, Finset.filter_and,
      Finset.filter_or, Finset.filter_eq, Finset.filter_eq', Finset.sum_const,̵ ̵F̵i̵n̵s̵e̵t̵.̵c̵a̵r̵d̵_̵u̵n̵i̵v̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`

```

## minkowskiMatrix.η_apply_mul_η_apply_diag

File: `Physlib/Relativity/MinkowskiMatrix.lean`

### Generated proof

```lean
by
  ext i
  fin_cases i <;> simp_all [mul_apply, Fin.sum_univ_succ]
  <;> aesop
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Relativity/MinkowskiMatrix.lean:149:2: error: No applicable extensionality theorem found for type
  ℝ

Note: Extensionality theorems can be registered by marking them with the `[ext]` attribute

```

## minkowskiMatrix.η_apply_sq_eq_one

File: `Physlib/Relativity/MinkowskiMatrix.lean`

### Generated proof

```lean
by
  fin_cases i <;> rfl
  <;> simp
  <;> decide
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Relativity/MinkowskiMatrix.lean:154:12: error(lean.unknownIdentifier): Unknown identifier `i`

```

## minkowskiMatrix.eq_transpose

File: `Physlib/Relativity/MinkowskiMatrix.lean`

### Generated proof

```lean
by
  ext i j
  fin_cases i <;> fin_cases j <;> rfl
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Relativity/MinkowskiMatrix.lean:164:6: error: (kernel) declaration has metavariables 'minkowskiMatrix.eq_transpose'

```

## minkowskiMatrix.det_eq_neg_one_pow_d

File: `Physlib/Relativity/MinkowskiMatrix.lean`

### Generated proof

```lean
by
  rw [minkowskiMatrix]
  simp [Matrix.det_succ_row_zero, Fin.sum_univ_succ, Finset.sum_range_succ, pow_add, pow_one, mul_comm]
  <;> induction d with
  | zero => simp
  | succ d ih =>
    simp_all [Finset.sum_range_succ, pow_add, pow_one, mul_comm, mul_assoc, mul_left_comm]
    <;> ring_nf at *
    <;> omega
```

### Error tail

```text
warning: mathlib: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/mathlib' has local changes
warning: batteries: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/batteries' has local changes
warning: UnicodeBasic: repository '/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built/.lake/packages/UnicodeBasic' has local changes

Physlib/Relativity/MinkowskiMatrix.lean:181:2: error: `simp` made no progress

```

