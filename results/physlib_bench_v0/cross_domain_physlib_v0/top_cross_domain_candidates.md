# Top Physlib-internal cross-domain candidates

## 1. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.isExtrema_iff_space_time

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/IsExtrema.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, QuantumMechanics, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, QuantumMechanics, Relativity, SpaceAndTime`
- cross_domain_score: `8.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistLorentzCurrentDensity, Electromagnetism.DistElectromagneticPotential.IsExtrema, Electromagnetism.DistElectromagneticPotential.isExtrema_iff_components, Electromagnetism.DistElectromagneticPotential.gradLagrangian_sum_inl_0, Electromagnetism.DistElectromagneticPotential.gradLagrangian_sum_inr_i
  - QuantumMechanics: SchwartzMap.compCLMOfContinuousLinearEquiv
  - Relativity: Electromagnetism.DistLorentzCurrentDensity
  - SpaceAndTime: Space.distSpaceDiv, Space.distTimeDeriv, Space.distSpaceDeriv

```lean
lemma isExtrema_iff_space_time {𝓕 : FreeSpace}
    (A : DistElectromagneticPotential d)
    (J : DistLorentzCurrentDensity d) :
    IsExtrema 𝓕 A J ↔
      (∀ ε, distSpaceDiv (A.electricField 𝓕.c) ε = (1/𝓕.ε₀) * (J.chargeDensity 𝓕.c) ε) ∧
      (∀ ε i, 𝓕.μ₀ * 𝓕.ε₀ * (Space.distTimeDeriv (A.electricField 𝓕.c)) ε i -
      ∑ j, ((PiLp.basisFun 2 ℝ (Fin d)).tensorProduct (PiLp.basisFun 2 ℝ (Fin d))).repr
        ((Space.distSpaceDeriv j (A.magneticFieldMatrix 𝓕.c)) ε) (j, i) +
      𝓕.μ₀ * J.currentDensity 𝓕.c ε i = 0) :=
```

