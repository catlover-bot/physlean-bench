# Cross-domain Physlib pilot 100 examples

## Passed examples

### TensorSpecies.Tensor.Pure.dropPair_comm

- file: `Physlib/Relativity/Tensors/Contraction/Pure.lean`
- domains: `Mathematics, Relativity`
- cross_domain_type: `Mathematics+Relativity`
- score: `4.0`

```lean
by
  sorry
```

### PureU1.constAbs_sort

- file: `Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `3.7`

```lean
by
  simp_all [ConstAbs, sort]
  <;> aesop
```

## Failed examples

### QuantumMechanics.position_commutation_momentum

- file: `Physlib/QuantumMechanics/DDimensions/Operators/Commutation.lean`
- domains: `Mathematics, QuantumMechanics, SpaceAndTime`
- cross_domain_type: `Mathematics+QuantumMechanics+SpaceAndTime`
- score: `6.0`

#### Generated proof

```lean
by
  exact?
```

#### Error tail

```text

Physlib/QuantumMechanics/DDimensions/Operators/Commutation.lean:155:2: error: (deterministic) timeout at `whnf`, maximum number of heartbeats (200000) has been reached

Note: Use `set_option maxHeartbeats <num>` to set the limit.

Hint: Additional diagnostic information may be available using the `set_option diagnostics true` command.

```

### Electromagnetism.ElectromagneticPotential.canonicalMomentum_eq_gradient_kineticTerm

- file: `Physlib/Electromagnetism/Dynamics/Hamiltonian.lean`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_type: `Electromagnetism+Relativity+SpaceAndTime`
- score: `6.0`

#### Generated proof

```lean
by
  funext x
  ext v
  simp [canonicalMomentum, kineticTerm, mul_comm]
  <;> rfl
```

#### Error tail

```text

Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:98:2: error: No applicable extensionality theorem found for type
  Lorentz.Vector d

Note: Extensionality theorems can be registered by marking them with the `[ext]` attribute

```

### Electromagnetism.ElectromagneticPotential.canonicalMomentum_eq_electricField

- file: `Physlib/Electromagnetism/Dynamics/Hamiltonian.lean`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_type: `Electromagnetism+Relativity+SpaceAndTime`
- score: `6.0`

#### Generated proof

```lean
fun x => fun _ => match x.space with
  | Sum.inl 0 => 0
  | Sum.inr i => -(1 / (i * c)) * A.electricField.c (x.time.c) x.space i
```

#### Error tail

```text

Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:191:0: error: Type mismatch
  fun x x_1 => ?m.170
has type
  (x : ?m.167) → (x_1 : ?m.173 x) → ?m.174 x x_1
but is expected to have type
  canonicalMomentum 𝓕 A J = fun x μ =>
    match μ with
    | Sum.inl 0 => 0
    | Sum.inr i => -(1 / (𝓕.μ₀ * 𝓕.c.val)) * (electricField 𝓕.c A ((time 𝓕.c) x) (space x)).ofLp i
Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:191:24: error(lean.invalidField): Invalid field notation: Type of
  x
is not known; cannot resolve field `space`

Hint: Consider replacing the field projection with a call to one of the following:
  • `AbstractCompletion.space`
  • `space`
Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:191:24: error(lean.invalidField): Invalid field notation: Type of
  x
is not known; cannot resolve field `space`

Hint: Consider replacing the field projection with a call to one of the following:
  • `AbstractCompletion.space`
  • `space`
Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:193:28: error(lean.unknownIdentifier): Unknown identifier `c`
Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:193:50: error(lean.invalidField): Invalid field `c`: The environment does not contain `Function.c`, so it is not possible to project the field `c` from an expression
  electricField 1 A
of type
  Time → Space d → EuclideanSpace ℝ (Fin d)
Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:191:18: error: Missing cases:
(Sum.inl (Nat.succ _))

```

### Electromagnetism.ElectromagneticPotential.hamiltonian_eq_electricField_scalarPotential

- file: `Physlib/Electromagnetism/Dynamics/Hamiltonian.lean`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_type: `Electromagnetism+Relativity+SpaceAndTime`
- score: `6.0`

#### Generated proof

```lean
by providing the correct Lean4 code.

### Step 2: Analyze the Lean4 Code

