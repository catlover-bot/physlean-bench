# Physlib Base vs Physlib-only LoRA Summary

## Main Results

| Split | N | Base Pass | Base Rate | Physlib LoRA Pass | LoRA Rate | Delta |
|---|---:|---:|---:|---:|---:|---:|
| valid | 491 | 24 | 4.89% | 37 | 7.54% | +13 |
| test | 680 | 31 | 4.56% | 30 | 4.41% | -1 |

## Overlap Analysis

| Split | Both Pass | Base Only | LoRA Only | Both Fail |
|---|---:|---:|---:|---:|
| valid | 18 | 6 | 19 | 448 |
| test | 21 | 10 | 9 | 640 |

## Interpretation

Physlib-only LoRA improves on the validation split but does not improve on the held-out test split.

- Valid: base 24/491 vs LoRA 37/491
- Test: base 31/680 vs LoRA 30/680

This indicates that Physlib-only fine-tuning changes the success distribution, but the validation improvement does not directly transfer to the test split.

## Test Base-only Successes

- FieldSpecification.crAnFieldOpToFieldOp_prod
- Physlib.Fin.involutionAddEquiv_cast'
- Physlib.PiTensorProduct.induction_mod_tmul
- QuantumMechanics.OneDimension.positionOperatorSchwartz_apply
- QuantumMechanics.momentumOperator_apply
- Space.gradient_dist_normPowerSeries_zpow_tendsTo
- TwoHiggsDoublet.PotentialParameters.potentialIsStable_iff_forall_euclid
- UnitChoices.Dimensionful.ext
- WickContraction.congr_refl
- minkowskiMatrix.inl_0_inl_0

## Test LoRA-only Successes

- Fermion.leftHandedAltEquiv_hom_hom_apply
- Fermion.leftHandedAltTo_hom_apply
- Fermion.leftHandedToAlt_hom_apply
- Lorentz.SL2C.transpose_coe
- MSSMACC.planeY₃B₃_val
- Space.slice_symm_apply
- TemperatureUnit.div_eq_val
- UnitChoices.CarriesDimension.toDimensionful_apply_apply
- UnitChoices.dimScale_apply