## 2. Electromagnetism.DistElectromagneticPotential.oneDimPointParticleCurrentDensity_eq_distTranslate

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/OneDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- cross_domain_score: `8.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential.oneDimPointParticleCurrentDensity, Electromagnetism.DistElectromagneticPotential.oneDimPointParticleCurrentDensity.eq_1
  - Particles: Electromagnetism.DistElectromagneticPotential.oneDimPointParticleCurrentDensity, Electromagnetism.DistElectromagneticPotential.oneDimPointParticleCurrentDensity.eq_1
  - Relativity: Lorentz.Vector.basis
  - SpaceAndTime: Space.constantTime, Space.distTranslate, Space.distTranslate_apply

```lean
lemma oneDimPointParticleCurrentDensity_eq_distTranslate (c : SpeedOfLight) (q : ℝ) (r₀ : Space 1) :
    oneDimPointParticleCurrentDensity c q r₀ = ((SpaceTime.distTimeSlice c).symm <|
    constantTime <|
    distTranslate (basis.repr r₀) <|
    ((c * q) • diracDelta' ℝ 0 (Lorentz.Vector.basis (Sum.inl 0)))) :=
```

## 3. Electromagnetism.DistElectromagneticPotential.oneDimPointParticleCurrentDensity_chargeDensity

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/OneDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- cross_domain_score: `8.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential.oneDimPointParticleCurrentDensity, Electromagnetism.DistLorentzCurrentDensity.chargeDensity
  - Particles: Electromagnetism.DistElectromagneticPotential.oneDimPointParticleCurrentDensity
  - Relativity: Electromagnetism.DistLorentzCurrentDensity.chargeDensity, Lorentz.Vector.temporalCLM, Lorentz.Vector.apply_smul, Lorentz.Vector.basis_apply
  - SpaceAndTime: Space.constantTime, Space.constantTime_apply

```lean
@[simp]
lemma oneDimPointParticleCurrentDensity_chargeDensity (c : SpeedOfLight) (q : ℝ) (r₀ : Space 1) :
    (oneDimPointParticleCurrentDensity c q r₀).chargeDensity c =
    constantTime (q • diracDelta ℝ r₀) :=
```

## 4. Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_eq_distTranslate

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/OneDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- cross_domain_score: `8.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle.eq_1
  - Particles: Electromagnetism.DistElectromagneticPotential.oneDimPointParticle, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle.eq_1
  - Relativity: Lorentz.Vector.basis
  - SpaceAndTime: Space.constantTime, Space.distTranslate, Space.distOfFunction, Space.distTranslate_ofFunction

```lean
lemma oneDimPointParticle_eq_distTranslate (𝓕 : FreeSpace) (q : ℝ) (r₀ : Space 1) :
    oneDimPointParticle 𝓕 q r₀ = ((SpaceTime.distTimeSlice 𝓕.c).symm <|
    constantTime <|
    distTranslate (basis.repr r₀) <|
    distOfFunction (fun x => ((- (q * 𝓕.μ₀ * 𝓕.c)/ 2) * ‖x‖) • Lorentz.Vector.basis (Sum.inl 0))
      (by fun_prop)) :=
```

## 5. Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_scalarPotential

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/OneDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- cross_domain_score: `8.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle, Electromagnetism.DistElectromagneticPotential.scalarPotential
  - Particles: Electromagnetism.DistElectromagneticPotential.oneDimPointParticle
  - Relativity: Lorentz.Vector.temporalCLM, Lorentz.Vector.apply_smul, Lorentz.Vector.basis_apply
  - SpaceAndTime: Space.constantTime, Space.distOfFunction, Space.constantTime_apply, Space.distOfFunction_vector_eval, Space.distOfFunction_mul_fun, Space.distOfFunction_neg

```lean
lemma oneDimPointParticle_scalarPotential (𝓕 : FreeSpace) (q : ℝ) (r₀ : Space 1) :
    (oneDimPointParticle 𝓕 q r₀).scalarPotential 𝓕.c =
    Space.constantTime (distOfFunction (fun x =>
      - ((q * 𝓕.μ₀ * 𝓕.c ^ 2)/(2)) • ‖x-r₀‖) (by fun_prop)) :=
```

## 6. Electromagnetism.DistElectromagneticPotential.threeDimPointParticleCurrentDensity_eq_distTranslate

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/ThreeDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- cross_domain_score: `8.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential.threeDimPointParticleCurrentDensity, Electromagnetism.DistElectromagneticPotential.threeDimPointParticleCurrentDensity.eq_1
  - Particles: Electromagnetism.DistElectromagneticPotential.threeDimPointParticleCurrentDensity, Electromagnetism.DistElectromagneticPotential.threeDimPointParticleCurrentDensity.eq_1
  - Relativity: Lorentz.Vector.basis
  - SpaceAndTime: Space.constantTime, Space.distTranslate, Space.distTranslate_apply

```lean
lemma threeDimPointParticleCurrentDensity_eq_distTranslate (c : SpeedOfLight) (q : ℝ)
    (r₀ : Space 3) :
    threeDimPointParticleCurrentDensity c q r₀ = ((SpaceTime.distTimeSlice c).symm <|
    constantTime <|
    distTranslate (basis.repr r₀) <|
    ((c * q) • diracDelta' ℝ 0 (Lorentz.Vector.basis (Sum.inl 0)))) :=
```

## 7. Electromagnetism.DistElectromagneticPotential.threeDimPointParticleCurrentDensity_chargeDensity

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/ThreeDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- cross_domain_score: `8.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential.threeDimPointParticleCurrentDensity, Electromagnetism.DistLorentzCurrentDensity.chargeDensity
  - Particles: Electromagnetism.DistElectromagneticPotential.threeDimPointParticleCurrentDensity
  - Relativity: Electromagnetism.DistLorentzCurrentDensity.chargeDensity, Lorentz.Vector.temporalCLM, Lorentz.Vector.apply_smul, Lorentz.Vector.basis_apply
  - SpaceAndTime: Space.constantTime, Space.constantTime_apply

```lean
@[simp]
lemma threeDimPointParticleCurrentDensity_chargeDensity (c : SpeedOfLight) (q : ℝ) (r₀ : Space 3) :
    (threeDimPointParticleCurrentDensity c q r₀).chargeDensity c =
    constantTime (q • diracDelta ℝ r₀) :=
```

## 8. Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_eq_distTranslate

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/ThreeDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- cross_domain_score: `8.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle.eq_1
  - Particles: Electromagnetism.DistElectromagneticPotential.threeDimPointParticle, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle.eq_1
  - Relativity: Lorentz.Vector.basis
  - SpaceAndTime: Space.constantTime, Space.distTranslate, Space.distOfFunction, Space.IsDistBounded.smul_const, Space.distTranslate_ofFunction

```lean
lemma threeDimPointParticle_eq_distTranslate (𝓕 : FreeSpace) (q : ℝ) (r₀ : Space 3) :
    threeDimPointParticle 𝓕 q r₀ = ((SpaceTime.distTimeSlice 𝓕.c).symm <|
    constantTime <|
    distTranslate (basis.repr r₀) <|
    distOfFunction (fun x => (((q * 𝓕.μ₀ * 𝓕.c)/ (4 * π))* ‖x‖⁻¹) •
      Lorentz.Vector.basis (Sum.inl 0))
      ((IsDistBounded.inv.const_mul_fun _).smul_const _)) :=
```

## 9. Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_scalarPotential

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/ThreeDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- cross_domain_score: `8.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle, Electromagnetism.DistElectromagneticPotential.scalarPotential
  - Particles: Electromagnetism.DistElectromagneticPotential.threeDimPointParticle
  - Relativity: Lorentz.Vector.temporalCLM, Lorentz.Vector.apply_smul, Lorentz.Vector.basis_apply
  - SpaceAndTime: Space.constantTime, Space.distOfFunction, Space.IsDistBounded.inv_shift, Space.IsDistBounded.const_mul_fun, Space.constantTime_apply, Space.distOfFunction_vector_eval, Space.distOfFunction_mul_fun

```lean
lemma threeDimPointParticle_scalarPotential (𝓕 : FreeSpace) (q : ℝ) (r₀ : Space 3) :
    (threeDimPointParticle 𝓕 q r₀).scalarPotential 𝓕.c =
    Space.constantTime (distOfFunction (fun x => (q/ (4 * π * 𝓕.ε₀))• ‖x - r₀‖⁻¹)
      (((IsDistBounded.inv_shift _).const_mul_fun _))) :=
```

## 10. Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_vectorPotential

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/OneDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- cross_domain_score: `7.70`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle, Electromagnetism.DistElectromagneticPotential.vectorPotential
  - Particles: Electromagnetism.DistElectromagneticPotential.oneDimPointParticle
  - Relativity: Lorentz.Vector.spatialCLM
  - SpaceAndTime: Space.constantTime_apply, Space.distOfFunction_vector_eval

```lean
@[simp]
lemma oneDimPointParticle_vectorPotential (𝓕 : FreeSpace) (q : ℝ) (r₀ : Space 1) :
    (oneDimPointParticle 𝓕 q r₀).vectorPotential 𝓕.c = 0 :=
```

## 11. Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_vectorPotential

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/ThreeDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- cross_domain_score: `7.70`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle, Electromagnetism.DistElectromagneticPotential.vectorPotential
  - Particles: Electromagnetism.DistElectromagneticPotential.threeDimPointParticle
  - Relativity: Lorentz.Vector.spatialCLM
  - SpaceAndTime: Space.constantTime_apply, Space.distOfFunction_vector_eval

```lean
@[simp]
lemma threeDimPointParticle_vectorPotential (𝓕 : FreeSpace) (q : ℝ) (r₀ : Space 3) :
    (threeDimPointParticle 𝓕 q r₀).vectorPotential 𝓕.c = 0 :=
```

## 12. Electromagnetism.DistElectromagneticPotential.oneDimPointParticleCurrentDensity_currentDensity

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/OneDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- cross_domain_score: `7.60`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential.oneDimPointParticleCurrentDensity, Electromagnetism.DistLorentzCurrentDensity.currentDensity
  - Particles: Electromagnetism.DistElectromagneticPotential.oneDimPointParticleCurrentDensity
  - Relativity: Electromagnetism.DistLorentzCurrentDensity.currentDensity, Lorentz.Vector.spatialCLM
  - SpaceAndTime: Space.constantTime_apply

```lean
@[simp]
lemma oneDimPointParticleCurrentDensity_currentDensity (c : SpeedOfLight) (q : ℝ) (r₀ : Space 1) :
    (oneDimPointParticleCurrentDensity c q r₀).currentDensity c = 0 :=
```

## 13. Electromagnetism.DistElectromagneticPotential.threeDimPointParticleCurrentDensity_currentDensity

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/ThreeDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, Relativity, SpaceAndTime`
- cross_domain_score: `7.60`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential.threeDimPointParticleCurrentDensity, Electromagnetism.DistLorentzCurrentDensity.currentDensity
  - Particles: Electromagnetism.DistElectromagneticPotential.threeDimPointParticleCurrentDensity
  - Relativity: Electromagnetism.DistLorentzCurrentDensity.currentDensity, Lorentz.Vector.spatialCLM
  - SpaceAndTime: Space.constantTime_apply

```lean
@[simp]
lemma threeDimPointParticleCurrentDensity_currentDensity (c : SpeedOfLight) (q : ℝ) (r₀ : Space 3) :
    (threeDimPointParticleCurrentDensity c q r₀).currentDensity c = 0 :=
```

## 14. complexLorentzTensor.complexLorentzTensor.basis_contr

- split: `train`
- file: `Physlib/Relativity/Tensors/ComplexTensor/Basic.lean`
- primary_domain: `Relativity`
- domains: `Mathematics, Particles, Relativity`
- used_premise_domains: `Mathematics, Particles, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Mathematics: complexLorentzTensor.Color, complexLorentzTensor.Color.upL, complexLorentzTensor.Color.downL, complexLorentzTensor.Color.upR, complexLorentzTensor.Color.downR, complexLorentzTensor.Color.up, complexLorentzTensor.Color.down
  - Particles: Fermion.leftAltContraction_basis, Fermion.altLeftContraction_basis, Fermion.rightAltContraction_basis, Fermion.altRightContraction_basis
  - Relativity: complexLorentzTensor.Color, complexLorentzTensor.Color.upL, complexLorentzTensor.Color.downL, complexLorentzTensor.Color.upR, complexLorentzTensor.Color.downR, complexLorentzTensor.Color.up, Lorentz.contrCoContraction_basis, complexLorentzTensor.Color.down

```lean
lemma basis_contr (c : complexLorentzTensor.Color) (i : Fin (complexLorentzTensor.repDim c))
    (j : Fin (complexLorentzTensor.repDim (complexLorentzTensor.τ c))) :
    complexLorentzTensor.castToField
    ((complexLorentzTensor.contr.app {as := c}).hom
    (complexLorentzTensor.basis c i ⊗ₜ complexLorentzTensor.basis (complexLorentzTensor.τ c) j)) =
    if i.val = j.val then 1 else 0 :=
```

## 15. complexLorentzTensor.contr_basis_ratComplexNum

- split: `train`
- file: `Physlib/Relativity/Tensors/ComplexTensor/OfRat.lean`
- primary_domain: `Relativity`
- domains: `Mathematics, Particles, Relativity`
- used_premise_domains: `Mathematics, Particles, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Mathematics: complexLorentzTensor.Color, complexLorentzTensor.Color.upL, complexLorentzTensor.Color.downL, complexLorentzTensor.Color.upR, complexLorentzTensor.Color.downR, complexLorentzTensor.Color.up, complexLorentzTensor.Color.down
  - Particles: Fermion.leftBasis, Fermion.altLeftBasis, Fermion.leftAltContraction_basis, Fermion.altLeftContraction_basis, Fermion.rightBasis, Fermion.altRightBasis, Fermion.rightAltContraction_basis
  - Relativity: complexLorentzTensor.Color, complexLorentzTensor.Color.upL, complexLorentzTensor.Color.downL, complexLorentzTensor.Color.upR, complexLorentzTensor.Color.downR, complexLorentzTensor.Color.up, Lorentz.complexContrBasisFin4, Lorentz.complexCoBasisFin4

```lean
lemma contr_basis_ratComplexNum {c : complexLorentzTensor.Color}
    (i : Fin (complexLorentzTensor.repDim c))
    (j : Fin (complexLorentzTensor.repDim (complexLorentzTensor.τ c))) :
    complexLorentzTensor.castToField
      ((complexLorentzTensor.contr.app (Discrete.mk c)).hom
      (complexLorentzTensor.basis c i ⊗ₜ
      complexLorentzTensor.basis (complexLorentzTensor.τ c) j))
      = toComplexNum (if i.val = j.val then 1 else 0) :=
```

## 16. Distribution.fderivD_const

- split: `train`
- file: `Physlib/Mathematics/Distribution/Basic.lean`
- primary_domain: `Mathematics`
- domains: `Mathematics, QuantumMechanics, SpaceAndTime`
- used_premise_domains: `QuantumMechanics, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - QuantumMechanics: SchwartzMap.evalCLM_apply_apply, SchwartzMap.fderivCLM_apply, SchwartzMap.evalCLM, SchwartzMap.fderivCLM, SchwartzMap.integrable
  - SpaceAndTime: MeasureTheory.MeasureSpace.volume

```lean
@[simp]
lemma fderivD_const [hμ : Measure.IsAddHaarMeasure (volume (α := E))]
    [FiniteDimensional ℝ E] (c : F) :
    fderivD ℝ (const ℝ E c) = 0 :=
```

## 17. SpaceTime.deriv_equivariant

- split: `train`
- file: `Physlib/SpaceAndTime/SpaceTime/Derivatives.lean`
- primary_domain: `SpaceAndTime`
- domains: `Mathematics, Relativity, SpaceAndTime`
- used_premise_domains: `Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Mathematics: TensorSpecies.Tensorial.actionCLM, TensorSpecies.Tensorial.actionCLM_apply
  - Relativity: LorentzGroup, Lorentz.Vector.actionCLM

```lean
lemma deriv_equivariant (f : SpaceTime d → M) (Λ : LorentzGroup d) (x : SpaceTime d)
    (hf : Differentiable ℝ f) (μ : Fin 1 ⊕ Fin d) :
    ∂_ μ (fun x => Λ • f (Λ⁻¹ • x)) x =
    ∑ ν, Λ⁻¹.1 ν μ • Λ • ∂_ ν f (Λ⁻¹ • x) :=
```

## 18. SpaceTime.distDeriv_apply'

- split: `train`
- file: `Physlib/SpaceAndTime/SpaceTime/Derivatives.lean`
- primary_domain: `SpaceAndTime`
- domains: `QuantumMechanics, Relativity, SpaceAndTime`
- used_premise_domains: `QuantumMechanics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - QuantumMechanics: SchwartzMap.evalCLM, SchwartzMap.fderivCLM
  - Relativity: Lorentz.Vector.basis

```lean
lemma distDeriv_apply' {M d} [NormedAddCommGroup M] [NormedSpace ℝ M]
    (μ : Fin 1 ⊕ Fin d) (f : (SpaceTime d) →d[ℝ] M) (ε : 𝓢(SpaceTime d, ℝ)) :
    distDeriv μ f ε =
    - f ((SchwartzMap.evalCLM ℝ (SpaceTime d) ℝ (Lorentz.Vector.basis μ))
    ((fderivCLM ℝ (SpaceTime d) ℝ) ε)) :=
```

## 19. SpaceTime.distDeriv_commute

- split: `train`
- file: `Physlib/SpaceAndTime/SpaceTime/Derivatives.lean`
- primary_domain: `SpaceAndTime`
- domains: `QuantumMechanics, Relativity, SpaceAndTime`
- used_premise_domains: `QuantumMechanics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - QuantumMechanics: SchwartzMap.smooth
  - Relativity: Lorentz.Vector.basis

```lean
lemma distDeriv_commute {M d} [NormedAddCommGroup M] [NormedSpace ℝ M]
    (μ ν : Fin 1 ⊕ Fin d) (f : (SpaceTime d) →d[ℝ] M) :
    distDeriv μ (distDeriv ν f) = distDeriv ν (distDeriv μ f) :=
```

## 20. SpaceTime.distDeriv_comp_lorentz_action

- split: `train`
- file: `Physlib/SpaceAndTime/SpaceTime/Derivatives.lean`
- primary_domain: `SpaceAndTime`
- domains: `QuantumMechanics, Relativity, SpaceAndTime`
- used_premise_domains: `QuantumMechanics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - QuantumMechanics: SchwartzMap.sum_apply, SchwartzMap.differentiable
  - Relativity: LorentzGroup

```lean
lemma distDeriv_comp_lorentz_action {μ : Fin 1 ⊕ Fin d} (Λ : LorentzGroup d)
    (f : (SpaceTime d) →d[ℝ] M) :
    distDeriv μ (Λ • f) = ∑ ν, Λ⁻¹.1 ν μ • (Λ • distDeriv ν f) :=
```

## 21. SpaceTime.tensorDeriv_equivariant

- split: `train`
- file: `Physlib/SpaceAndTime/SpaceTime/Derivatives.lean`
- primary_domain: `SpaceAndTime`
- domains: `Mathematics, Relativity, SpaceAndTime`
- used_premise_domains: `Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Mathematics: TensorSpecies.Tensorial.smul_prod, TensorSpecies.Tensorial.smulLinearMap, TensorSpecies.Tensorial.smulLinearMap_apply
  - Relativity: LorentzGroup, Lorentz.CoVector.smul_basis

```lean
lemma tensorDeriv_equivariant (f : SpaceTime d → M) (Λ : LorentzGroup d) (x : SpaceTime d)
    (hf : Differentiable ℝ f) :
    tensorDeriv (fun x => Λ • f (Λ⁻¹ • x)) x =
    Λ • tensorDeriv f (Λ⁻¹ • x) :=
```

## 22. SpaceTime.tensorDeriv_toTensor_basis_repr

- split: `train`
- file: `Physlib/SpaceAndTime/SpaceTime/Derivatives.lean`
- primary_domain: `SpaceAndTime`
- domains: `Mathematics, Relativity, SpaceAndTime`
- used_premise_domains: `Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Mathematics: TensorSpecies.Tensor.ComponentIdx, realLorentzTensor.Color.down, TensorSpecies.Tensor.basis, TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensor.ComponentIdx.prod, TensorSpecies.Tensorial.toTensor_tprod, TensorSpecies.Tensor.prodT_basis_repr_apply
  - Relativity: realLorentzTensor.Color.down, Lorentz.CoVector.indexEquiv, Lorentz.CoVector.toTensor_basis_eq_tensor_basis

```lean
lemma tensorDeriv_toTensor_basis_repr
    {f : SpaceTime d → M}
    (hf : Differentiable ℝ f) (x : SpaceTime d)
    (b : Tensor.ComponentIdx (Fin.append ![realLorentzTensor.Color.down] c)) :
    (Tensor.basis _).repr (Tensorial.toTensor (tensorDeriv f x)) b =
    ∂_ (Lorentz.CoVector.indexEquiv (ComponentIdx.prod b).1)
      (fun x => (Tensor.basis _).repr (Tensorial.toTensor (f x))
        (ComponentIdx.prod b).2) x :=
```

## 23. SpaceTime.tensorDeriv_eq_sum_tensor_basis

- split: `train`
- file: `Physlib/SpaceAndTime/SpaceTime/Derivatives.lean`
- primary_domain: `SpaceAndTime`
- domains: `Mathematics, Relativity, SpaceAndTime`
- used_premise_domains: `Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Mathematics: TensorSpecies.Tensor.ComponentIdx.prod, TensorSpecies.Tensor.basis, TensorSpecies.Tensorial.toTensor
  - Relativity: Lorentz.CoVector.indexEquiv

```lean
lemma tensorDeriv_eq_sum_tensor_basis
    {f : SpaceTime d → M} (hf : Differentiable ℝ f) (x : SpaceTime d) :
    tensorDeriv f x = ∑ b, ∂_ (CoVector.indexEquiv (ComponentIdx.prod b).1)
      (fun x => (Tensor.basis _).repr (toTensor (f x)) (ComponentIdx.prod b).2) x •
    toTensor.symm (Tensor.basis _ b) :=
```

## 24. SpaceTime.distTensorDeriv_equivariant

- split: `train`
- file: `Physlib/SpaceAndTime/SpaceTime/Derivatives.lean`
- primary_domain: `SpaceAndTime`
- domains: `Mathematics, Relativity, SpaceAndTime`
- used_premise_domains: `Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Mathematics: TensorSpecies.Tensorial, TensorSpecies.Tensorial.smul_prod, TensorSpecies.Tensorial.smulLinearMap, TensorSpecies.Tensorial.smulLinearMap_apply
  - Relativity: realLorentzTensor, LorentzGroup, Lorentz.CoVector.smul_basis

```lean
lemma distTensorDeriv_equivariant {M : Type} [NormedAddCommGroup M]
    [InnerProductSpace ℝ M] [FiniteDimensional ℝ M] [(realLorentzTensor d).Tensorial c M]
    (f : (SpaceTime d) →d[ℝ] M) (Λ : LorentzGroup d) :
    distTensorDeriv (Λ • f) = Λ • distTensorDeriv f :=
```

## 25. SpaceTime.distTensorDeriv_toTensor_basis_repr

- split: `train`
- file: `Physlib/SpaceAndTime/SpaceTime/Derivatives.lean`
- primary_domain: `SpaceAndTime`
- domains: `Mathematics, Relativity, SpaceAndTime`
- used_premise_domains: `Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Mathematics: TensorSpecies.Tensorial, TensorSpecies.Tensor.ComponentIdx, realLorentzTensor.Color.down, TensorSpecies.Tensor.basis, TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensor.ComponentIdx.prod, TensorSpecies.Tensorial.toTensor_tprod, TensorSpecies.Tensor.prodT_basis_repr_apply
  - Relativity: realLorentzTensor, realLorentzTensor.Color.down, Lorentz.CoVector.indexEquiv, Lorentz.CoVector.toTensor_basis_eq_tensor_basis

```lean
lemma distTensorDeriv_toTensor_basis_repr {M : Type} [NormedAddCommGroup M]
    [InnerProductSpace ℝ M] [FiniteDimensional ℝ M] [(realLorentzTensor d).Tensorial c M]
    {f : (SpaceTime d) →d[ℝ] M}
    (ε : 𝓢(SpaceTime d, ℝ))
    (b : Tensor.ComponentIdx (Fin.append ![realLorentzTensor.Color.down] c)) :
    (Tensor.basis _).repr (Tensorial.toTensor (distTensorDeriv f ε)) b =
    (Tensor.basis _).repr (Tensorial.toTensor
    (distDeriv (Lorentz.CoVector.indexEquiv (ComponentIdx.prod b).1) f ε))
    (ComponentIdx.prod b).2 :=
```

## 26. SpaceTime.distTimeSlice_distDeriv_inl

- split: `train`
- file: `Physlib/SpaceAndTime/SpaceTime/TimeSlice.lean`
- primary_domain: `SpaceAndTime`
- domains: `QuantumMechanics, Relativity, SpaceAndTime`
- used_premise_domains: `QuantumMechanics, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - QuantumMechanics: SchwartzMap.differentiable
  - Relativity: Lorentz.Vector.basis
  - SpaceAndTime: Space.distTimeDeriv, Space.distTimeDeriv_apply, SpaceTime.toTimeAndSpace_fderiv, SpaceTime.toTimeAndSpace_basis_inl'

```lean
lemma distTimeSlice_distDeriv_inl {M d} [NormedAddCommGroup M] [NormedSpace ℝ M]
    {c : SpeedOfLight}
    (f : (SpaceTime d) →d[ℝ] M) :
    distTimeSlice c (distDeriv (Sum.inl 0) f) =
    (1/c.val) • Space.distTimeDeriv (distTimeSlice c f) :=
```

## 27. SpaceTime.distTimeSlice_distDeriv_inr

- split: `train`
- file: `Physlib/SpaceAndTime/SpaceTime/TimeSlice.lean`
- primary_domain: `SpaceAndTime`
- domains: `QuantumMechanics, Relativity, SpaceAndTime`
- used_premise_domains: `QuantumMechanics, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - QuantumMechanics: SchwartzMap.differentiable
  - Relativity: Lorentz.Vector.basis
  - SpaceAndTime: Space.distSpaceDeriv, Space.distSpaceDeriv_apply, Space.basis, SpaceTime.toTimeAndSpace_fderiv, SpaceTime.toTimeAndSpace_basis_inr

```lean
lemma distTimeSlice_distDeriv_inr {M d} [NormedAddCommGroup M] [NormedSpace ℝ M]
    {c : SpeedOfLight}
    (i : Fin d) (f : (SpaceTime d) →d[ℝ] M) :
    distTimeSlice c (distDeriv (Sum.inr i) f) =
    Space.distSpaceDeriv i (distTimeSlice c f) :=
```

## 28. Electromagnetism.ElectromagneticPotential.gradFreeCurrentPotential_eq_tensor

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/Lagrangian.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.LorentzCurrentDensity, Electromagnetism.ElectromagneticPotential.gradFreeCurrentPotential_eq_sum_basis
  - Mathematics: TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensor.permT, TensorSpecies.Tensor.PermCond
  - Relativity: Electromagnetism.LorentzCurrentDensity, Lorentz.Vector, Lorentz.Vector.basis_repr_apply, Lorentz.Vector.apply_sum

```lean
lemma gradFreeCurrentPotential_eq_tensor {d} (A : ElectromagneticPotential d)
    (hA : ContDiff ℝ ∞ A) (J : LorentzCurrentDensity d)
    (hJ : ContDiff ℝ ∞ J) (x : SpaceTime d) (ν : Fin 1 ⊕ Fin d) :
    A.gradFreeCurrentPotential J x ν = η ν ν * ((Tensorial.toTensor (M := Lorentz.Vector d)).symm
    (permT id (PermCond.auto) {J x | ν'}ᵀ)) ν :=
```

## 29. Electromagnetism.ElectromagneticPotential.gradLagrangian_eq_electricField_magneticField

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/Lagrangian.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.LorentzCurrentDensity, Electromagnetism.ElectromagneticPotential.electricField, Electromagnetism.ElectromagneticPotential.magneticFieldMatrix, Electromagnetism.ElectromagneticPotential.gradLagrangian_eq_kineticTerm_sub, Electromagnetism.ElectromagneticPotential.gradKineticTerm_eq_electric_magnetic, Electromagnetism.ElectromagneticPotential.gradFreeCurrentPotential_eq_chargeDensity_currentDensity
  - Relativity: Electromagnetism.LorentzCurrentDensity, Lorentz.Vector.basis
  - SpaceAndTime: Space.div, Electromagnetism.FreeSpace.c_sq

```lean
lemma gradLagrangian_eq_electricField_magneticField {𝓕 : FreeSpace}
    (A : ElectromagneticPotential d)
    (hA : ContDiff ℝ ∞ A) (J : LorentzCurrentDensity d)
    (hJ : ContDiff ℝ ∞ J) (x : SpaceTime d) :
    A.gradLagrangian 𝓕 J x = (1 / (𝓕.μ₀ * 𝓕.c.val) *
        Space.div (electricField 𝓕.c A ((time 𝓕.c) x)) (space x) +
        - 𝓕.c * J.chargeDensity 𝓕.c (x.time 𝓕.c) x.space) •
      Lorentz.Vector.basis (Sum.inl 0) +
    ∑ i, (𝓕.μ₀⁻¹ * (𝓕.ε₀ * 𝓕.μ₀ * ∂ₜ (electricField 𝓕.c A · x.space) ((time 𝓕.c) x) i -
      ∑ j, ∂[j] (magneticFieldMatrix 𝓕.c A (x.time 𝓕.c) · (j, i)) x.space) +
      J.currentDensity 𝓕.c (x.time 𝓕.c) x.space i) •
        Lorentz.Vector.basis (Sum.inr i) :=
```

## 30. Electromagnetism.ElectromagneticPotential.gradLagrangian_eq_tensor

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/Lagrangian.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.LorentzCurrentDensity, Electromagnetism.ElectromagneticPotential.gradLagrangian_eq_kineticTerm_sub, Electromagnetism.ElectromagneticPotential.gradKineticTerm_eq_tensorDeriv, Electromagnetism.ElectromagneticPotential.gradFreeCurrentPotential_eq_tensor
  - Mathematics: TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensor.permT, TensorSpecies.Tensor.PermCond, TensorSpecies.Tensor.permT_permT, TensorSpecies.Tensor.permT_id_self, TensorSpecies.Tensor.permT_congr_eq_id
  - Relativity: Electromagnetism.LorentzCurrentDensity, Lorentz.Vector, Lorentz.Vector.apply_sub, Lorentz.Vector.apply_add, Lorentz.Vector.apply_smul, Lorentz.Vector.neg_apply

```lean
lemma gradLagrangian_eq_tensor {𝓕 : FreeSpace}
    (A : ElectromagneticPotential d)
    (hA : ContDiff ℝ ∞ A) (J : LorentzCurrentDensity d)
    (hJ : ContDiff ℝ ∞ J) (x : SpaceTime d) (ν : Fin 1 ⊕ Fin d) :
    A.gradLagrangian 𝓕 J x ν =
    η ν ν * ((Tensorial.toTensor (M := Lorentz.Vector d)).symm
    (permT id (PermCond.auto) {((1/ 𝓕.μ₀ : ℝ) • tensorDeriv A.toFieldStrength x | κ κ ν') +
    - (J x | ν')}ᵀ)) ν :=
```

## 31. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.gradFreeCurrentPotential_eq_tensor

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/Lagrangian.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistLorentzCurrentDensity, Electromagnetism.DistElectromagneticPotential.gradFreeCurrentPotential, Electromagnetism.DistElectromagneticPotential.gradFreeCurrentPotential_eq_sum_basis
  - Mathematics: TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensor.permT, TensorSpecies.Tensor.PermCond
  - Relativity: Electromagnetism.DistLorentzCurrentDensity, Lorentz.Vector, Lorentz.Vector.basis_repr_apply, Lorentz.Vector.apply_sum

```lean
lemma gradFreeCurrentPotential_eq_tensor {d}
    (J : DistLorentzCurrentDensity d) (ε : 𝓢(SpaceTime d, ℝ))
    (ν : Fin 1 ⊕ Fin d) :
    gradFreeCurrentPotential J ε ν = η ν ν * ((Tensorial.toTensor (M := Lorentz.Vector d)).symm
    (permT id (PermCond.auto) {J ε | ν'}ᵀ)) ν:=
```

## 32. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.gradLagrangian_sum_inl_0

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/Lagrangian.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistLorentzCurrentDensity, Electromagnetism.DistElectromagneticPotential.gradLagrangian, Electromagnetism.DistElectromagneticPotential.gradKineticTerm_sum_inl_eq, Electromagnetism.DistElectromagneticPotential.gradFreeCurrentPotential_sum_inl_0
  - Relativity: Electromagnetism.DistLorentzCurrentDensity
  - SpaceAndTime: Space.distSpaceDiv

```lean
lemma gradLagrangian_sum_inl_0 {𝓕 : FreeSpace}
    (A : DistElectromagneticPotential d) (J : DistLorentzCurrentDensity d)
    (ε : 𝓢(SpaceTime d, ℝ)) :
    A.gradLagrangian 𝓕 J ε (Sum.inl 0) =
    (1/(𝓕.μ₀ * 𝓕.c) * (distTimeSlice 𝓕.c).symm (Space.distSpaceDiv (A.electricField 𝓕.c)) ε)
    - 𝓕.c * (distTimeSlice 𝓕.c).symm (J.chargeDensity 𝓕.c) ε :=
```

## 33. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.gradLagrangian_sum_inr_i

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/Lagrangian.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistLorentzCurrentDensity, Electromagnetism.DistElectromagneticPotential.gradLagrangian, Electromagnetism.DistElectromagneticPotential.gradKineticTerm_sum_inr_eq, Electromagnetism.DistElectromagneticPotential.gradFreeCurrentPotential_sum_inr_i
  - Relativity: Electromagnetism.DistLorentzCurrentDensity
  - SpaceAndTime: Space.distTimeDeriv, Space.distSpaceDeriv

```lean
lemma gradLagrangian_sum_inr_i {𝓕 : FreeSpace}
    (A : DistElectromagneticPotential d) (J : DistLorentzCurrentDensity d)
    (ε : 𝓢(SpaceTime d, ℝ)) (i : Fin d) :
    A.gradLagrangian 𝓕 J ε (Sum.inr i) =
    𝓕.μ₀⁻¹ * (1 / 𝓕.c ^ 2 *
      (distTimeSlice 𝓕.c).symm (Space.distTimeDeriv (A.electricField 𝓕.c)) ε i -
      ∑ j, ((PiLp.basisFun 2 ℝ (Fin d)).tensorProduct (PiLp.basisFun 2 ℝ (Fin d))).repr
        ((distTimeSlice 𝓕.c).symm (Space.distSpaceDeriv j (A.magneticFieldMatrix 𝓕.c)) ε) (j, i)) +
    (distTimeSlice 𝓕.c).symm (J.currentDensity 𝓕.c) ε i :=
```

## 34. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.gradLagrangian_eq_tensor

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/Lagrangian.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistLorentzCurrentDensity, Electromagnetism.DistElectromagneticPotential.gradLagrangian.eq_1, Electromagnetism.DistElectromagneticPotential.gradKineticTerm_eq_distTensorDeriv, Electromagnetism.DistElectromagneticPotential.gradFreeCurrentPotential_eq_tensor
  - Mathematics: TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensor.permT, TensorSpecies.Tensor.PermCond, TensorSpecies.Tensor.permT_permT, TensorSpecies.Tensor.permT_id_self, TensorSpecies.Tensor.permT_congr_eq_id
  - Relativity: Electromagnetism.DistLorentzCurrentDensity, Lorentz.Vector, Lorentz.Vector.apply_sub, Lorentz.Vector.apply_add, Lorentz.Vector.apply_smul, Lorentz.Vector.neg_apply

```lean
lemma gradLagrangian_eq_tensor {𝓕 : FreeSpace}
    (A : DistElectromagneticPotential d) (J : DistLorentzCurrentDensity d)
    (ε : 𝓢(SpaceTime d, ℝ)) (ν : Fin 1 ⊕ Fin d) :
    A.gradLagrangian 𝓕 J ε ν =
    η ν ν * ((Tensorial.toTensor (M := Lorentz.Vector d)).symm
    (permT id (PermCond.auto) {((1/ 𝓕.μ₀ : ℝ) • (distTensorDeriv A.fieldStrength ε) | κ κ ν') +
    - (J ε | ν')}ᵀ)) ν :=
```

## 35. Electromagnetism.ElectromagneticPotential.isExtrema_iff_tensors

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/IsExtrema.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.LorentzCurrentDensity, Electromagnetism.ElectromagneticPotential.IsExtrema, Electromagnetism.ElectromagneticPotential.gradLagrangian, Electromagnetism.ElectromagneticPotential.gradLagrangian_eq_tensor
  - Mathematics: TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensor.permT, TensorSpecies.Tensor.PermCond, TensorSpecies.Tensor.permT_permT, TensorSpecies.Tensor.permT_eq_zero_iff
  - Relativity: Electromagnetism.LorentzCurrentDensity, Lorentz.Vector, Lorentz.Vector.apply_add, Lorentz.Vector.apply_smul, Lorentz.Vector.neg_apply, minkowskiMatrix.η_diag_ne_zero, Lorentz.Vector.zero_apply

```lean
lemma isExtrema_iff_tensors {𝓕 : FreeSpace}
    (A : ElectromagneticPotential d)
    (hA : ContDiff ℝ ∞ A) (J : LorentzCurrentDensity d) (hJ : ContDiff ℝ ∞ J) :
    IsExtrema 𝓕 A J ↔ ∀ x,
    {((1/ 𝓕.μ₀ : ℝ) • tensorDeriv A.toFieldStrength x | κ κ ν') + - (J x | ν')}ᵀ = 0 :=
```

## 36. Electromagnetism.ElectromagneticPotential.isExtrema_lorentzGroup_apply_iff

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/IsExtrema.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.LorentzCurrentDensity, Electromagnetism.ElectromagneticPotential.IsExtrema, Electromagnetism.ElectromagneticPotential.isExtrema_iff_tensors, Electromagnetism.ElectromagneticPotential.toFieldStrength, Electromagnetism.ElectromagneticPotential.toFieldStrength_equivariant, Electromagnetism.ElectromagneticPotential.toFieldStrength_differentiable
  - Mathematics: TensorSpecies.Tensorial.toTensor_smul, TensorSpecies.Tensor.actionT_smul, TensorSpecies.Tensor.contrT_equivariant, TensorSpecies.Tensor.permT_equivariant, TensorSpecies.Tensor.actionT_neg, TensorSpecies.Tensor.actionT_add
  - Relativity: Electromagnetism.LorentzCurrentDensity, LorentzGroup, Lorentz.Vector.actionCLM

```lean
lemma isExtrema_lorentzGroup_apply_iff {𝓕 : FreeSpace}
    (A : ElectromagneticPotential d)
    (hA : ContDiff ℝ ∞ A) (J : LorentzCurrentDensity d) (hJ : ContDiff ℝ ∞ J)
    (Λ : LorentzGroup d) :
    IsExtrema 𝓕 (Λ • A) (fun x => Λ • J (Λ⁻¹ • x)) ↔
    IsExtrema 𝓕 A J :=
```

## 37. Electromagnetism.ElectromagneticPotential.isExtrema_iff_gauss_ampere_magneticFieldMatrix

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/IsExtrema.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.LorentzCurrentDensity, Electromagnetism.ElectromagneticPotential.IsExtrema, Electromagnetism.ElectromagneticPotential.isExtrema_iff_gradLagrangian, Electromagnetism.ElectromagneticPotential.gradLagrangian_eq_electricField_magneticField, Electromagnetism.FreeSpace.c_sq
  - Relativity: Electromagnetism.LorentzCurrentDensity, Lorentz.Vector.sum_inl_inr_basis_eq_zero_iff
  - SpaceAndTime: Electromagnetism.FreeSpace.c_sq

```lean
lemma isExtrema_iff_gauss_ampere_magneticFieldMatrix {d} {𝓕 : FreeSpace}
    {A : ElectromagneticPotential d}
    (hA : ContDiff ℝ ∞ A) (J : LorentzCurrentDensity d)
    (hJ : ContDiff ℝ ∞ J) :
    IsExtrema 𝓕 A J ↔ ∀ t, ∀ x, (∇ ⬝ (A.electricField 𝓕.c t)) x = J.chargeDensity 𝓕.c t x / 𝓕.ε₀
    ∧ ∀ i, 𝓕.μ₀ * 𝓕.ε₀ * ∂ₜ (fun t => A.electricField 𝓕.c t x) t i =
    ∑ j, ∂[j] (A.magneticFieldMatrix 𝓕.c t · (j, i)) x - 𝓕.μ₀ * J.currentDensity 𝓕.c t x i :=
```

## 38. Electromagnetism.ElectromagneticPotential.time_deriv_time_deriv_magneticFieldMatrix_of_isExtrema

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/IsExtrema.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.FreeSpace, Electromagnetism.LorentzCurrentDensity, Electromagnetism.ElectromagneticPotential.IsExtrema, Electromagnetism.ElectromagneticPotential.time_deriv_time_deriv_magneticFieldMatrix, Electromagnetism.ElectromagneticPotential.time_deriv_electricField_of_isExtrema, Electromagnetism.ElectromagneticPotential.magneticFieldMatrix_space_contDiff, Electromagnetism.LorentzCurrentDensity.currentDensity_apply_differentiable_space
  - Relativity: Electromagnetism.LorentzCurrentDensity, Electromagnetism.LorentzCurrentDensity.currentDensity_apply_differentiable_space
  - SpaceAndTime: Space.deriv_eq_fderiv_basis, Space.deriv_differentiable, Electromagnetism.FreeSpace.c_sq, Space.deriv_commute

```lean
lemma time_deriv_time_deriv_magneticFieldMatrix_of_isExtrema {A : ElectromagneticPotential d}
    {𝓕 : FreeSpace}
    (hA : ContDiff ℝ ∞ A) (J : LorentzCurrentDensity d)
    (hJ : ContDiff ℝ ∞ J) (h : IsExtrema 𝓕 A J)
    (t : Time) (x : Space d) (i j : Fin d) :
    ∂ₜ (∂ₜ (A.magneticFieldMatrix 𝓕.c · x (i, j))) t =
    𝓕.c ^ 2 * ∑ k, ∂[k] (∂[k] (A.magneticFieldMatrix 𝓕.c t · (i, j))) x +
    𝓕.ε₀⁻¹ * (∂[j] (J.currentDensity 𝓕.c t · i) x - ∂[i] (J.currentDensity 𝓕.c t · j) x) :=
```

## 39. Electromagnetism.ElectromagneticPotential.time_deriv_time_deriv_electricField_of_isExtrema

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/IsExtrema.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.FreeSpace, Electromagnetism.LorentzCurrentDensity, Electromagnetism.ElectromagneticPotential.IsExtrema, Electromagnetism.ElectromagneticPotential.magneticFieldMatrix, Electromagnetism.LorentzCurrentDensity.currentDensity, Electromagnetism.ElectromagneticPotential.electricField_differentiable_time, Electromagnetism.ElectromagneticPotential.time_deriv_electricField_of_isExtrema
  - Relativity: Electromagnetism.LorentzCurrentDensity, Electromagnetism.LorentzCurrentDensity.currentDensity, Electromagnetism.LorentzCurrentDensity.currentDensity_apply_differentiable_time, Electromagnetism.LorentzCurrentDensity.chargeDensity, Electromagnetism.LorentzCurrentDensity.chargeDensity_differentiable_space
  - SpaceAndTime: Space.deriv, Space.space_deriv_differentiable_time, Space.time_deriv_comm_space_deriv, Space.deriv_eq_fderiv_basis, Space.deriv_differentiable, Space.deriv_commute, Electromagnetism.FreeSpace.c_sq

```lean
lemma time_deriv_time_deriv_electricField_of_isExtrema {A : ElectromagneticPotential d}
    {𝓕 : FreeSpace}
    (hA : ContDiff ℝ ∞ A) (J : LorentzCurrentDensity d)
    (hJ : ContDiff ℝ ∞ J) (h : IsExtrema 𝓕 A J)
    (t : Time) (x : Space d) (i : Fin d) :
    ∂ₜ (∂ₜ (A.electricField 𝓕.c · x i)) t =
      𝓕.c ^ 2 * ∑ j, (∂[j] (∂[j] (A.electricField 𝓕.c t · i)) x) -
      𝓕.c ^ 2 / 𝓕.ε₀ * ∂[i] (J.chargeDensity 𝓕.c t ·) x -
      𝓕.c ^ 2 * 𝓕.μ₀ * ∂ₜ (J.currentDensity 𝓕.c · x i) t :=
```

## 40. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.isExtrema_iff_vectorPotential

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/IsExtrema.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistLorentzCurrentDensity, Electromagnetism.DistElectromagneticPotential.IsExtrema, Electromagnetism.DistElectromagneticPotential.isExtrema_iff_space_time, Electromagnetism.DistElectromagneticPotential.magneticFieldMatrix_distSpaceDeriv_basis_repr_eq_vector_potential
  - Relativity: Electromagnetism.DistLorentzCurrentDensity
  - SpaceAndTime: Space.distSpaceDiv, Space.distTimeDeriv, Space.distSpaceDeriv

```lean
lemma isExtrema_iff_vectorPotential {𝓕 : FreeSpace}
    (A : DistElectromagneticPotential d)
    (J : DistLorentzCurrentDensity d) :
    IsExtrema 𝓕 A J ↔
      (∀ ε, distSpaceDiv (A.electricField 𝓕.c) ε = (1/𝓕.ε₀) * (J.chargeDensity 𝓕.c) ε) ∧
      (∀ ε i, 𝓕.μ₀ * 𝓕.ε₀ * distTimeDeriv (A.electricField 𝓕.c) ε i -
      (∑ x, -(distSpaceDeriv x (distSpaceDeriv x (A.vectorPotential 𝓕.c)) ε i
        - distSpaceDeriv x (distSpaceDeriv i (A.vectorPotential 𝓕.c)) ε x)) +
      𝓕.μ₀ * J.currentDensity 𝓕.c ε i = 0) :=
```

## 41. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.isExterma_iff_tensor

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/IsExtrema.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistLorentzCurrentDensity, Electromagnetism.DistElectromagneticPotential.IsExtrema, Electromagnetism.DistElectromagneticPotential.gradLagrangian, Electromagnetism.DistElectromagneticPotential.gradLagrangian_eq_tensor
  - Mathematics: TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensor.permT, TensorSpecies.Tensor.PermCond, TensorSpecies.Tensor.permT_eq_zero_iff
  - Relativity: Electromagnetism.DistLorentzCurrentDensity, Lorentz.Vector, minkowskiMatrix, minkowskiMatrix.η_diag_ne_zero

```lean
lemma isExterma_iff_tensor {𝓕 : FreeSpace}
    (A : DistElectromagneticPotential d)
    (J : DistLorentzCurrentDensity d) :
    IsExtrema 𝓕 A J ↔ ∀ ε,
    {((1/ 𝓕.μ₀ : ℝ) • distTensorDeriv A.fieldStrength ε | κ κ ν') + - (J ε | ν')}ᵀ = 0 :=
```

## 42. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.isExterma_equivariant

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/IsExtrema.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistLorentzCurrentDensity, Electromagnetism.DistElectromagneticPotential.IsExtrema, Electromagnetism.DistElectromagneticPotential.isExterma_iff_tensor, Electromagnetism.DistElectromagneticPotential.fieldStrength_equivariant
  - Mathematics: TensorSpecies.Tensorial.toTensor_smul, TensorSpecies.Tensor.actionT_smul, TensorSpecies.Tensor.contrT_equivariant, TensorSpecies.Tensor.permT_equivariant, TensorSpecies.Tensor.actionT_neg, TensorSpecies.Tensor.actionT_add
  - Relativity: Electromagnetism.DistLorentzCurrentDensity, LorentzGroup

```lean
lemma isExterma_equivariant {𝓕 : FreeSpace}
    (A : DistElectromagneticPotential d)
    (J : DistLorentzCurrentDensity d) (Λ : LorentzGroup d) :
    IsExtrema 𝓕 (Λ • A) (Λ • J) ↔ IsExtrema 𝓕 A J :=
```

## 43. Electromagnetism.ElectromagneticPotential.electricField_apply_x_boost_succ

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/Boosts.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.electricField, Electromagnetism.ElectromagneticPotential.electricField_eq_fieldStrengthMatrix, Electromagnetism.ElectromagneticPotential.fieldStrengthMatrix_equivariant, Electromagnetism.ElectromagneticPotential.fieldStrengthMatrix_inl_inr_eq_electricField, Electromagnetism.ElectromagneticPotential.fieldStrengthMatrix_inr_inr_eq_magneticFieldMatrix
  - Relativity: LorentzGroup.boost, LorentzGroup.γ, LorentzGroup.boost_zero_inr_succ_inr_succ
  - SpaceAndTime: SpaceTime.time_toTimeAndSpace_symm, SpaceTime.space_toTimeAndSpace_symm

```lean
lemma electricField_apply_x_boost_succ {d : ℕ} {c : SpeedOfLight} (β : ℝ) (hβ : |β| < 1)
    (A : ElectromagneticPotential d.succ) (hA : Differentiable ℝ A) (t : Time) (x : Space d.succ)
    (i : Fin d) :
    let Λ := LorentzGroup.boost (d := d.succ) 0 β hβ
    let t' : Time := γ β * (t.val + β /c * x 0)
    let x' : Space d.succ := ⟨fun
      | 0 => γ β * (x 0 + c * β * t.val)
      | ⟨Nat.succ n, ih⟩ => x ⟨Nat.succ n, ih⟩⟩
    electricField c (Λ • A) t x i.succ =
    γ β * (A.electricField c t' x' i.succ + c * β * A.magneticFieldMatrix c t' x' (0, i.succ)) :=
```

## 44. Electromagnetism.ElectromagneticPotential.magneticFieldMatrix_apply_x_boost_zero_succ

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/Boosts.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.magneticFieldMatrix, Electromagnetism.ElectromagneticPotential.magneticFieldMatrix_eq, Electromagnetism.ElectromagneticPotential.fieldStrengthMatrix_equivariant, Electromagnetism.ElectromagneticPotential.fieldStrengthMatrix_inl_inr_eq_electricField, Electromagnetism.ElectromagneticPotential.fieldStrengthMatrix_inr_inr_eq_magneticFieldMatrix
  - Relativity: LorentzGroup.boost, LorentzGroup.γ, LorentzGroup.boost_zero_inr_succ_inr_succ
  - SpaceAndTime: SpaceTime.time_toTimeAndSpace_symm, SpaceTime.space_toTimeAndSpace_symm

```lean
lemma magneticFieldMatrix_apply_x_boost_zero_succ {d : ℕ} {c : SpeedOfLight} (β : ℝ) (hβ : |β| < 1)
    (A : ElectromagneticPotential d.succ) (hA : Differentiable ℝ A) (t : Time) (x : Space d.succ)
    (i : Fin d) :
    let Λ := LorentzGroup.boost (d := d.succ) 0 β hβ
    let t' : Time := γ β * (t.val + β /c * x 0)
    let x' : Space d.succ := ⟨fun
      | 0 => γ β * (x 0 + c * β * t.val)
      | ⟨Nat.succ n, ih⟩ => x ⟨Nat.succ n, ih⟩⟩
    magneticFieldMatrix c (Λ • A) t x (0, i.succ) =
    γ β * (A.magneticFieldMatrix c t' x' (0, i.succ) + β / c * A.electricField c t' x' i.succ) :=
```

## 45. Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_electricField

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/OneDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle, Electromagnetism.DistElectromagneticPotential.electricField, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_scalarPotential, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_vectorPotential
  - Particles: Electromagnetism.DistElectromagneticPotential.oneDimPointParticle, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_scalarPotential, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_vectorPotential
  - SpaceAndTime: Space.constantTime, Space.distOfFunction, Space.IsDistBounded.zpow_smul_repr_self, Space.IsDistBounded.comp_sub_right, Space.distGrad_distOfFunction_norm_zpow, Space.constantTime_distSpaceGrad, Space.distOfFunction_neg, Space.distOfFunction_mul_fun

```lean
lemma oneDimPointParticle_electricField (𝓕 : FreeSpace) (q : ℝ) (r₀ : Space 1) :
    (oneDimPointParticle 𝓕 q r₀).electricField 𝓕.c =
    ((q * 𝓕.μ₀ * 𝓕.c ^ 2) / 2) • constantTime (distOfFunction (fun x : Space 1 =>
      ‖x - r₀‖ ^ (- 1 : ℤ) • basis.repr (x - r₀))
      ((IsDistBounded.zpow_smul_repr_self (- 1 : ℤ) (by omega)).comp_sub_right r₀)) :=
```

## 46. Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_div_electricField

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/OneDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential.oneDimPointParticle, Electromagnetism.DistElectromagneticPotential.electricField, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_electricField
  - Particles: Electromagnetism.DistElectromagneticPotential.oneDimPointParticle, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_electricField
  - SpaceAndTime: Space.distSpaceDiv, Space.constantTime, Space.distDiv_inv_pow_eq_dim, Space.distTranslate, Space.distOfFunction, Space.IsDistBounded.zpow_smul_repr_self, Space.distTranslate_ofFunction, Space.constantTime_distSpaceDiv

```lean
lemma oneDimPointParticle_div_electricField {𝓕} (q : ℝ) (r₀ : Space 1) :
    distSpaceDiv ((oneDimPointParticle 𝓕 q r₀).electricField 𝓕.c) =
    (𝓕.μ₀ * 𝓕.c ^ 2) • constantTime (q • diracDelta ℝ r₀) :=
```

## 47. Electromagnetism.ElectromagneticPotential.electricField_eq_fieldStrengthMatrix

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/ElectricField.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.toFieldStrength_basis_repr_apply_eq_single, Electromagnetism.ElectromagneticPotential.electricField.eq_1, Electromagnetism.ElectromagneticPotential.scalarPotential, Electromagnetism.ElectromagneticPotential.differentiable_component, Electromagnetism.ElectromagneticPotential.vectorPotential.eq_1
  - Relativity: minkowskiMatrix.inl_0_inl_0, minkowskiMatrix.inr_i_inr_i, Lorentz.Vector.fderiv_apply, Lorentz.Vector.differentiable_apply
  - SpaceAndTime: Space.grad_apply, Space.deriv, Space.deriv_eq_fderiv_basis

```lean
lemma electricField_eq_fieldStrengthMatrix {c : SpeedOfLight}
    (A : ElectromagneticPotential d) (t : Time)
    (x : Space d) (i : Fin d) (hA : Differentiable ℝ A) :
    A.electricField c t x i = -
    c * A.fieldStrengthMatrix ((toTimeAndSpace c).symm (t, x)) (Sum.inl 0, Sum.inr i) :=
```

## 48. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.electricField_eq_fieldStrength

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/ElectricField.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistElectromagneticPotential.fieldStrength_basis_repr_eq_single, Electromagnetism.DistElectromagneticPotential.electricField, Electromagnetism.DistElectromagneticPotential.scalarPotential, Electromagnetism.DistElectromagneticPotential.vectorPotential
  - Relativity: Lorentz.Vector.basis, minkowskiMatrix.inl_0_inl_0, minkowskiMatrix.inr_i_inr_i, Lorentz.Vector.temporalCLM, Lorentz.Vector.spatialCLM, Lorentz.Vector.apply_smul
  - SpaceAndTime: Space.distTimeDeriv_apply_CLM, Space.distSpaceGrad_apply, Space.distSpaceDeriv_apply_CLM

```lean
lemma electricField_eq_fieldStrength {d} {c : SpeedOfLight}
    (A : DistElectromagneticPotential d) (ε : 𝓢(Time × Space d, ℝ))
    (i : Fin d) : A.electricField c ε i = - c * (Vector.basis.tensorProduct Vector.basis).repr
      (distTimeSlice c (A.fieldStrength) ε) (Sum.inl 0, Sum.inr i) :=
```

## 49. Electromagnetism.DistElectromagneticPotential.wireCurrentDensity_currentDensity_fst

- split: `train`
- file: `Physlib/Electromagnetism/Current/InfiniteWire.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential.wireCurrentDensity, Electromagnetism.DistLorentzCurrentDensity.currentDensity
  - Relativity: Electromagnetism.DistLorentzCurrentDensity.currentDensity
  - SpaceAndTime: Space.constantTime, Space.constantSliceDist, Space.constantTime_apply, Space.constantSliceDist_apply

```lean
lemma wireCurrentDensity_currentDensity_fst (c : SpeedOfLight) (I : ℝ)
    (η : 𝓢(Time × Space 3, ℝ)) :
    (wireCurrentDensity c I).currentDensity c η 0 =
    (constantTime <|
    constantSliceDist 0 <|
    I • diracDelta ℝ 0) η :=
```

## 50. Electromagnetism.DistElectromagneticPotential.infiniteWire_vectorPotential

- split: `train`
- file: `Physlib/Electromagnetism/Current/InfiniteWire.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential.infiniteWire, Electromagnetism.DistElectromagneticPotential.vectorPotential
  - Relativity: Lorentz.Vector.spatialCLM
  - SpaceAndTime: Space.constantTime, Space.constantSliceDist, Space.distOfFunction, EuclideanSpace.single, Space.constantTime_apply, Space.constantSliceDist_apply, Space.distOfFunction_vector_eval, Space.distOfFunction_eculid_eval

```lean
lemma infiniteWire_vectorPotential (𝓕 : FreeSpace) (I : ℝ) :
    (infiniteWire 𝓕 I).vectorPotential 𝓕.c =
    (constantTime <|
    constantSliceDist 0
    ((- I * 𝓕.μ₀ / (2 * Real.pi)) • distOfFunction (fun (x : Space 2) =>
      Real.log ‖x‖ • EuclideanSpace.single 0 (1 : ℝ))
    (IsDistBounded.log_norm.smul_const _))) :=
```

## 51. Electromagnetism.ElectromagneticPotential.IsPlaneWave.time_deriv_electricField_eq_magneticFieldMatrix

- split: `train`
- file: `Physlib/Electromagnetism/Vacuum/IsPlaneWave.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.IsPlaneWave, Electromagnetism.ElectromagneticPotential.IsExtrema, Electromagnetism.ElectromagneticPotential.time_deriv_electricField_of_isExtrema, Electromagnetism.LorentzCurrentDensity.currentDensity_zero, Electromagnetism.ElectromagneticPotential.IsPlaneWave.magneticFieldMatrix_space_deriv_eq_time_deriv, Electromagnetism.ElectromagneticPotential.magneticFieldMatrix_differentiable_time
  - Relativity: Electromagnetism.LorentzCurrentDensity.currentDensity_zero
  - SpaceAndTime: Space.Direction

```lean
lemma time_deriv_electricField_eq_magneticFieldMatrix {d : ℕ}
    {𝓕 : FreeSpace} {A : ElectromagneticPotential d}
    {s : Direction d} (P : IsPlaneWave 𝓕 A s) (hA : ContDiff ℝ ∞ A)
    (h : IsExtrema 𝓕 A 0)
    (t : Time) (x : Space d) (i : Fin d) :
    ∂ₜ (A.electricField 𝓕.c · x i) t =
    ∂ₜ (fun t => 𝓕.c * ∑ j, A.magneticFieldMatrix 𝓕.c t x (i, j) * s.unit j) t :=
```

## 52. Electromagnetism.ElectromagneticPotential.deriv_eq_tensorDeriv

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/EMPotential.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.deriv.eq_1
  - Mathematics: TensorSpecies.Tensor.ComponentIdx, realLorentzTensor.Color.down, realLorentzTensor.Color.up, TensorSpecies.Tensor.basis, TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensorial.basis_map_prod
  - Relativity: realLorentzTensor.Color.down, realLorentzTensor.Color.up, Lorentz.Vector.indexEquiv, Lorentz.Vector.tensor_basis_repr_toTensor_apply, realLorentzTensor, Lorentz.CoVector, Lorentz.Vector, Lorentz.Vector.toTensor_symm_basis

```lean
lemma deriv_eq_tensorDeriv {d} (A : ElectromagneticPotential d)
    (hA : Differentiable ℝ A) (x : SpaceTime d) :
    A.deriv x = tensorDeriv A.val x :=
```

## 53. Electromagnetism.ElectromagneticPotential.toTensor_deriv_basis_repr_apply

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/EMPotential.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.deriv, Electromagnetism.ElectromagneticPotential.deriv_basis_repr_apply
  - Mathematics: TensorSpecies.Tensor.ComponentIdx, realLorentzTensor.Color.down, realLorentzTensor.Color.up, TensorSpecies.Tensor.basis, TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensorial.basis_toTensor_apply, TensorSpecies.Tensorial.basis_map_prod
  - Relativity: realLorentzTensor, realLorentzTensor.Color.down, realLorentzTensor.Color.up, Lorentz.Vector.tensor_basis_map_eq_basis_reindex, Lorentz.CoVector.tensor_basis_map_eq_basis_reindex, Lorentz.CoVector.basis, Lorentz.Vector.basis

```lean
lemma toTensor_deriv_basis_repr_apply {d} (A : ElectromagneticPotential d)
    (x : SpaceTime d) (b : ComponentIdx (S := realLorentzTensor d)
      (Fin.append ![Color.down] ![Color.up])) :
    (Tensor.basis _).repr (Tensorial.toTensor (deriv A x)) b =
    ∂_ (finSumFinEquiv.symm (b 0)) A x (finSumFinEquiv.symm (b 1)) :=
```

## 54. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.toTensor_deriv_basis_repr_apply

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/EMPotential.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistElectromagneticPotential.deriv, Electromagnetism.DistElectromagneticPotential.deriv_basis_repr_apply
  - Mathematics: TensorSpecies.Tensor.ComponentIdx, realLorentzTensor.Color.down, realLorentzTensor.Color.up, TensorSpecies.Tensor.basis, TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensorial.basis_toTensor_apply, TensorSpecies.Tensorial.basis_map_prod
  - Relativity: realLorentzTensor, realLorentzTensor.Color.down, realLorentzTensor.Color.up, Lorentz.Vector.tensor_basis_map_eq_basis_reindex, Lorentz.CoVector.tensor_basis_map_eq_basis_reindex, Lorentz.CoVector.basis, Lorentz.Vector.basis

```lean
lemma toTensor_deriv_basis_repr_apply {d} (A : DistElectromagneticPotential d)
    (ε : 𝓢(SpaceTime d, ℝ)) (b : ComponentIdx (S := realLorentzTensor d)
      (Fin.append ![Color.down] ![Color.up])) :
    (Tensor.basis _).repr (Tensorial.toTensor (deriv A ε)) b =
    distDeriv (finSumFinEquiv.symm (b 0)) A ε (finSumFinEquiv.symm (b 1)) :=
```

## 55. Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_electricField

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/ThreeDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle, Electromagnetism.DistElectromagneticPotential.electricField, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_scalarPotential, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_vectorPotential
  - Particles: Electromagnetism.DistElectromagneticPotential.threeDimPointParticle, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_scalarPotential, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_vectorPotential
  - SpaceAndTime: Space.constantTime, Space.distOfFunction, Space.IsDistBounded.zpow_smul_repr_self, Space.IsDistBounded.comp_sub_right, Space.constantTime_distSpaceGrad, Space.distOfFunction_mul_fun, Space.IsDistBounded.inv_shift, Space.distGrad

```lean
lemma threeDimPointParticle_electricField (𝓕 : FreeSpace) (q : ℝ) (r₀ : Space 3) :
    (threeDimPointParticle 𝓕 q r₀).electricField 𝓕.c =
    (q/ (4 * π * 𝓕.ε₀)) • constantTime (distOfFunction (fun x : Space 3 =>
      ‖x - r₀‖ ^ (- 3 : ℤ) • basis.repr (x - r₀))
      ((IsDistBounded.zpow_smul_repr_self (- 3 : ℤ) (by omega)).comp_sub_right r₀)) :=
```

## 56. Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_div_electricField

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/ThreeDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential.threeDimPointParticle, Electromagnetism.DistElectromagneticPotential.electricField, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_electricField
  - Particles: Electromagnetism.DistElectromagneticPotential.threeDimPointParticle, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_electricField
  - SpaceAndTime: Space.distSpaceDiv, Space.constantTime, Space.distDiv_inv_pow_eq_dim, Space.distTranslate, Space.distOfFunction, Space.IsDistBounded.zpow_smul_repr_self, Space.distTranslate_ofFunction, Space.constantTime_distSpaceDiv

```lean
lemma threeDimPointParticle_div_electricField {𝓕} (q : ℝ) (r₀ : Space 3) :
    distSpaceDiv ((threeDimPointParticle 𝓕 q r₀).electricField 𝓕.c) =
    (1/𝓕.ε₀) • constantTime (q • diracDelta ℝ r₀) :=
```

## 57. Electromagnetism.ElectromagneticPotential.toTensor_toFieldStrength_basis_repr

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/FieldStrength.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.toFieldStrength, Electromagnetism.ElectromagneticPotential.toTensor_toFieldStrength, Electromagnetism.ElectromagneticPotential.toTensor_deriv_basis_repr_apply
  - Mathematics: TensorSpecies.Tensor.ComponentIdx, realLorentzTensor.Color.up, TensorSpecies.Tensor.basis, TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensorial.self_toTensor_apply, TensorSpecies.Tensor.permT_basis_repr_symm_apply, realLorentzTensor.contrT_basis_repr_apply_eq_fin, TensorSpecies.Tensor.prodT_basis_repr_apply
  - Relativity: realLorentzTensor, realLorentzTensor.Color.up, realLorentzTensor.contrT_basis_repr_apply_eq_fin, realLorentzTensor.contrMetric_repr_apply_eq_minkowskiMatrix

```lean
lemma toTensor_toFieldStrength_basis_repr {d} (A : ElectromagneticPotential d) (x : SpaceTime d)
    (b : ComponentIdx (S := realLorentzTensor d) (Fin.append ![Color.up] ![Color.up])) :
    (Tensor.basis _).repr (Tensorial.toTensor (toFieldStrength A x)) b =
    ∑ κ, (η (finSumFinEquiv.symm (b 0)) κ * ∂_ κ A x (finSumFinEquiv.symm (b 1)) -
      η (finSumFinEquiv.symm (b 1)) κ * ∂_ κ A x (finSumFinEquiv.symm (b 0))) :=
```

## 58. Electromagnetism.ElectromagneticPotential.toFieldStrength_tensor_basis_eq_basis

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/FieldStrength.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.toFieldStrength
  - Mathematics: TensorSpecies.Tensor.ComponentIdx, realLorentzTensor.Color.up, TensorSpecies.Tensor.basis, TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensorial.basis_toTensor_apply, TensorSpecies.Tensorial.basis_map_prod
  - Relativity: realLorentzTensor, realLorentzTensor.Color.up, Lorentz.Vector.basis, Lorentz.Vector.tensor_basis_map_eq_basis_reindex

```lean
lemma toFieldStrength_tensor_basis_eq_basis {d} (A : ElectromagneticPotential d) (x : SpaceTime d)
    (b : ComponentIdx (S := realLorentzTensor d) (Fin.append ![Color.up] ![Color.up])) :
    (Tensor.basis _).repr (Tensorial.toTensor (toFieldStrength A x)) b =
    (Lorentz.Vector.basis.tensorProduct Lorentz.Vector.basis).repr (toFieldStrength A x)
      (finSumFinEquiv.symm (b 0), finSumFinEquiv.symm (b 1)) :=
```

## 59. Electromagnetism.ElectromagneticPotential.toFieldStrength_basis_repr_apply

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/FieldStrength.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.toFieldStrength, Electromagnetism.ElectromagneticPotential.toTensor_toFieldStrength_basis_repr, Electromagnetism.ElectromagneticPotential.toFieldStrength_tensor_basis_eq_basis
  - Mathematics: TensorSpecies.Tensor.basis, TensorSpecies.Tensorial.toTensor
  - Relativity: Lorentz.Vector.basis

```lean
lemma toFieldStrength_basis_repr_apply {d} {μν : (Fin 1 ⊕ Fin d) × (Fin 1 ⊕ Fin d)}
    (A : ElectromagneticPotential d) (x : SpaceTime d) :
    (Lorentz.CoVector.basis.tensorProduct Lorentz.Vector.basis).repr (A.toFieldStrength x) μν =
    ∑ κ, ((η μν.1 κ * ∂_ κ A x μν.2) - η μν.2 κ * ∂_ κ A x μν.1) :=
```

## 60. Electromagnetism.ElectromagneticPotential.toFieldStrength_equivariant

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/FieldStrength.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.toFieldStrength, Electromagnetism.ElectromagneticPotential.toFieldStrength.eq_1, Electromagnetism.ElectromagneticPotential.deriv_equivariant
  - Mathematics: realLorentzTensor.actionT_contrMetric, TensorSpecies.Tensorial.toTensor_smul, TensorSpecies.Tensor.prodT_equivariant, TensorSpecies.Tensor.contrT_equivariant, TensorSpecies.Tensor.permT_equivariant, TensorSpecies.Tensorial.smul_toTensor_symm
  - Relativity: LorentzGroup, realLorentzTensor.actionT_contrMetric

```lean
lemma toFieldStrength_equivariant {d} (A : ElectromagneticPotential d) (Λ : LorentzGroup d)
    (hf : Differentiable ℝ A) (x : SpaceTime d) :
    toFieldStrength (Λ • A) x = Λ • toFieldStrength A (Λ⁻¹ • x) :=
```

## 61. Electromagnetism.ElectromagneticPotential.fieldStrengthMatrix_equivariant

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/FieldStrength.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.fieldStrengthMatrix, Electromagnetism.ElectromagneticPotential.fieldStrengthMatrix.eq_1, Electromagnetism.ElectromagneticPotential.toFieldStrength_equivariant
  - Mathematics: TensorSpecies.Tensorial.smul_prod
  - Relativity: LorentzGroup, Lorentz.Vector, Lorentz.Vector.basis, Lorentz.Vector.basis_repr_apply, Lorentz.CoVector.basis_repr_apply, Lorentz.Vector.smul_eq_sum

```lean
lemma fieldStrengthMatrix_equivariant {d} (A : ElectromagneticPotential d)
    (Λ : LorentzGroup d) (hf : Differentiable ℝ A) (x : SpaceTime d)
    (μ : (Fin 1 ⊕ Fin d)) (ν : Fin 1 ⊕ Fin d) :
    fieldStrengthMatrix (Λ • A) x (μ, ν) =
    ∑ κ, ∑ ρ, (Λ.1 μ κ * Λ.1 ν ρ) * A.fieldStrengthMatrix (Λ⁻¹ • x) (κ, ρ) :=
```

## 62. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.toTensor_fieldStrengthAux_basis_repr

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/FieldStrength.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistElectromagneticPotential.fieldStrengthAux, Electromagnetism.DistElectromagneticPotential.toTensor_fieldStrengthAux, Electromagnetism.DistElectromagneticPotential.toTensor_deriv_basis_repr_apply
  - Mathematics: TensorSpecies.Tensor.ComponentIdx, realLorentzTensor.Color.up, TensorSpecies.Tensor.basis, TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensorial.self_toTensor_apply, TensorSpecies.Tensor.permT_basis_repr_symm_apply, realLorentzTensor.contrT_basis_repr_apply_eq_fin, TensorSpecies.Tensor.prodT_basis_repr_apply
  - Relativity: realLorentzTensor, realLorentzTensor.Color.up, realLorentzTensor.contrT_basis_repr_apply_eq_fin, realLorentzTensor.contrMetric_repr_apply_eq_minkowskiMatrix

```lean
lemma toTensor_fieldStrengthAux_basis_repr {d} (A : DistElectromagneticPotential d)
    (ε : 𝓢(SpaceTime d, ℝ))
    (b : ComponentIdx (S := realLorentzTensor d) (Fin.append ![Color.up] ![Color.up])) :
    (Tensor.basis _).repr (Tensorial.toTensor (fieldStrengthAux A ε)) b =
    ∑ κ, (η (finSumFinEquiv.symm (b 0)) κ * SpaceTime.distDeriv κ A ε (finSumFinEquiv.symm (b 1)) -
      η (finSumFinEquiv.symm (b 1)) κ * SpaceTime.distDeriv κ A ε (finSumFinEquiv.symm (b 0))) :=
```

## 63. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.fieldStrengthAux_tensor_basis_eq_basis

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/FieldStrength.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential
  - Mathematics: TensorSpecies.Tensor.ComponentIdx, realLorentzTensor.Color.up, TensorSpecies.Tensor.basis, TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensorial.basis_toTensor_apply, TensorSpecies.Tensorial.basis_map_prod
  - Relativity: realLorentzTensor, realLorentzTensor.Color.up, Lorentz.Vector.basis, Lorentz.Vector.tensor_basis_map_eq_basis_reindex

```lean
lemma fieldStrengthAux_tensor_basis_eq_basis {d} (A : DistElectromagneticPotential d)
    (ε : 𝓢(SpaceTime d, ℝ))
    (b : ComponentIdx (S := realLorentzTensor d) (Fin.append ![Color.up] ![Color.up])) :
    (Tensor.basis _).repr (Tensorial.toTensor (A.fieldStrengthAux ε)) b =
    (Lorentz.Vector.basis.tensorProduct Lorentz.Vector.basis).repr (A.fieldStrengthAux ε)
      (finSumFinEquiv.symm (b 0), finSumFinEquiv.symm (b 1)) :=
```

## 64. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.fieldStrengthAux_basis_repr_apply

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/FieldStrength.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistElectromagneticPotential.toTensor_fieldStrengthAux_basis_repr, Electromagnetism.DistElectromagneticPotential.fieldStrengthAux_tensor_basis_eq_basis
  - Mathematics: TensorSpecies.Tensor.basis, TensorSpecies.Tensorial.toTensor
  - Relativity: Lorentz.Vector.basis

```lean
lemma fieldStrengthAux_basis_repr_apply {d} {μν : (Fin 1 ⊕ Fin d) × (Fin 1 ⊕ Fin d)}
    (A : DistElectromagneticPotential d) (ε : 𝓢(SpaceTime d, ℝ)) :
    (Lorentz.Vector.basis.tensorProduct Lorentz.Vector.basis).repr (A.fieldStrengthAux ε) μν =
    ∑ κ, ((η μν.1 κ * distDeriv κ A ε μν.2) - η μν.2 κ * distDeriv κ A ε μν.1) :=
```

## 65. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.fieldStrength_equivariant

- split: `train`
- file: `Physlib/Electromagnetism/Kinematics/FieldStrength.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistElectromagneticPotential.fieldStrength, Electromagnetism.DistElectromagneticPotential.fieldStrength_eq_fieldStrengthAux, Electromagnetism.DistElectromagneticPotential.fieldStrengthAux_eq_add, Electromagnetism.DistElectromagneticPotential.deriv_equivariant
  - Mathematics: realLorentzTensor.actionT_contrMetric, TensorSpecies.Tensorial.toTensor_smul, TensorSpecies.Tensor.prodT_equivariant, TensorSpecies.Tensor.contrT_equivariant, TensorSpecies.Tensor.permT_equivariant, TensorSpecies.Tensorial.smul_toTensor_symm
  - Relativity: LorentzGroup, realLorentzTensor.actionT_contrMetric

```lean
lemma fieldStrength_equivariant {d} (A : DistElectromagneticPotential d)
    (Λ : LorentzGroup d) :
    (Λ • A).fieldStrength = Λ • A.fieldStrength :=
```

## 66. Electromagnetism.ElectromagneticPotential.kineticTerm_equivariant

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/KineticTerm.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.kineticTerm, Electromagnetism.ElectromagneticPotential.kineticTerm.eq_1, Electromagnetism.ElectromagneticPotential.toFieldStrength_equivariant
  - Mathematics: TensorSpecies.Tensorial.toTensor_smul, realLorentzTensor.actionT_coMetric, TensorSpecies.Tensor.prodT_equivariant, TensorSpecies.Tensor.contrT_equivariant, TensorSpecies.Tensor.toField_equivariant
  - Relativity: LorentzGroup, realLorentzTensor.actionT_coMetric

```lean
lemma kineticTerm_equivariant {d} {𝓕 : FreeSpace} (A : ElectromagneticPotential d)
    (Λ : LorentzGroup d)
    (hf : Differentiable ℝ A) (x : SpaceTime d) :
    kineticTerm 𝓕 (Λ • A) x = kineticTerm 𝓕 A (Λ⁻¹ • x) :=
```

## 67. Electromagnetism.ElectromagneticPotential.kineticTerm_eq_sum

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/KineticTerm.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.kineticTerm.eq_1, Electromagnetism.ElectromagneticPotential.toFieldStrength_tensor_basis_eq_basis
  - Mathematics: TensorSpecies.Tensor.toField_eq_repr, realLorentzTensor.contrT_basis_repr_apply_eq_fin, TensorSpecies.Tensor.prodT_basis_repr_apply, realLorentzTensor.coMetric_repr_apply_eq_minkowskiMatrix
  - Relativity: Lorentz.Vector.basis, realLorentzTensor.contrT_basis_repr_apply_eq_fin, realLorentzTensor.coMetric_repr_apply_eq_minkowskiMatrix

```lean
lemma kineticTerm_eq_sum {d} {𝓕 : FreeSpace} (A : ElectromagneticPotential d) (x : SpaceTime d) :
    A.kineticTerm 𝓕 x =
    - 1/(4 * 𝓕.μ₀) * ∑ μ, ∑ ν, ∑ μ', ∑ ν', η μ μ' * η ν ν' *
      (Lorentz.CoVector.basis.tensorProduct Lorentz.Vector.basis).repr (A.toFieldStrength x) (μ, ν)
      * (Lorentz.CoVector.basis.tensorProduct Lorentz.Vector.basis).repr
        (A.toFieldStrength x) (μ', ν') :=
```

## 68. Electromagnetism.ElectromagneticPotential.gradKineticTerm_eq_electric_magnetic

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/KineticTerm.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.toFieldStrength_basis_repr_apply_eq_single, Electromagnetism.ElectromagneticPotential.gradKineticTerm_eq_fieldStrength, Electromagnetism.ElectromagneticPotential.div_electricField_eq_fieldStrengthMatrix, Electromagnetism.ElectromagneticPotential.curl_magneticFieldMatrix_eq_electricField_fieldStrengthMatrix
  - Relativity: Lorentz.Vector.basis, Lorentz.Vector.differentiable_apply, minkowskiMatrix.inl_0_inl_0, minkowskiMatrix.inr_i_inr_i
  - SpaceAndTime: Space.div, Space.deriv, SpaceTime.toTimeAndSpace_symm_apply_time_space

```lean
lemma gradKineticTerm_eq_electric_magnetic {𝓕 : FreeSpace} (A : ElectromagneticPotential d)
    (x : SpaceTime d) (ha : ContDiff ℝ ∞ A) :
    A.gradKineticTerm 𝓕 x =
    (1/(𝓕.μ₀ * 𝓕.c) * Space.div (A.electricField 𝓕.c (x.time 𝓕.c)) x.space) •
    Lorentz.Vector.basis (Sum.inl 0) +
    ∑ i, (𝓕.μ₀⁻¹ * (1 / 𝓕.c ^ 2 * ∂ₜ (fun t => A.electricField 𝓕.c t x.space) (x.time 𝓕.c) i-
      ∑ j, Space.deriv j (A.magneticFieldMatrix 𝓕.c (x.time 𝓕.c) · (j, i)) x.space)) •
      Lorentz.Vector.basis (Sum.inr i) :=
```

## 69. Electromagnetism.ElectromagneticPotential.gradKineticTerm_eq_electric_magnetic_three

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/KineticTerm.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.gradKineticTerm_eq_electric_magnetic, Electromagnetism.ElectromagneticPotential.magneticField_curl_eq_magneticFieldMatrix
  - Relativity: Lorentz.Vector.basis
  - SpaceAndTime: Space.div, Space.curl

```lean
lemma gradKineticTerm_eq_electric_magnetic_three {𝓕 : FreeSpace} (A : ElectromagneticPotential)
    (x : SpaceTime) (ha : ContDiff ℝ ∞ A) :
    A.gradKineticTerm 𝓕 x =
    (1/(𝓕.μ₀ * 𝓕.c) * Space.div (A.electricField 𝓕.c (x.time 𝓕.c)) x.space) •
      Lorentz.Vector.basis (Sum.inl 0) +
    ∑ i, (𝓕.μ₀⁻¹ * (1 / 𝓕.c ^ 2 * ∂ₜ (fun t => A.electricField 𝓕.c t x.space) (x.time 𝓕.c) i-
      Space.curl (A.magneticField 𝓕.c (x.time 𝓕.c)) x.space i)) •
      Lorentz.Vector.basis (Sum.inr i) :=
```

## 70. Electromagnetism.ElectromagneticPotential.gradKineticTerm_eq_tensorDeriv

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/KineticTerm.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.toFieldStrength_differentiable, Electromagnetism.ElectromagneticPotential.toFieldStrength_tensor_basis_eq_basis, Electromagnetism.ElectromagneticPotential.fieldStrengthMatrix, Electromagnetism.ElectromagneticPotential.gradKineticTerm_eq_fieldStrength
  - Mathematics: TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensor.permT, TensorSpecies.Tensor.PermCond, TensorSpecies.Tensor.permT_basis_repr_symm_apply, realLorentzTensor.contrT_basis_repr_apply_eq_fin, TensorSpecies.Tensor.ComponentIdx.prod, TensorSpecies.Tensor.ComponentIdx.DropPairSection.ofFinEquiv, TensorSpecies.Tensor.ComponentIdx.DropPairSection.ofFin
  - Relativity: Lorentz.Vector, Lorentz.Vector.basis_repr_apply, Lorentz.Vector.basis_eq_map_tensor_basis, realLorentzTensor.contrT_basis_repr_apply_eq_fin, Lorentz.Vector.apply_sum, Lorentz.CoVector.indexEquiv

```lean
lemma gradKineticTerm_eq_tensorDeriv {d} {𝓕 : FreeSpace}
    (A : ElectromagneticPotential d) (x : SpaceTime d)
    (hA : ContDiff ℝ ∞ A) (ν : Fin 1 ⊕ Fin d) :
    A.gradKineticTerm 𝓕 x ν = η ν ν * ((Tensorial.toTensor (M := Lorentz.Vector d)).symm
    (permT id (PermCond.auto) {(1/ 𝓕.μ₀ : ℝ) • tensorDeriv A.toFieldStrength x | κ κ ν'}ᵀ)) ν :=
```

## 71. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.gradKineticTerm_sum_inl_eq

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/KineticTerm.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistElectromagneticPotential.gradKineticTerm_eq_fieldStrength, Electromagnetism.DistElectromagneticPotential.electricField_eq_fieldStrength, Electromagnetism.DistElectromagneticPotential.fieldStrength_antisymmetric_basis
  - Relativity: Lorentz.Vector.apply_sum
  - SpaceAndTime: Space.distSpaceDiv, Space.distSpaceDiv_apply_eq_sum_distSpaceDeriv, Space.distSpaceDeriv_apply', Space.apply_fderiv_eq_distSpaceDeriv

```lean
lemma gradKineticTerm_sum_inl_eq {d} {𝓕 : FreeSpace}
    (A : DistElectromagneticPotential d) (ε : 𝓢(SpaceTime d, ℝ)) :
    A.gradKineticTerm 𝓕 ε (Sum.inl 0) =
    (1/(𝓕.μ₀ * 𝓕.c) * (distTimeSlice 𝓕.c).symm (Space.distSpaceDiv (A.electricField 𝓕.c)) ε) :=
```

## 72. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.gradKineticTerm_sum_inr_eq

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/KineticTerm.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistElectromagneticPotential.gradKineticTerm_eq_fieldStrength, Electromagnetism.DistElectromagneticPotential.electricField_eq_fieldStrength, Electromagnetism.DistElectromagneticPotential.magneticFieldMatrix_basis_repr_eq_fieldStrength
  - Relativity: Lorentz.Vector.apply_sum
  - SpaceAndTime: Space.distTimeDeriv, Space.distSpaceDeriv, Space.distTimeDeriv_apply', Space.apply_fderiv_eq_distTimeDeriv, Space.distSpaceDeriv_apply', Space.apply_fderiv_eq_distSpaceDeriv

```lean
lemma gradKineticTerm_sum_inr_eq {d} {𝓕 : FreeSpace}
    (A : DistElectromagneticPotential d) (ε : 𝓢(SpaceTime d, ℝ)) (i : Fin d) :
    A.gradKineticTerm 𝓕 ε (Sum.inr i) =
    (𝓕.μ₀⁻¹ * (1 / 𝓕.c ^ 2 * (distTimeSlice 𝓕.c).symm
      (Space.distTimeDeriv (A.electricField 𝓕.c)) ε i -
      ∑ j, ((PiLp.basisFun 2 ℝ (Fin d)).tensorProduct (PiLp.basisFun 2 ℝ (Fin d))).repr
        ((distTimeSlice 𝓕.c).symm (Space.distSpaceDeriv j
          (A.magneticFieldMatrix 𝓕.c)) ε) (j, i))) :=
```

## 73. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.gradKineticTerm_eq_distTensorDeriv

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/KineticTerm.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Mathematics, Relativity`
- used_premise_domains: `Electromagnetism, Mathematics, Relativity`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistElectromagneticPotential.gradKineticTerm_eq_fieldStrength
  - Mathematics: TensorSpecies.Tensorial.toTensor, TensorSpecies.Tensor.permT, TensorSpecies.Tensor.PermCond, TensorSpecies.Tensor.permT_basis_repr_symm_apply, realLorentzTensor.contrT_basis_repr_apply_eq_fin, TensorSpecies.Tensor.basis, TensorSpecies.Tensorial.basis_toTensor_apply, TensorSpecies.Tensorial.basis_map_prod
  - Relativity: Lorentz.Vector, Lorentz.Vector.basis_eq_map_tensor_basis, realLorentzTensor.contrT_basis_repr_apply_eq_fin, Lorentz.Vector.apply_sum, Lorentz.Vector.tensor_basis_map_eq_basis_reindex, Lorentz.Vector.basis, Lorentz.Vector.indexEquiv, Lorentz.CoVector.indexEquiv

```lean
lemma gradKineticTerm_eq_distTensorDeriv {d} {𝓕 : FreeSpace}
    (A : DistElectromagneticPotential d) (ε : 𝓢(SpaceTime d, ℝ)) (ν : Fin 1 ⊕ Fin d) :
    A.gradKineticTerm 𝓕 ε ν = η ν ν * ((Tensorial.toTensor (M := Lorentz.Vector d)).symm
    (permT id (PermCond.auto) {(1/ 𝓕.μ₀ : ℝ) •
    distTensorDeriv A.fieldStrength ε | κ κ ν'}ᵀ)) ν :=
```

## 74. Electromagnetism.ElectromagneticPotential.magneticField_fst_eq_fieldStrengthMatrix

- split: `valid`
- file: `Physlib/Electromagnetism/Kinematics/MagneticField.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.toFieldStrength_basis_repr_apply_eq_single, Electromagnetism.ElectromagneticPotential.magneticField.eq_1
  - Relativity: minkowskiMatrix.inr_i_inr_i, Lorentz.Vector.fderiv_apply
  - SpaceAndTime: Space.curl, Space.deriv_eq

```lean
lemma magneticField_fst_eq_fieldStrengthMatrix {c : SpeedOfLight}
    (A : ElectromagneticPotential) (t : Time)
    (x : Space) (hA : Differentiable ℝ A) :
    A.magneticField c t x 0 =
    - A.fieldStrengthMatrix ((toTimeAndSpace c).symm (t, x)) (Sum.inr 1, Sum.inr 2) :=
```

## 75. Electromagnetism.ElectromagneticPotential.magneticField_snd_eq_fieldStrengthMatrix

- split: `valid`
- file: `Physlib/Electromagnetism/Kinematics/MagneticField.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.toFieldStrength_basis_repr_apply_eq_single, Electromagnetism.ElectromagneticPotential.magneticField.eq_1
  - Relativity: minkowskiMatrix.inr_i_inr_i, Lorentz.Vector.fderiv_apply
  - SpaceAndTime: Space.curl, Space.deriv_eq

```lean
lemma magneticField_snd_eq_fieldStrengthMatrix {c : SpeedOfLight}
    (A : ElectromagneticPotential) (t : Time)
    (x : Space) (hA : Differentiable ℝ A) :
    A.magneticField c t x 1 = A.fieldStrengthMatrix ((toTimeAndSpace c).symm (t, x))
      (Sum.inr 0, Sum.inr 2) :=
```

## 76. Electromagnetism.ElectromagneticPotential.magneticField_thd_eq_fieldStrengthMatrix

- split: `valid`
- file: `Physlib/Electromagnetism/Kinematics/MagneticField.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.toFieldStrength_basis_repr_apply_eq_single, Electromagnetism.ElectromagneticPotential.magneticField.eq_1
  - Relativity: minkowskiMatrix.inr_i_inr_i, Lorentz.Vector.fderiv_apply
  - SpaceAndTime: Space.curl, Space.deriv_eq

```lean
lemma magneticField_thd_eq_fieldStrengthMatrix {c : SpeedOfLight} (A : ElectromagneticPotential)
    (t : Time) (x : Space) (hA : Differentiable ℝ A) :
    A.magneticField c t x 2 =
    - A.fieldStrengthMatrix ((toTimeAndSpace c).symm (t, x)) (Sum.inr 0, Sum.inr 1) :=
```

## 77. Electromagnetism.ElectromagneticPotential.magneticFieldMatrix_eq_vectorPotential

- split: `valid`
- file: `Physlib/Electromagnetism/Kinematics/MagneticField.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.ElectromagneticPotential.magneticFieldMatrix_eq, Electromagnetism.ElectromagneticPotential.toFieldStrength_basis_repr_apply_eq_single, Electromagnetism.ElectromagneticPotential.vectorPotential
  - Relativity: minkowskiMatrix.inr_i_inr_i
  - SpaceAndTime: Space.deriv, Space.deriv_lorentz_vector

```lean
lemma magneticFieldMatrix_eq_vectorPotential {c : SpeedOfLight} (A : ElectromagneticPotential d)
    (hA : Differentiable ℝ A) (t : Time) (x : Space d) (i j : Fin d) :
    A.magneticFieldMatrix c t x (i, j) = Space.deriv j (A.vectorPotential c t · i) x -
    Space.deriv i (A.vectorPotential c t · j) x :=
```

## 78. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.magneticFieldMatrix_eq_vectorPotential

- split: `valid`
- file: `Physlib/Electromagnetism/Kinematics/MagneticField.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistElectromagneticPotential.magneticFieldMatrix, Electromagnetism.DistElectromagneticPotential.fieldStrength_eq_basis, Electromagnetism.DistElectromagneticPotential.vectorPotential
  - Relativity: minkowskiMatrix.inl_0_inl_0, minkowskiMatrix.inr_i_inr_i, Lorentz.Vector.spatialCLM_basis_sum_inl, Lorentz.Vector.spatialCLM_basis_sum_inr, Lorentz.Vector.spatialCLM
  - SpaceAndTime: Space.distSpaceDeriv, EuclideanSpace.basisFun, EuclideanSpace.basisFun_apply, Space.distSpaceDeriv_apply_CLM

```lean
lemma magneticFieldMatrix_eq_vectorPotential {c : SpeedOfLight}
    (A : DistElectromagneticPotential d)
    (ε : 𝓢(Time × Space d, ℝ)) :
    A.magneticFieldMatrix c ε = ∑ i, ∑ j,
    (Space.distSpaceDeriv j (A.vectorPotential c) ε i -
      Space.distSpaceDeriv i (A.vectorPotential c) ε j) •
    EuclideanSpace.basisFun (Fin d) ℝ i ⊗ₜ[ℝ] EuclideanSpace.basisFun (Fin d) ℝ j :=
```

## 79. Electromagnetism.ElectromagneticPotential.DistElectromagneticPotential.magneticFieldMatrix_basis_repr_eq_fieldStrength

- split: `valid`
- file: `Physlib/Electromagnetism/Kinematics/MagneticField.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential, Electromagnetism.DistElectromagneticPotential.magneticFieldMatrix_eq_vectorPotential, Electromagnetism.DistElectromagneticPotential.fieldStrength_basis_repr_eq_single, Electromagnetism.DistElectromagneticPotential.vectorPotential
  - Relativity: Lorentz.Vector.basis, minkowskiMatrix.inr_i_inr_i, Lorentz.Vector.spatialCLM
  - SpaceAndTime: EuclideanSpace.basisFun_apply, Space.distSpaceDeriv_apply_CLM

```lean
lemma magneticFieldMatrix_basis_repr_eq_fieldStrength {c : SpeedOfLight}
    (A : DistElectromagneticPotential d)
    (ε : 𝓢(Time × Space d, ℝ)) (i j : Fin d) :
    ((PiLp.basisFun 2 ℝ (Fin d)).tensorProduct (PiLp.basisFun 2 ℝ (Fin d))).repr
        (A.magneticFieldMatrix c ε) (i, j) =
      (Lorentz.Vector.basis.tensorProduct Lorentz.Vector.basis).repr
        (distTimeSlice c A.fieldStrength ε) (Sum.inr i, Sum.inr j) :=
```

## 80. QuantumMechanics.position_commutation_momentum

- split: `test`
- file: `Physlib/QuantumMechanics/DDimensions/Operators/Commutation.lean`
- primary_domain: `QuantumMechanics`
- domains: `Mathematics, QuantumMechanics, SpaceAndTime`
- used_premise_domains: `Mathematics, QuantumMechanics, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Mathematics: KroneckerDelta.eq_zero_of_ne
  - QuantumMechanics: QuantumMechanics.positionOperator_apply, QuantumMechanics.momentumOperator_apply, QuantumMechanics.positionOperator_apply_fun
  - SpaceAndTime: Space.deriv_smul, Space.deriv_component

```lean
lemma position_commutation_momentum : ⁅𝐱 i, 𝐩 j⁆ =
    (I * ℏ) • δ[i,j] • ContinuousLinearMap.id ℂ 𝓢(Space d, ℂ) :=
```

## 81. Electromagnetism.ElectromagneticPotential.canonicalMomentum_eq_gradient_kineticTerm

- split: `test`
- file: `Physlib/Electromagnetism/Dynamics/Hamiltonian.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.LorentzCurrentDensity, Electromagnetism.ElectromagneticPotential.kineticTerm, Electromagnetism.ElectromagneticPotential.canonicalMomentum.eq_1, Electromagnetism.ElectromagneticPotential.lagrangian_add_const, Electromagnetism.ElectromagneticPotential.kineticTerm_add_time_mul_const, Electromagnetism.ElectromagneticPotential.lagrangian
  - Relativity: Electromagnetism.LorentzCurrentDensity, Lorentz.Vector
  - SpaceAndTime: InnerProductSpace.toDual_symm_apply

```lean
lemma canonicalMomentum_eq_gradient_kineticTerm {d}
    {𝓕 : FreeSpace} (A : ElectromagneticPotential d)
    (hA : ContDiff ℝ 2 A) (J : LorentzCurrentDensity d) :
    A.canonicalMomentum 𝓕 J = fun x =>
    gradient (fun (v : Lorentz.Vector d) =>
    kineticTerm 𝓕 ⟨fun x => A x + x (Sum.inl 0) • v⟩ x) 0:=
```

## 82. Electromagnetism.ElectromagneticPotential.canonicalMomentum_eq_electricField

- split: `test`
- file: `Physlib/Electromagnetism/Dynamics/Hamiltonian.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.LorentzCurrentDensity, Electromagnetism.ElectromagneticPotential.canonicalMomentum_eq, Electromagnetism.ElectromagneticPotential.electricField_eq_fieldStrengthMatrix, Electromagnetism.ElectromagneticPotential.fieldStrengthMatrix_antisymm
  - Relativity: Electromagnetism.LorentzCurrentDensity, minkowskiMatrix.inr_i_inr_i
  - SpaceAndTime: SpaceTime.toTimeAndSpace_symm_apply_time_space

```lean
lemma canonicalMomentum_eq_electricField {d} {𝓕 : FreeSpace} (A : ElectromagneticPotential d)
    (hA : ContDiff ℝ 2 A) (J : LorentzCurrentDensity d) :
    A.canonicalMomentum 𝓕 J = fun x => fun μ =>
      match μ with
      | Sum.inl 0 => 0
      | Sum.inr i => - (1/(𝓕.μ₀ * 𝓕.c)) * A.electricField 𝓕.c (x.time 𝓕.c) x.space i :=
```

## 83. Electromagnetism.ElectromagneticPotential.hamiltonian_eq_electricField_scalarPotential

- split: `test`
- file: `Physlib/Electromagnetism/Dynamics/Hamiltonian.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `6.00`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.ElectromagneticPotential, Electromagnetism.LorentzCurrentDensity, Electromagnetism.ElectromagneticPotential.lagrangian, Electromagnetism.ElectromagneticPotential.hamiltonian_eq_electricField_vectorPotential, Electromagnetism.ElectromagneticPotential.time_deriv_vectorPotential_eq_electricField
  - Relativity: Electromagnetism.LorentzCurrentDensity
  - SpaceAndTime: Space.grad, EuclideanSpace.norm_sq_eq

```lean
lemma hamiltonian_eq_electricField_scalarPotential {d} {𝓕 : FreeSpace}
    (A : ElectromagneticPotential d) (hA : ContDiff ℝ 2 A)
    (J : LorentzCurrentDensity d) (x : SpaceTime d) :
    A.hamiltonian 𝓕 J x =
      (1/ 𝓕.c.val^2 * 𝓕.μ₀⁻¹) * (‖A.electricField 𝓕.c (x.time 𝓕.c) x.space‖ ^ 2
      + ⟪A.electricField 𝓕.c (x.time 𝓕.c) x.space,
        Space.grad (A.scalarPotential 𝓕.c (x.time 𝓕.c) ·) x.space⟫_ℝ)
        - lagrangian 𝓕 A J x :=
```

## 84. SpaceTime.apply_fderiv_eq_distDeriv

- split: `train`
- file: `Physlib/SpaceAndTime/SpaceTime/Derivatives.lean`
- primary_domain: `SpaceAndTime`
- domains: `QuantumMechanics, Relativity, SpaceAndTime`
- used_premise_domains: `QuantumMechanics, Relativity`
- cross_domain_score: `5.90`
- evidence:
  - QuantumMechanics: SchwartzMap.evalCLM, SchwartzMap.fderivCLM
  - Relativity: Lorentz.Vector.basis

```lean
lemma apply_fderiv_eq_distDeriv {M d} [NormedAddCommGroup M] [NormedSpace ℝ M]
    (μ : Fin 1 ⊕ Fin d) (f : (SpaceTime d) →d[ℝ] M) (ε : 𝓢(SpaceTime d, ℝ)) :
    f ((SchwartzMap.evalCLM ℝ (SpaceTime d) ℝ (Lorentz.Vector.basis μ))
    ((fderivCLM ℝ (SpaceTime d) ℝ) ε)) =
    - distDeriv μ f ε :=
```

## 85. Electromagnetism.LorentzCurrentDensity.currentDensity_apply_differentiable_space

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/CurrentDensity.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `5.90`
- evidence:
  - Electromagnetism: Electromagnetism.LorentzCurrentDensity, Electromagnetism.LorentzCurrentDensity.currentDensity_differentiable
  - Relativity: Electromagnetism.LorentzCurrentDensity, Electromagnetism.LorentzCurrentDensity.currentDensity_differentiable
  - SpaceAndTime: EuclideanSpace.proj

```lean
lemma currentDensity_apply_differentiable_space {d : ℕ} {c : SpeedOfLight}
    {J : LorentzCurrentDensity d}
    (hJ : Differentiable ℝ J) (t : Time) (i : Fin d) :
    Differentiable ℝ (fun x => J.currentDensity c t x i) :=
```

## 86. Electromagnetism.LorentzCurrentDensity.currentDensity_apply_differentiable_time

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/CurrentDensity.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `5.90`
- evidence:
  - Electromagnetism: Electromagnetism.LorentzCurrentDensity, Electromagnetism.LorentzCurrentDensity.currentDensity_differentiable
  - Relativity: Electromagnetism.LorentzCurrentDensity, Electromagnetism.LorentzCurrentDensity.currentDensity_differentiable
  - SpaceAndTime: EuclideanSpace.proj

```lean
lemma currentDensity_apply_differentiable_time {d : ℕ} {c : SpeedOfLight}
    {J : LorentzCurrentDensity d}
    (hJ : Differentiable ℝ J) (x : Space d) (i : Fin d) :
    Differentiable ℝ (fun t => J.currentDensity c t x i) :=
```

## 87. Electromagnetism.ElectromagneticPotential.hamiltonian_eq_electricField_magneticField

- split: `test`
- file: `Physlib/Electromagnetism/Dynamics/Hamiltonian.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `5.90`
- evidence:
  - Electromagnetism: Electromagnetism.ElectromagneticPotential, Electromagnetism.LorentzCurrentDensity, Electromagnetism.ElectromagneticPotential.hamiltonian_eq_electricField_scalarPotential, Electromagnetism.ElectromagneticPotential.lagrangian_eq_electric_magnetic, Electromagnetism.FreeSpace.c_sq
  - Relativity: Electromagnetism.LorentzCurrentDensity
  - SpaceAndTime: Space.grad, Electromagnetism.FreeSpace.c_sq

```lean
lemma hamiltonian_eq_electricField_magneticField (A : ElectromagneticPotential d)
    (hA : ContDiff ℝ 2 A) (J : LorentzCurrentDensity d) (x : SpaceTime d) :
    A.hamiltonian 𝓕 J x = 1/2 * 𝓕.ε₀ * (‖A.electricField 𝓕.c (x.time 𝓕.c) x.space‖ ^ 2
      + 𝓕.c ^ 2 / 2 * ∑ i, ∑ j, ‖A.magneticFieldMatrix 𝓕.c (x.time 𝓕.c) x.space (i, j)‖ ^ 2)
      + 𝓕.ε₀ * ⟪A.electricField 𝓕.c (x.time 𝓕.c) x.space,
        Space.grad (A.scalarPotential 𝓕.c (x.time 𝓕.c) ·) x.space⟫_ℝ
      + A.scalarPotential 𝓕.c (x.time 𝓕.c) x.space * J.chargeDensity 𝓕.c (x.time 𝓕.c) x.space
      - ∑ i, A.vectorPotential 𝓕.c (x.time 𝓕.c) x.space i *
        J.currentDensity 𝓕.c (x.time 𝓕.c) x.space i :=
```

## 88. Electromagnetism.LorentzCurrentDensity.currentDensity_apply_differentiable

- split: `train`
- file: `Physlib/Electromagnetism/Dynamics/CurrentDensity.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `5.80`
- evidence:
  - Electromagnetism: Electromagnetism.LorentzCurrentDensity, Electromagnetism.LorentzCurrentDensity.currentDensity_differentiable
  - Relativity: Electromagnetism.LorentzCurrentDensity, Electromagnetism.LorentzCurrentDensity.currentDensity_differentiable
  - SpaceAndTime: EuclideanSpace.proj

```lean
lemma currentDensity_apply_differentiable {d : ℕ} {c : SpeedOfLight} {J : LorentzCurrentDensity d}
    (hJ : Differentiable ℝ J) (i : Fin d) :
    Differentiable ℝ ↿(fun t x => J.currentDensity c t x i) :=
```

## 89. Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_electricField_timeDeriv

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/OneDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, SpaceAndTime`
- cross_domain_score: `5.80`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle, Electromagnetism.DistElectromagneticPotential.electricField, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_electricField
  - Particles: Electromagnetism.DistElectromagneticPotential.oneDimPointParticle, Electromagnetism.DistElectromagneticPotential.oneDimPointParticle_electricField
  - SpaceAndTime: Space.distTimeDeriv, Space.constantTime_distTimeDeriv

```lean
@[simp]
lemma oneDimPointParticle_electricField_timeDeriv (𝓕 : FreeSpace) (q : ℝ) (r₀ : Space 1) :
    Space.distTimeDeriv ((oneDimPointParticle 𝓕 q r₀).electricField 𝓕.c) = 0 :=
```

## 90. Electromagnetism.DistElectromagneticPotential.wireCurrentDensity_currentDensity_thrd

- split: `train`
- file: `Physlib/Electromagnetism/Current/InfiniteWire.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `5.80`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential.wireCurrentDensity, Electromagnetism.DistLorentzCurrentDensity.currentDensity
  - Relativity: Electromagnetism.DistLorentzCurrentDensity.currentDensity
  - SpaceAndTime: Space.constantTime_apply, Space.constantSliceDist_apply

```lean
@[simp]
lemma wireCurrentDensity_currentDensity_thrd (c : SpeedOfLight) (I : ℝ)
    (ε : 𝓢(Time × Space 3, ℝ)) :
    (wireCurrentDensity c I).currentDensity c ε 2 = 0 :=
```

## 91. Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_electricField_timeDeriv

- split: `train`
- file: `Physlib/Electromagnetism/PointParticle/ThreeDimension.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Particles, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Particles, SpaceAndTime`
- cross_domain_score: `5.80`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle, Electromagnetism.DistElectromagneticPotential.electricField, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_electricField
  - Particles: Electromagnetism.DistElectromagneticPotential.threeDimPointParticle, Electromagnetism.DistElectromagneticPotential.threeDimPointParticle_electricField
  - SpaceAndTime: Space.distTimeDeriv, Space.constantTime_distTimeDeriv

```lean
@[simp]
lemma threeDimPointParticle_electricField_timeDeriv (𝓕 : FreeSpace) (q : ℝ) (r₀ : Space 3) :
    Space.distTimeDeriv ((threeDimPointParticle 𝓕 q r₀).electricField 𝓕.c) = 0 :=
```

## 92. Electromagnetism.DistElectromagneticPotential.wireCurrentDensity_currentDensity_snd

- split: `train`
- file: `Physlib/Electromagnetism/Current/InfiniteWire.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `5.70`
- evidence:
  - Electromagnetism: Electromagnetism.DistElectromagneticPotential.wireCurrentDensity, Electromagnetism.DistLorentzCurrentDensity.currentDensity
  - Relativity: Electromagnetism.DistLorentzCurrentDensity.currentDensity
  - SpaceAndTime: Space.constantTime_apply, Space.constantSliceDist_apply

```lean
@[simp]
lemma wireCurrentDensity_currentDensity_snd (c : SpeedOfLight) (I : ℝ)
    (ε : 𝓢(Time × Space 3, ℝ)) :
    (wireCurrentDensity c I).currentDensity c ε 1 = 0 :=
```

## 93. Electromagnetism.DistElectromagneticPotential.infiniteWire_scalarPotential

- split: `train`
- file: `Physlib/Electromagnetism/Current/InfiniteWire.lean`
- primary_domain: `Electromagnetism`
- domains: `Electromagnetism, Relativity, SpaceAndTime`
- used_premise_domains: `Electromagnetism, Relativity, SpaceAndTime`
- cross_domain_score: `5.70`
- evidence:
  - Electromagnetism: Electromagnetism.FreeSpace, Electromagnetism.DistElectromagneticPotential.infiniteWire, Electromagnetism.DistElectromagneticPotential.scalarPotential
  - Relativity: Lorentz.Vector.temporalCLM
  - SpaceAndTime: Space.constantTime_apply, Space.constantSliceDist_apply, Space.distOfFunction_vector_eval

```lean
@[simp]
lemma infiniteWire_scalarPotential (𝓕 : FreeSpace) (I : ℝ) :
    (infiniteWire 𝓕 I).scalarPotential 𝓕.c = 0 :=
```

## 94. complexLorentzTensor.altLeftLeftUnit_eq_altLeftBasis_leftBasis

- split: `train`
- file: `Physlib/Relativity/Tensors/ComplexTensor/Units/Basic.lean`
- primary_domain: `Relativity`
- domains: `Mathematics, Particles, Relativity`
- used_premise_domains: `Mathematics, Particles, Relativity`
- cross_domain_score: `5.60`
- evidence:
  - Mathematics: TensorSpecies.Tensor.fromPairT, complexLorentzTensor.altLeftLeftUnit_eq_fromPairT
  - Particles: Fermion.altLeftBasis, Fermion.leftBasis, Fermion.altLeftLeftUnitVal_expand_tmul
  - Relativity: complexLorentzTensor.altLeftLeftUnit_eq_fromPairT

```lean
lemma altLeftLeftUnit_eq_altLeftBasis_leftBasis : δL' =
    ∑ i, fromPairT (altLeftBasis i ⊗ₜ[ℂ] leftBasis i) :=
```

## 95. complexLorentzTensor.leftAltLeftUnit_eq_leftBasis_altLeftBasis

- split: `train`
- file: `Physlib/Relativity/Tensors/ComplexTensor/Units/Basic.lean`
- primary_domain: `Relativity`
- domains: `Mathematics, Particles, Relativity`
- used_premise_domains: `Mathematics, Particles, Relativity`
- cross_domain_score: `5.60`
- evidence:
  - Mathematics: TensorSpecies.Tensor.fromPairT, complexLorentzTensor.leftAltLeftUnit_eq_fromPairT
  - Particles: Fermion.leftBasis, Fermion.altLeftBasis, Fermion.leftAltLeftUnitVal_expand_tmul
  - Relativity: complexLorentzTensor.leftAltLeftUnit_eq_fromPairT

```lean
lemma leftAltLeftUnit_eq_leftBasis_altLeftBasis : δL =
    ∑ i, fromPairT (leftBasis i ⊗ₜ[ℂ] altLeftBasis i) :=
```

## 96. complexLorentzTensor.altRightRightUnit_eq_altRightBasis_rightBasis

- split: `train`
- file: `Physlib/Relativity/Tensors/ComplexTensor/Units/Basic.lean`
- primary_domain: `Relativity`
- domains: `Mathematics, Particles, Relativity`
- used_premise_domains: `Mathematics, Particles, Relativity`
- cross_domain_score: `5.60`
- evidence:
  - Mathematics: TensorSpecies.Tensor.fromPairT, complexLorentzTensor.altRightRightUnit_eq_fromPairT
  - Particles: Fermion.altRightBasis, Fermion.rightBasis, Fermion.altRightRightUnitVal_expand_tmul
  - Relativity: complexLorentzTensor.altRightRightUnit_eq_fromPairT

```lean
lemma altRightRightUnit_eq_altRightBasis_rightBasis : δR' =
    ∑ i, fromPairT (altRightBasis i ⊗ₜ[ℂ] rightBasis i) :=
```

## 97. complexLorentzTensor.rightAltRightUnit_eq_rightBasis_altRightBasis

- split: `train`
- file: `Physlib/Relativity/Tensors/ComplexTensor/Units/Basic.lean`
- primary_domain: `Relativity`
- domains: `Mathematics, Particles, Relativity`
- used_premise_domains: `Mathematics, Particles, Relativity`
- cross_domain_score: `5.60`
- evidence:
  - Mathematics: TensorSpecies.Tensor.fromPairT, complexLorentzTensor.rightAltRightUnit_eq_fromPairT
  - Particles: Fermion.rightBasis, Fermion.altRightBasis, Fermion.rightAltRightUnitVal_expand_tmul
  - Relativity: complexLorentzTensor.rightAltRightUnit_eq_fromPairT

```lean
lemma rightAltRightUnit_eq_rightBasis_altRightBasis : δR =
    ∑ i, fromPairT (rightBasis i ⊗ₜ[ℂ] altRightBasis i) :=
```

## 98. complexLorentzTensor.leftMetric_eq_basis

- split: `train`
- file: `Physlib/Relativity/Tensors/ComplexTensor/Metrics/Basic.lean`
- primary_domain: `Relativity`
- domains: `Mathematics, Particles, Relativity`
- used_premise_domains: `Mathematics, Particles, Relativity`
- cross_domain_score: `5.60`
- evidence:
  - Mathematics: TensorSpecies.Tensor.basis, complexLorentzTensor.Color.upL, complexLorentzTensor.leftMetric_eq_leftBasis, TensorSpecies.Tensor.fromPairT_apply_basis_repr
  - Particles: Fermion.leftBasis
  - Relativity: complexLorentzTensor, complexLorentzTensor.Color.upL, complexLorentzTensor.leftMetric_eq_leftBasis

```lean
lemma leftMetric_eq_basis : εL =
    - (Tensor.basis (S := complexLorentzTensor) ![Color.upL, Color.upL] (fun | 0 => 0 | 1 => 1))
    + (Tensor.basis (S := complexLorentzTensor)
      ![Color.upL, Color.upL] (fun | 0 => 1 | 1 => 0)) :=
```

## 99. complexLorentzTensor.altLeftMetric_eq_basis

- split: `train`
- file: `Physlib/Relativity/Tensors/ComplexTensor/Metrics/Basic.lean`
- primary_domain: `Relativity`
- domains: `Mathematics, Particles, Relativity`
- used_premise_domains: `Mathematics, Particles, Relativity`
- cross_domain_score: `5.60`
- evidence:
  - Mathematics: TensorSpecies.Tensor.basis, complexLorentzTensor.Color.downL, complexLorentzTensor.altLeftMetric_eq_altLeftBasis, TensorSpecies.Tensor.fromPairT_apply_basis_repr
  - Particles: Fermion.altLeftBasis
  - Relativity: complexLorentzTensor, complexLorentzTensor.Color.downL, complexLorentzTensor.altLeftMetric_eq_altLeftBasis

```lean
lemma altLeftMetric_eq_basis : εL' =
    (Tensor.basis (S := complexLorentzTensor) ![Color.downL, Color.downL] (fun | 0 => 0 | 1 => 1))
    - (Tensor.basis (S := complexLorentzTensor)
      ![Color.downL, Color.downL] (fun | 0 => 1 | 1 => 0)) :=
```

## 100. complexLorentzTensor.rightMetric_eq_basis

- split: `train`
- file: `Physlib/Relativity/Tensors/ComplexTensor/Metrics/Basic.lean`
- primary_domain: `Relativity`
- domains: `Mathematics, Particles, Relativity`
- used_premise_domains: `Mathematics, Particles, Relativity`
- cross_domain_score: `5.60`
- evidence:
  - Mathematics: TensorSpecies.Tensor.basis, complexLorentzTensor.Color.upR, complexLorentzTensor.rightMetric_eq_rightBasis, TensorSpecies.Tensor.fromPairT_apply_basis_repr
  - Particles: Fermion.rightBasis
  - Relativity: complexLorentzTensor, complexLorentzTensor.Color.upR, complexLorentzTensor.rightMetric_eq_rightBasis

```lean
lemma rightMetric_eq_basis : εR =
    - (Tensor.basis (S := complexLorentzTensor) ![Color.upR, Color.upR] (fun | 0 => 0 | 1 => 1))
    + (Tensor.basis (S := complexLorentzTensor)
      ![Color.upR, Color.upR] (fun | 0 => 1 | 1 => 0)) :=
```