The Lean4 code snippet is incomplete, but we can infer that the theorem involves the following:

1. `A : ElectromagneticPotential d` is an electromagnetic potential.
2. `hA : ContDiff2 A` is a hypothesis that \( A \) is twice continuously differentiable.
3. `J : LorentzCurrentDensity d` is a Lorentz current density.
4. `x : SpaceTime d` is a spacetime point.
5. The goal is to prove that `A.hamiltonian J x = ...` (some expression involving the electric field and scalar potential).

### Step 3: Understand the Lean4 Definitions

To complete the proof, we need to understand the definitions of the terms involved:

1. `hamiltonian`: This is likely the Hamiltonian of the electromagnetic potential \( A \) and the current density \( J \).
2. `electricField`: The electric field \( \mathbf{E} \) associated with the potential \( A \).
3. `scalarPotential`: The scalar potential \( \phi \) associated with the potential \( A \).
4. The expression `(1/.c.val^2*.ÃĹ)*(A.electricField.c(x.time.c)x.space^2+A.electricField.c(x.time.c)x.space,Space.grad(A.scalarPotential.c(x.time.c)Î·)x.space_)` is a combination of the electric field and the gradient of the scalar potential.
5. `lagrangianAJx` is the Lagrangian density involving \( A \) and \( J \).

### Step 4: Prove the Equality

To prove the equality, we need to show that the left-hand side (LHS) equals the right-hand side (RHS). The RHS is a combination of the electric field and the gradient of the scalar potential, while the LHS is the Hamiltonian of the electromagnetic potential and the
```

#### Error tail

```text

Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:259:4: error: unknown tactic
Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:259:0: error: unsolved goals
d : ℕ
𝓕 : FreeSpace
A : ElectromagneticPotential d
hA : ContDiff ℝ 2 A.val
J : LorentzCurrentDensity d
x : SpaceTime d
⊢ hamiltonian 𝓕 A J x =
    1 / 𝓕.c.val ^ 2 * 𝓕.μ₀⁻¹ *
        (‖electricField 𝓕.c A ((time 𝓕.c) x) (space x)‖ ^ 2 +
          ⟪electricField 𝓕.c A ((time 𝓕.c) x) (space x),
            Space.grad (fun x_1 => scalarPotential 𝓕.c A ((time 𝓕.c) x) x_1) (space x)⟫_ℝ) -
      lagrangian 𝓕 A J x
Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:265:5: error: unexpected token ':'; expected ':=', 'where' or '|'
Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:265:0: error: Function expected at
  1.
but this term has type
  ?m.4

Note: Expected a function because this term is being applied to the argument
  `A

```

### Electromagnetism.ElectromagneticPotential.hamiltonian_eq_electricField_magneticField

- file: `Physlib/Electromagnetism/Dynamics/Hamiltonian.lean`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_type: `Electromagnetism+Relativity+SpaceAndTime`
- score: `5.9`

#### Generated proof

```lean
by
  unfold hamiltonian
  simp [contDiff2_iff, mul_comm, mul_assoc, mul_left_comm, sub_eq_add_neg, add_assoc]
  <;> norm_num
  <;> ring
  <;> aesop
```

#### Error tail

```text

Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:291:8: error(lean.unknownIdentifier): Unknown identifier `contDiff2_iff`
Try this:
  [apply] ring_nf
  
  The `ring` tactic failed to close the goal. Use `ring_nf` to obtain a normal form.
    
  Note that `ring` works primarily in *commutative* rings. If you have a noncommutative ring, abelian group or module, consider using `noncomm_ring`, `abel` or `module` instead.
Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:294:6: warning: aesop: failed to prove the goal after exhaustive search.
Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:289:0: error: unsolved goals
d : ℕ
𝓕 : FreeSpace
A : ElectromagneticPotential d
hA : ContDiff ℝ 2 A.val
J : LorentzCurrentDensity d
x : SpaceTime d
⊢ ∑ x_1, ∂_ (Sum.inl 0) A.val x x_1 * canonicalMomentum 𝓕 A J x x_1 - lagrangian 𝓕 A J x =
    𝓕.ε₀ * ‖electricField 𝓕.c A ((time 𝓕.c) x) (space x)‖ ^ 2 * 2⁻¹ +
            (𝓕.ε₀ * 𝓕.c.val ^ 2 * ∑ x_1, ∑ x_2, magneticFieldMatrix 𝓕.c A ((time 𝓕.c) x) (space x) (x_1, x_2) ^ 2) *
              4⁻¹ +
          𝓕.ε₀ *
            ⟪electricField 𝓕.c A ((time 𝓕.c) x) (space x),
              Space.grad (fun x_1 => scalarPotential 𝓕.c A ((time 𝓕.c) x) x_1) (space x)⟫_ℝ +
        scalarPotential 𝓕.c A ((time 𝓕.c) x) (space x) *
          LorentzCurrentDensity.chargeDensity 𝓕.c J ((time 𝓕.c) x) (space x) -
      ∑ x_1,
        (vectorPotential 𝓕.c A ((time 𝓕.c) x) (space x)).ofLp x_1 *
          (LorentzCurrentDensity.currentDensity 𝓕.c J ((time 𝓕.c) x) (space x)).ofLp x_1
Physlib/Electromagnetism/Dynamics/Hamiltonian.lean:291:44: warning: This simp argument is unused:
  mul_left_comm

Hint: Omit it from the simp argument list.
  simp [contDiff2_iff, mul_comm, mul_assoc, m̵u̵l̵_̵l̵e̵f̵t̵_̵c̵o̵m̵m̵,̵ ̵sub_eq_add_neg, add_assoc]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`

```

### UnitChoices.dimScale_transitive

- file: `Physlib/Units/Basic.lean`
- domains: `Thermodynamics, Units`
- cross_domain_type: `Thermodynamics+Units`
- score: `4.0`

#### Generated proof

```lean
by
  rcases u1 with (_ | _ | _) <;> rcases u2 with (_ | _ | _) <;> rcases u3 with (_ | _ | _) <;>
    rcases d with (_ | _ | _) <;>
    simp [dimScale, mul_assoc, mul_comm, mul_left_comm]
  <;> norm_num
  <;> rfl
```

#### Error tail

```text

Physlib/Units/Basic.lean:135:0: error: (deterministic) timeout at `whnf`, maximum number of heartbeats (200000) has been reached

Note: Use `set_option maxHeartbeats <num>` to set the limit.

Hint: Additional diagnostic information may be available using the `set_option diagnostics true` command.
Physlib/Units/Basic.lean:145:6: error: (kernel) unknown constant 'UnitChoices.dimScale_transitive'
Physlib/Units/Basic.lean:349:29: error: (kernel) unknown constant 'UnitChoices.dimScale_transitive'

```

### UnitChoices.dimScale_symm

- file: `Physlib/Units/Basic.lean`
- domains: `Thermodynamics, Units`
- cross_domain_type: `Thermodynamics+Units`
- score: `4.0`

#### Generated proof

```lean
by
  cases u1 <;> cases u2 <;> simp_all [dimScale, mul_comm, mul_assoc, mul_left_comm]
  <;> rfl
```

#### Error tail

```text

Physlib/Units/Basic.lean:173:6: error: Tactic `rfl` failed: The left-hand side
  (length✝¹ / length✝) ^ ↑d.length *
    ((time✝¹ / time✝) ^ ↑d.time *
      ((mass✝¹ / mass✝) ^ ↑d.mass *
        ((charge✝¹ / charge✝) ^ ↑d.charge * (temperature✝¹ / temperature✝) ^ ↑d.temperature)))
is not definitionally equal to the right-hand side
  ((length✝ / length✝¹) ^ ↑d.length)⁻¹ *
    (((time✝ / time✝¹) ^ ↑d.time)⁻¹ *
      (((mass✝ / mass✝¹) ^ ↑d.mass)⁻¹ *
        (((charge✝ / charge✝¹) ^ ↑d.charge)⁻¹ * ((temperature✝ / temperature✝¹) ^ ↑d.temperature)⁻¹)))

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
⊢ (length✝¹ / length✝) ^ ↑d.length *
      ((time✝¹ / time✝) ^ ↑d.time *
        ((mass✝¹ / mass✝) ^ ↑d.mass *
          ((charge✝¹ / charge✝) ^ ↑d.charge * (temperature✝¹ / temperature✝) ^ ↑d.temperature))) =
    ((length✝ / length✝¹) ^ ↑d.length)⁻¹ *
      (((time✝ / time✝¹) ^ ↑d.time)⁻¹ *
        (((mass✝ / mass✝¹) ^ ↑d.mass)⁻¹ *
          (((charge✝ / charge✝¹) ^ ↑d.charge)⁻¹ * ((temperature✝ / temperature✝¹) ^ ↑d.temperature)⁻¹)))
Physlib/Units/Basic.lean:172:69: warning: This simp argument is unused:
  mul_left_comm

Hint: Omit it from the simp argument list.
  simp_all [dimScale, mul_comm, mul_assoc,̵ ̵m̵u̵l̵_̵l̵e̵f̵t̵_̵c̵o̵m̵m̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`

```

### PureU1.lineInPlaneCond_perm

- file: `Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `4.0`

#### Generated proof

```lean
by
  rw [LineInPlaneCond] at hS âĬ¢
  simp_all [mul_comm]
  <;> aesop
```

#### Error tail

```text

Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean:47:6: error: Failed to rewrite using equation theorems for `LineInPlaneCond`
Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean:47:31: error: expected token

```

### PureU1.lineInPlaneCond_eq_last'

- file: `Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `4.0`

#### Generated proof

```lean
by
  rcases n with (_ | _ | n) <;> simp_all [Fin.last, Fin.castSucc, Nat.succ_eq_add_one, Nat.add_assoc]
  <;>
  (try cases S <;> simp_all [LineInPlaneCondS, PureU1, LinSols, Fin.forall_fin_succ] <;>
    ring_nf at * <;>
    nlinarith) <;>
  (try aesop) <;>
  (try linarith) <;>
  (try nlinarith)
```

#### Error tail

```text

Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean:57:0: error: unsolved goals
case zero
S : (PureU1 (Nat.succ 0).succ).LinSols
hS : LineInPlaneCond S
h : ¬S.val 0 ^ 2 = S.val 1 ^ 2
⊢ 2 * S.val 1 = -(2 * S.val 0)

case succ.zero
S : (PureU1 (0 + 1).succ.succ).LinSols
hS : LineInPlaneCond S
h : ¬S.val 1 ^ 2 = S.val 2 ^ 2
⊢ (2 - 1) * S.val 2 = (1 - 2) * S.val 1

case succ.succ
n : ℕ
S : (PureU1 (n + 1 + 1).succ.succ).LinSols
hS : LineInPlaneCond S
h : ¬S.val ⟨n + 2, ⋯⟩ ^ 2 = S.val ⟨n + 3, ⋯⟩ ^ 2
⊢ -(↑n * S.val ⟨n + 3, ⋯⟩) = ↑n * S.val ⟨n + 2, ⋯⟩

```

### PureU1.lineInPlaneCond_eq_last

- file: `Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `4.0`

#### Generated proof

```lean
by
  simp_all [LineInPlaneCond, ConstAbsProp, Fin.last, Fin.castSucc]
  <;> aesop
```

#### Error tail

```text

Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean:87:6: error: tactic 'aesop' failed, made no progress
Initial goal:
  n : ℕ
  S : (PureU1 n.succ.succ.succ.succ.succ).LinSols
  hS : ∀ (i1 i2 i3 : Fin (n + 4 + 1)), ¬i1 = i2 → ¬i2 = i3 → ¬i1 = i3 → LineInPlaneProp (S.val i1, S.val i2, S.val i3)
  ⊢ S.val ⟨n + 2 + 1, ⋯⟩ ^ 2 = S.val ⟨n + 2 + 1 + 1, ⋯⟩ ^ 2

```

### PureU1.linesInPlane_eq_sq

- file: `Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `4.0`

#### Generated proof

```lean
by leveraging the hypothesis `hS` and the definition of `ConstAbsProp`.

#### Step-by-Step Proof
1. **Assume `ConstAbsProp(a, b)` is defined as `|a| + |b| ≤ 100`**:
   - Then, we need to show that for all `ij`, `|S.vali| + |S.valj| ≤ 100`.
2. **Use the hypothesis `hS`**:
   - The hypothesis `hS` likely provides a relationship between `S.vali` and `S.valj` that allows us to bound their absolute values. For example, if `hS` states that `S.vali * S.valj = 0`, then either `S.vali = 0` or `S.valj = 0`, which implies `
```

#### Error tail

```text

Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean:108:4: error: unknown tactic
Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean:108:0: error: unsolved goals
n : ℕ
S : (PureU1 n.succ.succ.succ.succ.succ).LinSols
hS : LineInPlaneCond S
⊢ ∀ (i j : Fin n.succ.succ.succ.succ.succ), i ≠ j → ConstAbsProp (S.val i, S.val j)
Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean:114:144: error: unexpected token ','; expected ':=', 'where' or '|'

```

### PureU1.linesInPlane_four

- file: `Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `4.0`

#### Generated proof

```lean
by
  simp_all [LineInPlaneCond, ConstAbsProp, Fin.forall_fin_succ, Fin.sum_univ_succ]
  <;> norm_num
  <;> aesop
```

#### Error tail

```text

Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean:128:6: warning: aesop: failed to prove the goal after exhaustive search.
Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean:125:0: error: unsolved goals
S : (PureU1 4).Sols
left : LineInPlaneProp (S.val 0, S.val 1, S.val 2)
right_2 : LineInPlaneProp (S.val 0, S.val 1, S.val 3)
left_2 : LineInPlaneProp (S.val 0, S.val 2, S.val 1)
right_4 : LineInPlaneProp (S.val 0, S.val 2, S.val 3)
left_4 : LineInPlaneProp (S.val 0, S.val 3, S.val 1)
right_1 : LineInPlaneProp (S.val 0, S.val 3, S.val 2)
left_1 : LineInPlaneProp (S.val 1, S.val 0, S.val 2)
right_5 : LineInPlaneProp (S.val 1, S.val 0, S.val 3)
left_5 : LineInPlaneProp (S.val 1, S.val 2, S.val 0)
right_7 : LineInPlaneProp (S.val 1, S.val 2, S.val 3)
left_7 : LineInPlaneProp (S.val 1, S.val 3, S.val 0)
right_3 : LineInPlaneProp (S.val 1, S.val 3, S.val 2)
left_3 : LineInPlaneProp (S.val 2, S.val 0, S.val 1)
right_8 : LineInPlaneProp (S.val 2, S.val 0, S.val 3)
left_6 : LineInPlaneProp (S.val 3, S.val 0, S.val 1)
right_9 : LineInPlaneProp (S.val 3, S.val 0, S.val 2)
left_8 : LineInPlaneProp (S.val 2, S.val 1, S.val 0)
right_10 : LineInPlaneProp (S.val 2, S.val 1, S.val 3)
left_10 : LineInPlaneProp (S.val 2, S.val 3, S.val 0)
right_6 : LineInPlaneProp (S.val 2, S.val 3, S.val 1)
left_9 : LineInPlaneProp (S.val 3, S.val 1, S.val 0)
right_11 : LineInPlaneProp (S.val 3, S.val 1, S.val 2)
left_11 : LineInPlaneProp (S.val 3, S.val 2, S.val 0)
right : LineInPlaneProp (S.val 3, S.val 2, S.val 1)
⊢ S.val 0 ^ 2 = S.val 1 ^ 2
Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean:126:64: warning: This simp argument is unused:
  Fin.sum_univ_succ

Hint: Omit it from the simp argument list.
  simp_all [LineInPlaneCond, ConstAbsProp, Fin.forall_fin_succ,̵ ̵F̵i̵n̵.̵s̵u̵m̵_̵u̵n̵i̵v̵_̵s̵u̵c̵c̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`

```

### PureU1.linesInPlane_eq_sq_four

- file: `Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `4.0`

#### Generated proof

```lean
by

### simp_all [Fin.forall_fin_succ, Fin.forall_fin_succ]

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;> aesop

### <;>
```

#### Error tail

```text

Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean:167:2: error: unexpected token '#'; expected '{' or tactic
Physlib/QFT/QED/AnomalyCancellation/LineInPlaneCond.lean:167:0: error: unsolved goals
S : (PureU1 4).Sols
hS : LineInPlaneCond S.toLinSols
⊢ ∀ (i j : Fin 4), i ≠ j → ConstAbsProp (S.val i, S.val j)

```

### PureU1.constAbs_perm

- file: `Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `4.0`

#### Generated proof

```lean
by
  intro S M
  exact?
```

#### Error tail

```text

Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:37:8: error: Tactic `introN` failed: There are no additional binders or `let` bindings in the goal to introduce

n : ℕ
S : (PureU1 n).Charges
M : (FamilyPermutations n).group
⊢ ConstAbs (((FamilyPermutations n).rep M) S) ↔ ConstAbs S

```

### PureU1.ConstAbsSorted.boundary_accGrav'

- file: `Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `4.0`

#### Generated proof

```lean
by
  rfl
```

#### Error tail

```text

Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:129:2: error: Tactic `rfl` failed: The left-hand side
  (accGrav n.succ) S
is not definitionally equal to the right-hand side
  ∑ i, S (Fin.cast ⋯ i)

n : ℕ
S : (PureU1 n.succ).Charges
k : Fin n
⊢ (accGrav n.succ) S = ∑ i, S (Fin.cast ⋯ i)

```

### PureU1.ConstAbsSorted.boundary_accGrav''

- file: `Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `4.0`

#### Generated proof

```lean
by
  intro k hk
  rcases k with (_ | _ | k) <;> simp_all [Boundary, accGrav, Nat.succ_eq_add_one, Nat.add_assoc]
  <;> ring_nf at * <;> norm_num at * <;> linarith
  <;> simp_all [Boundary, accGrav, Nat.succ_eq_add_one, Nat.add_assoc]
  <;> ring_nf at * <;> norm_num at * <;> linarith
  <;> simp_all [Boundary, accGrav, Nat.succ_eq_add_one, Nat.add_assoc]
  <;> ring_nf at * <;> norm_num at * <;> linarith
```

#### Error tail

```text

Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:140:8: error: Tactic `introN` failed: There are no additional binders or `let` bindings in the goal to introduce

n : ℕ
S : (PureU1 n.succ).Charges
hS : ConstAbsSorted S
k : Fin n
hk : Boundary S k
⊢ (accGrav n.succ) S = (2 * ↑↑k + 1 - ↑n) * S 0

```

### PureU1.ConstAbsSorted.AFL_hasBoundary

- file: `Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `4.0`

#### Generated proof

```lean
by
  exact ⟨by simpa using h, by simpa using h⟩
```

#### Error tail

```text

Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:187:12: error: Type mismatch: After simplification, term
  h
 has type
  ¬A.val 0 = 0
of sort `Prop` but is expected to have type
  Fin n
of sort `Type`

```

### PureU1.ConstAbsSorted.AFL_odd_noBoundary

- file: `Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `4.0`

#### Generated proof

```lean
by
  apply by_contradiction
  intro h_contra
  have h1 := hA
  have h2 := h
  cases n with
  | zero =>
    -- For n = 0, we directly check the conditions and find a contradiction.
    simp_all [Fin.forall_fin_succ, Fin.sum_univ_succ, PureU1, LinSols, ConstAbsSorted, HasBoundary]
    <;> omega
  | succ n =>
    -- For n = k + 1, we use the induction hypothesis and simplify the conditions.
    simp_all [Fin.forall_fin_succ, Fin.sum_univ_succ, PureU1, LinSols, ConstAbsSorted, HasBoundary]
    <;> omega
```

#### Error tail

```text

Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:205:62: error(lean.unknownIdentifier): Unknown identifier `LinSols`
Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:209:62: error(lean.unknownIdentifier): Unknown identifier `LinSols`
Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:210:8: error: omega could not prove the goal:
No usable constraints found. You may need to unfold definitions so `omega` can see linear arithmetic facts about `Nat` and `Int`, which may also involve multiplication, division, and modular remainder by constants.
Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:205:35: warning: This simp argument is unused:
  Fin.sum_univ_succ

Hint: Omit it from the simp argument list.
  simp_all [Fin.forall_fin_succ, F̵i̵n̵.̵s̵u̵m̵_̵u̵n̵i̵v̵_̵s̵u̵c̵c̵,̵ ̵PureU1, LinSols, ConstAbsSorted, HasBoundary]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:209:35: warning: This simp argument is unused:
  Fin.sum_univ_succ

Hint: Omit it from the simp argument list.
  simp_all [Fin.forall_fin_succ, F̵i̵n̵.̵s̵u̵m̵_̵u̵n̵i̵v̵_̵s̵u̵c̵c̵,̵ ̵PureU1, LinSols, ConstAbsSorted, HasBoundary]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`

```

### PureU1.ConstAbsSorted.AFL_even_Boundary

- file: `Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `4.0`

#### Generated proof

```lean
by
  have h1 := hA
  have h2 := hk
  have h3 := h
  cases k with
  | mk k hk =>
    simp_all [Fin.val_succ, Nat.mul_succ, Nat.add_assoc]
    <;>
    (try omega) <;>
    (try
      {
        cases n <;> simp_all [Fin.val_succ, Nat.mul_succ, Nat.add_assoc] <;> omega
      }) <;>
    (try
      {
        omega
      }) <;>
    (try
      {
        simp_all [Fin.val_succ, Nat.mul_succ, Nat.add_assoc]
        <;> omega
      })
```

#### Error tail

```text

Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:228:12: error: unsolved goals
case mk
n : ℕ
A : (PureU1 (2 * n.succ)).LinSols
k : ℕ
hk✝ : k < 2 * n + 1
h1 : ¬A.val 0 = 0
h3 : ConstAbsSorted A.val
hk : A.val ⟨k, ⋯⟩ < 0 ∧ 0 < A.val ⟨k + 1, ⋯⟩
⊢ k = n
Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:229:14: warning: This simp argument is unused:
  Fin.val_succ

Hint: Omit it from the simp argument list.
  simp_all [F̵i̵n̵.̵v̵a̵l̵_̵s̵u̵c̵c̵,̵ ̵Nat.mul_succ, Nat.add_assoc]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:229:42: warning: This simp argument is unused:
  Nat.add_assoc

Hint: Omit it from the simp argument list.
  simp_all [Fin.val_succ, Nat.mul_succ,̵ ̵N̵a̵t̵.̵a̵d̵d̵_̵a̵s̵s̵o̵c̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:234:30: warning: This simp argument is unused:
  Fin.val_succ

Hint: Omit it from the simp argument list.
  simp_all [F̵i̵n̵.̵v̵a̵l̵_̵s̵u̵c̵c̵,̵ ̵Nat.mul_succ, Nat.add_assoc]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:234:58: warning: This simp argument is unused:
  Nat.add_assoc

Hint: Omit it from the simp argument list.
  simp_all [Fin.val_succ, Nat.mul_succ,̵ ̵N̵a̵t̵.̵a̵d̵d̵_̵a̵s̵s̵o̵c̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`

```

### PureU1.ConstAbsSorted.AFL_even_below'

- file: `Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean`
- domains: `Particles, QFT`
- cross_domain_type: `Particles+QFT`
- score: `4.0`

#### Generated proof

```lean
by
  have h1 := hA
  have h2 := h
  cases n <;> simp_all [Fin.ext_iff, split_equal, Fin.castAdd, Fin.cast, Nat.mul_succ]
  <;> aesop
```

#### Error tail

```text

Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:240:6: error: tactic 'aesop' failed, made no progress
Initial goal:
  case succ
  n✝ : ℕ
  A : (PureU1 (2 * (n✝ + 1).succ)).LinSols
  i : Fin (n✝ + 1).succ
  h1 : ¬A.val 0 = 0
  h2 : ConstAbsSorted A.val
  ⊢ A.val ⟨↑i, ⋯⟩ = A.val 0
Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:239:24: warning: This simp argument is unused:
  Fin.ext_iff

Hint: Omit it from the simp argument list.
  simp_all [F̵i̵n̵.̵e̵x̵t̵_̵i̵f̵f̵,̵ ̵split_equal, Fin.castAdd, Fin.cast, Nat.mul_succ]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
Physlib/QFT/QED/AnomalyCancellation/ConstAbs.lean:239:37: warning: This simp argument is unused:
  split_equal

Hint: Omit it from the simp argument list.
  simp_all [Fin.ext_iff, s̵p̵l̵i̵t̵_̵e̵q̵u̵a̵l̵,̵ ̵Fin.castAdd, Fin.cast, Nat.mul_succ]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`

```

