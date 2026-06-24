# Physlib test 680

| category | count |
|---|---:|
| both_pass | 21 |
| base_only | 10 |
| lora_only | 9 |
| both_fail | 640 |

## Area counts

| category | area | count |
|---|---|---:|
| both_pass | TwoHiggsDoublet | 10 |
| both_pass | UnitChoices | 6 |
| both_pass | FieldSpecification | 2 |
| both_pass | MSSMACC | 1 |
| both_pass | QuantumMechanics | 1 |
| both_pass | diagPhase_zero_eq | 1 |
| base_only | QuantumMechanics | 2 |
| base_only | FieldSpecification | 1 |
| base_only | Physlib.Fin | 1 |
| base_only | Physlib.PiTensorProduct | 1 |
| base_only | Space | 1 |
| base_only | TwoHiggsDoublet | 1 |
| base_only | UnitChoices | 1 |
| base_only | WickContraction | 1 |
| base_only | minkowskiMatrix | 1 |
| lora_only | Fermion | 3 |
| lora_only | UnitChoices | 2 |
| lora_only | Lorentz | 1 |
| lora_only | MSSMACC | 1 |
| lora_only | Space | 1 |
| lora_only | TemperatureUnit | 1 |
| both_fail | TwoHiggsDoublet | 71 |
| both_fail | Space | 69 |
| both_fail | TensorSpecies | 66 |
| both_fail | WickContraction | 57 |
| both_fail | FTheory | 48 |
| both_fail | FieldSpecification | 43 |
| both_fail | QuantumMechanics | 39 |
| both_fail | PureU1 | 36 |
| both_fail | minkowskiMatrix | 21 |
| both_fail | SMRHN | 19 |
| both_fail | KroneckerDelta | 18 |
| both_fail | MSSMACC | 16 |
| both_fail | Electromagnetism | 15 |
| both_fail | Lorentz | 13 |
| both_fail | UnitChoices | 13 |
| both_fail | TemperatureUnit | 12 |
| both_fail | complexLorentzTensor | 12 |
| both_fail | Physlib.PiTensorProduct | 11 |
| both_fail | LorentzGroup | 10 |
| both_fail | Fermion | 9 |
| both_fail | Physlib.Fin | 9 |
| both_fail | PauliMatrix | 7 |
| both_fail | Physlib.FourTree | 4 |
| both_fail | Equiv | 3 |
| both_fail | PMNS_dirac_equivalence_refl | 1 |
| both_fail | PMNS_dirac_equivalence_symm | 1 |
| both_fail | PMNS_dirac_equivalence_trans | 1 |
| both_fail | contDiff_tanh | 1 |
| both_fail | contDiff_top_tanh | 1 |
| both_fail | deriv_tanh | 1 |
| both_fail | diagPhaseShift_coe_matrix | 1 |
| both_fail | diagPhase_mul | 1 |
| both_fail | diagPhase_star | 1 |
| both_fail | diagPhase_zero | 1 |
| both_fail | iteratedDeriv_tanh_bounded | 1 |
| both_fail | iteratedDeriv_tanh_const_mul | 1 |
| both_fail | iteratedDeriv_tanh_differentiable | 1 |
| both_fail | iteratedDeriv_tanh_is_polynomial_of_tanh | 1 |
| both_fail | polynomial_bounded_on_interval | 1 |
| both_fail | polynomial_tanh_bounded | 1 |
| both_fail | tanh_const_mul_hasTemperateGrowth | 1 |
| both_fail | tanh_const_mul_iteratedDeriv_norm_eq_iteratedFDeriv_norm | 1 |
| both_fail | tanh_hasTemperateGrowth | 1 |

## Theorem lists

### both_pass
- FieldSpecification.crAnTimeOrderSign_nil
- FieldSpecification.timeOrderSign_nil
- MSSMACC.lineQuad_val
- QuantumMechanics.OneDimension.UnboundedOperator.ofSelfCLM_apply
- TwoHiggsDoublet.PotentialParameters.zero_m₁₁2
- TwoHiggsDoublet.PotentialParameters.zero_m₁₂2
- TwoHiggsDoublet.PotentialParameters.zero_m₂₂2
- TwoHiggsDoublet.PotentialParameters.zero_𝓵₁
- TwoHiggsDoublet.PotentialParameters.zero_𝓵₂
- TwoHiggsDoublet.PotentialParameters.zero_𝓵₃
- TwoHiggsDoublet.PotentialParameters.zero_𝓵₄
- TwoHiggsDoublet.PotentialParameters.zero_𝓵₅
- TwoHiggsDoublet.PotentialParameters.zero_𝓵₆
- TwoHiggsDoublet.PotentialParameters.zero_𝓵₇
- UnitChoices.Dimensionful.smul_apply
- UnitChoices.SI_charge
- UnitChoices.SI_length
- UnitChoices.SI_mass
- UnitChoices.SI_temperature
- UnitChoices.SI_time
- diagPhase_zero_eq

### base_only
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

### lora_only
- Fermion.leftHandedAltEquiv_hom_hom_apply
- Fermion.leftHandedAltTo_hom_apply
- Fermion.leftHandedToAlt_hom_apply
- Lorentz.SL2C.transpose_coe
- MSSMACC.planeY₃B₃_val
- Space.slice_symm_apply
- TemperatureUnit.div_eq_val
- UnitChoices.CarriesDimension.toDimensionful_apply_apply
- UnitChoices.dimScale_apply

### both_fail
- Electromagnetism.ElectromagneticPotential.canonicalMomentum_eq
- Electromagnetism.ElectromagneticPotential.canonicalMomentum_eq_electricField
- Electromagnetism.ElectromagneticPotential.canonicalMomentum_eq_gradient_kineticTerm
- Electromagnetism.ElectromagneticPotential.hamiltonian_eq_electricField_magneticField
- Electromagnetism.ElectromagneticPotential.hamiltonian_eq_electricField_scalarPotential
- Electromagnetism.ElectromagneticPotential.hamiltonian_eq_electricField_vectorPotential
- Electromagnetism.ElectromagneticPotential.vectorPotential_apply_contDiff
- Electromagnetism.ElectromagneticPotential.vectorPotential_apply_contDiff_space
- Electromagnetism.ElectromagneticPotential.vectorPotential_comp_contDiff
- Electromagnetism.ElectromagneticPotential.vectorPotential_contDiff
- Electromagnetism.ElectromagneticPotential.vectorPotential_contDiff_of_smooth
- Electromagnetism.ElectromagneticPotential.vectorPotential_contDiff_space
- Electromagnetism.ElectromagneticPotential.vectorPotential_contDiff_time
- Electromagnetism.ElectromagneticPotential.vectorPotential_differentiable
- Electromagnetism.ElectromagneticPotential.vectorPotential_differentiable_time
- Equiv.Matrix.LinearMap.Matrix.schur_triangulation
- Equiv.finAddEquivSigmaCond_false
- Equiv.finAddEquivSigmaCond_true
- FTheory.SU5.Quanta.isViable_iff_charges_mem_viableCharges
- FTheory.SU5.Quanta.isViable_iff_charges_mem_viableCharges_mem_liftCharges
- FTheory.SU5.Quanta.isViable_iff_def
- FTheory.SU5.Quanta.isViable_iff_filter
- FTheory.SU5.Quanta.isViable_iff_mem_viableElems
- FTheory.SU5.Quanta.isViable_of_mem_viableElems
- FTheory.SU5.Quanta.map_to_Z2_of_isViable
- FTheory.SU5.Quanta.quarticAnomalyCancellation_iff_mem_of_isViable
- FTheory.SU5.Quanta.yukawaSingletsRegenerateDangerousInsertion_two_of_isViable
- FTheory.SU5.TenQuanta.anomalyCoefficient_of_map
- FTheory.SU5.TenQuanta.anomalyCoefficient_of_reduce
- FTheory.SU5.TenQuanta.decomposeFluxes_sum_of_noExotics
- FTheory.SU5.TenQuanta.decompose_add
- FTheory.SU5.TenQuanta.decompose_filter_charge
- FTheory.SU5.TenQuanta.decompose_reduce
- FTheory.SU5.TenQuanta.decompose_toChargeMap
- FTheory.SU5.TenQuanta.decompose_toCharges_dedup
- FTheory.SU5.TenQuanta.decompose_toFluxesTen
- FTheory.SU5.TenQuanta.exists_toCharges_toFluxesTen_of_mem_liftCharge
- FTheory.SU5.TenQuanta.hasNoZero_of_mem_liftCharge
- FTheory.SU5.TenQuanta.map_liftCharge
- FTheory.SU5.TenQuanta.mem_liftCharge_iff
- FTheory.SU5.TenQuanta.mem_liftCharge_iff_exists
- FTheory.SU5.TenQuanta.mem_liftCharge_of_exists_toCharges_toFluxesTen
- FTheory.SU5.TenQuanta.mem_liftCharge_of_mem_noExotics_hasNoZero
- FTheory.SU5.TenQuanta.mem_powerset_sum_of_mem_reduce_toFluxesTen
- FTheory.SU5.TenQuanta.mem_powerset_sum_of_mem_reduce_toFluxesTen_filter
- FTheory.SU5.TenQuanta.mem_reduce_iff
- FTheory.SU5.TenQuanta.noExotics_of_mem_liftCharge
- FTheory.SU5.TenQuanta.reduce_dedup
- FTheory.SU5.TenQuanta.reduce_eq_self_of_ofCharges_nodup
- FTheory.SU5.TenQuanta.reduce_filter
- FTheory.SU5.TenQuanta.reduce_mem_elemsNoExotics
- FTheory.SU5.TenQuanta.reduce_noExotics_of_mem_elemsNoExotics
- FTheory.SU5.TenQuanta.reduce_nodup
- FTheory.SU5.TenQuanta.reduce_numAntiChiralE_of_mem_elemsNoExotics
- FTheory.SU5.TenQuanta.reduce_numAntiChiralQ_of_mem_elemsNoExotics
- FTheory.SU5.TenQuanta.reduce_numAntiChiralU_of_mem_elemsNoExotics
- FTheory.SU5.TenQuanta.reduce_numChiralE_of_mem_elemsNoExotics
- FTheory.SU5.TenQuanta.reduce_numChiralQ_of_mem_elemsNoExotics
- FTheory.SU5.TenQuanta.reduce_numChiralU_of_mem_elemsNoExotics
- FTheory.SU5.TenQuanta.reduce_reduce
- FTheory.SU5.TenQuanta.reduce_sum_eq_sum_toCharges
- FTheory.SU5.TenQuanta.reduce_toChargeMap_eq
- FTheory.SU5.TenQuanta.reduce_toCharges
- FTheory.SU5.TenQuanta.toChargeMap_of_not_mem
- FTheory.SU5.TenQuanta.toCharge_toFinset_of_mem_liftCharge
- FTheory.SU5.TenQuanta.toCharges_nodup_of_mem_liftCharge
- Fermion.altLeftBasis_toFin2ℂ
- Fermion.altLeftBasis_ρ_apply
- Fermion.altRightBasis_toFin2ℂ
- Fermion.altRightBasis_ρ_apply
- Fermion.leftBasis_toFin2ℂ
- Fermion.leftBasis_ρ_apply
- Fermion.leftHandedAltEquiv_inv_hom_apply
- Fermion.rightBasis_toFin2ℂ
- Fermion.rightBasis_ρ_apply
- FieldSpecification.WickAlgebra.normalOrder_timeContract
- FieldSpecification.WickAlgebra.timeContract_eq_smul
- FieldSpecification.WickAlgebra.timeContract_eq_superCommute
- FieldSpecification.WickAlgebra.timeContract_inAsymp_inAsymp
- FieldSpecification.WickAlgebra.timeContract_mem_center
- FieldSpecification.WickAlgebra.timeContract_of_not_timeOrderRel
- FieldSpecification.WickAlgebra.timeContract_of_not_timeOrderRel_expand
- FieldSpecification.WickAlgebra.timeContract_of_timeOrderRel
- FieldSpecification.WickAlgebra.timeContract_outAsymp_outAsymp
- FieldSpecification.WickAlgebra.timeContract_zero_of_diff_grade
- FieldSpecification.WickAlgebra.timeOrder_timeContract_eq_time_left
- FieldSpecification.WickAlgebra.timeOrder_timeContract_eq_time_mid
- FieldSpecification.WickAlgebra.timeOrder_timeContract_ne_time
- FieldSpecification.crAnSectionTimeOrder_bijective
- FieldSpecification.crAnSectionTimeOrder_injective
- FieldSpecification.crAnTimeOrderList_crAnSection_is_crAnSection
- FieldSpecification.crAnTimeOrderList_nil
- FieldSpecification.crAnTimeOrderList_pair_not_ordered
- FieldSpecification.crAnTimeOrderList_pair_ordered
- FieldSpecification.crAnTimeOrderList_swap_eq_time
- FieldSpecification.crAnTimeOrderRel_refl
- FieldSpecification.crAnTimeOrderSign_crAnSection
- FieldSpecification.crAnTimeOrderSign_pair_not_ordered
- FieldSpecification.crAnTimeOrderSign_pair_ordered
- FieldSpecification.crAnTimeOrderSign_swap_eq_time
- FieldSpecification.eraseMaxTimeField_length
- FieldSpecification.koszulSignInsert_crAnTimeOrderRel_crAnSection
- FieldSpecification.lt_maxTimeFieldPosFin_not_timeOrder
- FieldSpecification.maxTimeFieldPos_lt_eraseMaxTimeField_length_succ
- FieldSpecification.maxTimeFieldPos_lt_length
- FieldSpecification.orderedInsert_crAnTimeOrderRel_crAnSection
- FieldSpecification.orderedInsert_crAnTimeOrderRel_injective
- FieldSpecification.orderedInsert_in_swap_eq_time
- FieldSpecification.orderedInsert_swap_eq_time
- FieldSpecification.sum_crAnSections_timeOrder
- FieldSpecification.timeOrderList_eq_maxTimeField_timeOrderList
- FieldSpecification.timeOrderList_nil
- FieldSpecification.timeOrderList_pair_not_ordered
- FieldSpecification.timeOrderList_pair_ordered
- FieldSpecification.timeOrderSign_pair_not_ordered
- FieldSpecification.timeOrderSign_pair_ordered
- FieldSpecification.timeOrder_maxTimeField
- FieldSpecification.timerOrderSign_of_eraseMaxTimeField
- KroneckerDelta.eq_of_coe
- KroneckerDelta.eq_one_of_same
- KroneckerDelta.eq_zero_of_ne
- KroneckerDelta.eq_zero_of_not
- KroneckerDelta.finset_sum_smul
- KroneckerDelta.finset_sum_sum_smul_eq_zero
- KroneckerDelta.smul_eq_zero_iff
- KroneckerDelta.smul_eq_zero_iff'
- KroneckerDelta.smul_eq_zero_iff''
- KroneckerDelta.smul_of_eq_zero
- KroneckerDelta.smul_sub_eq_zero
- KroneckerDelta.smul_symm
- KroneckerDelta.sum_mul
- KroneckerDelta.sum_smul
- KroneckerDelta.sum_sum_smul_eq_zero
- KroneckerDelta.symm
- KroneckerDelta.symmetrize
- KroneckerDelta.symmetrize'
- Lorentz.SL2C.inverse_coe
- Lorentz.SL2C.toLorentzGroup_det_one
- Lorentz.SL2C.toLorentzGroup_eq_pauliBasis'
- Lorentz.SL2C.toLorentzGroup_fst_col
- Lorentz.SL2C.toLorentzGroup_inl_inl
- Lorentz.SL2C.toLorentzGroup_isOrthochronous
- Lorentz.SL2C.toMatrix_apply_contrMod
- Lorentz.SL2C.toMatrix_mem_lorentzGroup
- Lorentz.SL2C.toSelfAdjointMap_apply
- Lorentz.SL2C.toSelfAdjointMap_apply_det
- Lorentz.SL2C.toSelfAdjointMap_apply_pauliBasis'_inl
- Lorentz.SL2C.toSelfAdjointMap_basis
- Lorentz.SL2C.toSelfAdjointMap_pauliBasis
- LorentzGroup.one_le_abs_timeComponent
- LorentzGroup.smul_timeComponent_eq_toVector_minkowskiProduct
- LorentzGroup.toVector_apply
- LorentzGroup.toVector_continuous
- LorentzGroup.toVector_eq_basis_iff_timeComponent_eq_one
- LorentzGroup.toVector_eq_fun
- LorentzGroup.toVector_minkowskiProduct_self
- LorentzGroup.toVector_mul
- LorentzGroup.toVector_neg
- LorentzGroup.toVector_timeComponent
- MSSMACC.lineCube_cube
- MSSMACC.lineCube_quad
- MSSMACC.lineCube_smul
- MSSMACC.lineQuadAFL_quad
- MSSMACC.lineQuad_cube
- MSSMACC.lineQuad_smul
- MSSMACC.planeY₃B₃_cubic
- MSSMACC.planeY₃B₃_eq
- MSSMACC.planeY₃B₃_quad
- MSSMACC.planeY₃B₃_smul
- MSSMACC.planeY₃B₃_val_eq'
- MSSMACC.α₁_proj
- MSSMACC.α₁_proj_zero
- MSSMACC.α₂_proj
- MSSMACC.α₂_proj_zero
- MSSMACC.α₃_proj
- PMNS_dirac_equivalence_refl
- PMNS_dirac_equivalence_symm
- PMNS_dirac_equivalence_trans
- PauliMatrix.asConsTensor_apply_one
- PauliMatrix.asTensor_expand
- PauliMatrix.asTensor_expand_complexContrBasis
- PauliMatrix.leftRightToMatrix_σSA_inl_0_expand
- PauliMatrix.leftRightToMatrix_σSA_inr_0_expand
- PauliMatrix.leftRightToMatrix_σSA_inr_1_expand
- PauliMatrix.leftRightToMatrix_σSA_inr_2_expand
- Physlib.Fin.involutionAddEquiv_cast
- Physlib.Fin.involutionAddEquiv_none_image_zero
- Physlib.Fin.involutionAddEquiv_none_succ
- Physlib.Fin.involutionCons_ext
- Physlib.Fin.involutionNoFixed_card_even
- Physlib.Fin.involutionNoFixed_card_mul_two
- Physlib.Fin.involutionNoFixed_card_mul_two_plus_one
- Physlib.Fin.involutionNoFixed_card_odd
- Physlib.Fin.involutionNoFixed_card_succ
- Physlib.FourTree.exists_of_mem_uniqueMap3
- Physlib.FourTree.exists_of_mem_uniqueMap4
- Physlib.FourTree.map_mem_uniqueMap3
- Physlib.FourTree.map_mem_uniqueMap4
- Physlib.PiTensorProduct.elimPureTensor_update_left
- Physlib.PiTensorProduct.elimPureTensor_update_right
- Physlib.PiTensorProduct.induction_assoc
- Physlib.PiTensorProduct.induction_assoc'
- Physlib.PiTensorProduct.induction_tmul
- Physlib.PiTensorProduct.induction_tmul_mod
- Physlib.PiTensorProduct.pureInl_update_left
- Physlib.PiTensorProduct.pureInl_update_right
- Physlib.PiTensorProduct.pureInr_update_left
- Physlib.PiTensorProduct.pureInr_update_right
- Physlib.PiTensorProduct.tmulEquiv_tmul_tprod
- PureU1.ConstAbsSorted.AFL_even_Boundary
- PureU1.ConstAbsSorted.AFL_even_above
- PureU1.ConstAbsSorted.AFL_even_above'
- PureU1.ConstAbsSorted.AFL_even_below
- PureU1.ConstAbsSorted.AFL_even_below'
- PureU1.ConstAbsSorted.AFL_hasBoundary
- PureU1.ConstAbsSorted.AFL_odd
- PureU1.ConstAbsSorted.AFL_odd_noBoundary
- PureU1.ConstAbsSorted.AFL_odd_zero
- PureU1.ConstAbsSorted.ConstAbs.boundary_value_even
- PureU1.ConstAbsSorted.ConstAbs.boundary_value_odd
- PureU1.ConstAbsSorted.boundary_accGrav'
- PureU1.ConstAbsSorted.boundary_accGrav''
- PureU1.ConstAbsSorted.boundary_castSucc
- PureU1.ConstAbsSorted.boundary_split
- PureU1.ConstAbsSorted.boundary_succ
- PureU1.ConstAbsSorted.gt_eq
- PureU1.ConstAbsSorted.is_zero
- PureU1.ConstAbsSorted.lt_eq
- PureU1.ConstAbsSorted.not_hasBoundary_grav
- PureU1.ConstAbsSorted.not_hasBoundary_zero_le
- PureU1.ConstAbsSorted.not_hasBoundry_zero
- PureU1.ConstAbsSorted.opposite_signs_eq_neg
- PureU1.ConstAbsSorted.val_le_zero
- PureU1.ConstAbsSorted.zero_gt
- PureU1.constAbs_perm
- PureU1.constAbs_sort
- PureU1.lineInPlaneCond_eq_last
- PureU1.lineInPlaneCond_eq_last'
- PureU1.lineInPlaneCond_perm
- PureU1.linesInPlane_constAbs
- PureU1.linesInPlane_constAbs_AF
- PureU1.linesInPlane_constAbs_four
- PureU1.linesInPlane_eq_sq
- PureU1.linesInPlane_eq_sq_four
- PureU1.linesInPlane_four
- QuantumMechanics.OneDimension.UnboundedOperator.isGeneralizedEigenvector_ofSelfCLM_iff
- QuantumMechanics.OneDimension.positionOperatorSchwartz_apply_fun
- QuantumMechanics.OneDimension.positionOperatorUnbounded_isSelfAdjoint
- QuantumMechanics.OneDimension.positionStates_generalized_eigenvector_positionOperatorUnbounded
- QuantumMechanics.angularMomentumSqr_commutation_angularMomentum
- QuantumMechanics.angularMomentumSqr_commutation_momentumSqr
- QuantumMechanics.angularMomentumSqr_commutation_radiusRegPow
- QuantumMechanics.angularMomentumSqr_comp_radiusRegPow_commute
- QuantumMechanics.angularMomentum_commutation_angularMomentum
- QuantumMechanics.angularMomentum_commutation_momentum
- QuantumMechanics.angularMomentum_commutation_momentumSqr
- QuantumMechanics.angularMomentum_commutation_position
- QuantumMechanics.angularMomentum_commutation_radiusRegPow
- QuantumMechanics.angularMomentum_comp_radiusRegPow_commute
- QuantumMechanics.comp_eq_comp_add_commute
- QuantumMechanics.comp_eq_comp_sub_commute
- QuantumMechanics.leibniz_lie
- QuantumMechanics.lie_leibniz
- QuantumMechanics.momentumOperatorSchwartz_isSymmetric
- QuantumMechanics.momentumOperator_apply_fun
- QuantumMechanics.momentumSqr_commutation_momentum
- QuantumMechanics.momentumSqr_comp_angularMomentum_commute
- QuantumMechanics.momentumSqr_comp_momentum_commute
- QuantumMechanics.momentum_commutation_momentum
- QuantumMechanics.momentum_comp_angularMomentum_eq
- QuantumMechanics.momentum_comp_commute
- QuantumMechanics.momentum_comp_position_eq
- QuantumMechanics.momentum_comp_radiusRegPow_eq
- QuantumMechanics.position_commutation_momentum
- QuantumMechanics.position_commutation_momentumSqr
- QuantumMechanics.position_commutation_momentum_momentum
- QuantumMechanics.position_commutation_position
- QuantumMechanics.position_commutation_radiusRegPow
- QuantumMechanics.position_comp_commute
- QuantumMechanics.position_comp_radiusRegPow_commute
- QuantumMechanics.position_position_commutation_momentum
- QuantumMechanics.radiusRegPow_commutation_momentum
- QuantumMechanics.radiusRegPow_commutation_momentumSqr
- QuantumMechanics.radiusRegPow_commutation_radiusRegPow
- SMRHN.PlusU1.QuadSol.accQuad_α₁_α₂
- SMRHN.PlusU1.QuadSol.accQuad_α₁_α₂_zero
- SMRHN.PlusU1.QuadSol.add_AFL_quad
- SMRHN.PlusU1.QuadSol.genericToQuad_ne_zero
- SMRHN.PlusU1.QuadSol.genericToQuad_on_quad
- SMRHN.PlusU1.QuadSol.special_on_quad
- SMRHN.PlusU1.QuadSol.toQuadInv_fst
- SMRHN.PlusU1.QuadSol.toQuadInv_generic
- SMRHN.PlusU1.QuadSol.toQuadInv_special
- SMRHN.PlusU1.QuadSol.toQuadInv_α₁_α₂
- SMRHN.PlusU1.QuadSol.toQuad_rightInverse
- SMRHN.PlusU1.QuadSol.toQuad_surjective
- SMRHN.PlusU1.QuadSol.α₂_AFQ
- SMRHN.PlusU1.exists_plane_exists_basis
- SMRHN.PlusU1.plane_exists_dim_le_7
- SMRHN.SM.SU2Sol
- SMRHN.SM.SU3Sol
- SMRHN.SM.cubeSol
- SMRHN.SM.gravSol
- Space.IsDistBounded.normPowerSeries_deriv
- Space.IsDistBounded.normPowerSeries_fderiv
- Space.IsDistBounded.normPowerSeries_inv
- Space.IsDistBounded.normPowerSeries_log
- Space.IsDistBounded.normPowerSeries_single
- Space.IsDistBounded.normPowerSeries_zpow
- Space.abs_right_le_norm_slice_symm
- Space.basis_self_eq_slice
- Space.basis_succAbove_eq_slice
- Space.deriv_log_normPowerSeries
- Space.deriv_normPowerSeries
- Space.deriv_normPowerSeries_tendsto
- Space.deriv_normPowerSeries_zpow
- Space.differentiable_log_normPowerSeries
- Space.differentiable_normPowerSeries_inv
- Space.differentiable_normPowerSeries_zpow
- Space.distDiv_inv_pow_eq_dim
- Space.distGrad_distOfFunction_log_norm
- Space.distGrad_distOfFunction_norm_zpow
- Space.fderiv_cross_commute
- Space.fderiv_fun_slice_symm_left_apply
- Space.fderiv_fun_slice_symm_right_apply
- Space.fderiv_log_normPowerSeries
- Space.fderiv_normPowerSeries
- Space.fderiv_normPowerSeries_tendsto
- Space.fderiv_normPowerSeries_zpow
- Space.fderiv_slice_symm
- Space.fderiv_slice_symm_left_apply
- Space.fderiv_slice_symm_right_apply
- Space.gradient_dist_normPowerSeries_log
- Space.gradient_dist_normPowerSeries_log_tendsTo
- Space.gradient_dist_normPowerSeries_log_tendsTo_distGrad_norm
- Space.gradient_dist_normPowerSeries_zpow
- Space.gradient_dist_normPowerSeries_zpow_tendsTo_distGrad_norm
- Space.inner_cross_self
- Space.inner_self_cross
- Space.integrable_neg_pow_on_ioi
- Space.integrable_radialAngularMeasure_iff
- Space.integrable_radialAngularMeasure_of_spherical
- Space.integral_radialAngularMeasure
- Space.lintegral_radialMeasure
- Space.lintegral_radialMeasure_eq_spherical_mul
- Space.normPowerSeries_aestronglyMeasurable
- Space.normPowerSeries_differentiable
- Space.normPowerSeries_eq
- Space.normPowerSeries_eq_rpow
- Space.normPowerSeries_inv_le
- Space.normPowerSeries_inv_tendsto
- Space.normPowerSeries_le_norm_sq_add_one
- Space.normPowerSeries_log_le
- Space.normPowerSeries_log_le_normPowerSeries
- Space.normPowerSeries_ne_zero
- Space.normPowerSeries_nonneg
- Space.normPowerSeries_pos
- Space.normPowerSeries_tendsto
- Space.normPowerSeries_zpow_le_norm_sq_add_one
- Space.norm_le_normPowerSeries
- Space.norm_left_le_norm_slice_symm
- Space.norm_lt_normPowerSeries
- Space.norm_slice_symm_eq
- Space.radialAngularMeasure_closedBall
- Space.radialAngularMeasure_eq_volume_withDensity
- Space.radialAngularMeasure_integrable_pow_neg_two
- Space.radialAngularMeasure_real_closedBall
- Space.radialAngularMeasure_zero_eq_volume
- Space.slice_symm_apply_self
- Space.slice_symm_apply_succAbove
- Space.slice_symm_measurableEmbedding
- Space.time_deriv_cross_commute
- TemperatureUnit.div_mul_div_coe
- TemperatureUnit.div_ne_zero
- TemperatureUnit.div_pos
- TemperatureUnit.div_self
- TemperatureUnit.div_symm
- TemperatureUnit.scale_div_scale
- TemperatureUnit.scale_div_self
- TemperatureUnit.scale_one
- TemperatureUnit.scale_scale
- TemperatureUnit.self_div_scale
- TemperatureUnit.val_ne_zero
- TemperatureUnit.val_pos
- TensorSpecies.Tensor.Pure.contrPCoeff_dropPair
- TensorSpecies.Tensor.Pure.contrPCoeff_invariant
- TensorSpecies.Tensor.Pure.contrPCoeff_mul_dropPair
- TensorSpecies.Tensor.Pure.contrPCoeff_permP
- TensorSpecies.Tensor.Pure.contrPCoeff_symm
- TensorSpecies.Tensor.Pure.contrPCoeff_update_dropPairEmb
- TensorSpecies.Tensor.Pure.contrPCoeff_update_fst_add
- TensorSpecies.Tensor.Pure.contrPCoeff_update_fst_smul
- TensorSpecies.Tensor.Pure.contrPCoeff_update_snd_add
- TensorSpecies.Tensor.Pure.contrPCoeff_update_snd_smul
- TensorSpecies.Tensor.Pure.contrP_equivariant
- TensorSpecies.Tensor.Pure.contrP_symm
- TensorSpecies.Tensor.Pure.contrP_update_add
- TensorSpecies.Tensor.Pure.contrP_update_smul
- TensorSpecies.Tensor.Pure.dropPairEmbPre_dropPairEmb
- TensorSpecies.Tensor.Pure.dropPairEmbPre_eq_orderIsoOfFin
- TensorSpecies.Tensor.Pure.dropPairEmbPre_injective
- TensorSpecies.Tensor.Pure.dropPairEmbPre_surjective
- TensorSpecies.Tensor.Pure.dropPairEmb_apply_eq_orderIsoOfFin
- TensorSpecies.Tensor.Pure.dropPairEmb_comm
- TensorSpecies.Tensor.Pure.dropPairEmb_comm_apply
- TensorSpecies.Tensor.Pure.dropPairEmb_dropPairEmbPre
- TensorSpecies.Tensor.Pure.dropPairEmb_eq_iff_eq
- TensorSpecies.Tensor.Pure.dropPairEmb_eq_orderEmbOfFin
- TensorSpecies.Tensor.Pure.dropPairEmb_eq_succAbove_succAbove
- TensorSpecies.Tensor.Pure.dropPairEmb_image_compl
- TensorSpecies.Tensor.Pure.dropPairEmb_injective
- TensorSpecies.Tensor.Pure.dropPairEmb_leq_iff_leq
- TensorSpecies.Tensor.Pure.dropPairEmb_lt_iff_lt
- TensorSpecies.Tensor.Pure.dropPairEmb_monotone
- TensorSpecies.Tensor.Pure.dropPairEmb_ne_fst
- TensorSpecies.Tensor.Pure.dropPairEmb_ne_snd
- TensorSpecies.Tensor.Pure.dropPairEmb_range
- TensorSpecies.Tensor.Pure.dropPairEmb_self_apply
- TensorSpecies.Tensor.Pure.dropPairEmb_succAbove
- TensorSpecies.Tensor.Pure.dropPairEmb_symm
- TensorSpecies.Tensor.Pure.dropPairOfMap_bijective
- TensorSpecies.Tensor.Pure.dropPairOfMap_id
- TensorSpecies.Tensor.Pure.dropPairOfMap_injective
- TensorSpecies.Tensor.Pure.dropPairOfMap_surjective
- TensorSpecies.Tensor.Pure.dropPair_comm
- TensorSpecies.Tensor.Pure.dropPair_equivariant
- TensorSpecies.Tensor.Pure.dropPair_permP
- TensorSpecies.Tensor.Pure.dropPair_symm
- TensorSpecies.Tensor.Pure.dropPair_update_dropPairEmb
- TensorSpecies.Tensor.Pure.dropPair_update_fst
- TensorSpecies.Tensor.Pure.dropPair_update_snd
- TensorSpecies.Tensor.Pure.eq_or_exists_dropPairEmb
- TensorSpecies.Tensor.Pure.evalPCoeff_update_self
- TensorSpecies.Tensor.Pure.evalPCoeff_update_succAbove
- TensorSpecies.Tensor.Pure.evalP_update_add
- TensorSpecies.Tensor.Pure.evalP_update_smul
- TensorSpecies.Tensor.Pure.evalT_pure
- TensorSpecies.Tensor.Pure.fst_ne_dropPairEmb_pre
- TensorSpecies.Tensor.Pure.permCond_dropPairEmb_comm
- TensorSpecies.Tensor.Pure.permCond_dropPairEmb_symm
- TensorSpecies.Tensor.Pure.permCond_dropPairOfMap
- TensorSpecies.Tensor.Pure.snd_ne_dropPairEmb_pre
- TensorSpecies.contrT_single_unitTensor
- TensorSpecies.contrT_unitTensor_dual_single
- TensorSpecies.dual_unitTensor_eq_permT_unitTensor
- TensorSpecies.unitTensor_congr
- TensorSpecies.unitTensor_eq_permT_dual
- TensorSpecies.unitTensor_invariant
- TensorSpecies.unit_app_eq_dual_unit_app
- TensorSpecies.unit_fromSingleTContrFromPairT_eq_fromSingleT
- TwoHiggsDoublet.PotentialParameters.forall_reduced_exists_not_potentialIsStable
- TwoHiggsDoublet.PotentialParameters.gaugeGroupI_smul_massTerm
- TwoHiggsDoublet.PotentialParameters.gaugeGroupI_smul_potential
- TwoHiggsDoublet.PotentialParameters.gaugeGroupI_smul_quarticTerm
- TwoHiggsDoublet.PotentialParameters.massTermReduced_lower_bound
- TwoHiggsDoublet.PotentialParameters.massTermReduced_pos_of_quarticTermReduced_zero_potentialIsStable
- TwoHiggsDoublet.PotentialParameters.massTermReduced_stabilityCounterExample
- TwoHiggsDoublet.PotentialParameters.massTermReduced_zero
- TwoHiggsDoublet.PotentialParameters.massTerm_eq_gramVector
- TwoHiggsDoublet.PotentialParameters.massTerm_stabilityCounterExample
- TwoHiggsDoublet.PotentialParameters.massTerm_zero
- TwoHiggsDoublet.PotentialParameters.massTerm_zero_of_quarticTerm_zero_stabilityCounterExample
- TwoHiggsDoublet.PotentialParameters.potentialIsStable_iff_exists_forall_forall_reduced
- TwoHiggsDoublet.PotentialParameters.potentialIsStable_iff_forall_euclid_lt
- TwoHiggsDoublet.PotentialParameters.potentialIsStable_iff_forall_gramVector
- TwoHiggsDoublet.PotentialParameters.potentialIsStable_iff_massTermReduced_sq_le_quarticTermReduced
- TwoHiggsDoublet.PotentialParameters.potentialIsStable_of_strong
- TwoHiggsDoublet.PotentialParameters.potential_eq_gramVector
- TwoHiggsDoublet.PotentialParameters.potential_stabilityCounterExample
- TwoHiggsDoublet.PotentialParameters.potential_zero
- TwoHiggsDoublet.PotentialParameters.quarticTermReduced_nonneg_of_potentialIsStable
- TwoHiggsDoublet.PotentialParameters.quarticTermReduced_stabilityCounterExample
- TwoHiggsDoublet.PotentialParameters.quarticTermReduced_stabilityCounterExample_nonneg
- TwoHiggsDoublet.PotentialParameters.quarticTermReduced_zero
- TwoHiggsDoublet.PotentialParameters.quarticTerm_eq_gramVector
- TwoHiggsDoublet.PotentialParameters.quarticTerm_stabilityCounterExample
- TwoHiggsDoublet.PotentialParameters.quarticTerm_stabilityCounterExample_eq_norm_pow_four
- TwoHiggsDoublet.PotentialParameters.quarticTerm_stabilityCounterExample_nonneg
- TwoHiggsDoublet.PotentialParameters.quarticTerm_zero
- TwoHiggsDoublet.PotentialParameters.quarticTerm_𝓵₄_expand
- TwoHiggsDoublet.PotentialParameters.stabilityCounterExample_not_potentialIsStable
- TwoHiggsDoublet.PotentialParameters.stabilityCounterExample_η
- TwoHiggsDoublet.PotentialParameters.stabilityCounterExample_ξ
- TwoHiggsDoublet.PotentialParameters.η_symm
- TwoHiggsDoublet.PotentialParameters.η_zero
- TwoHiggsDoublet.PotentialParameters.ξ_zero
- TwoHiggsDoublet.eq_fst_norm_of_eq_gramMatrix
- TwoHiggsDoublet.eq_snd_norm_of_eq_gramMatrix
- TwoHiggsDoublet.gaugeGroupI_exists_fst_eq
- TwoHiggsDoublet.gaugeGroupI_exists_fst_eq_snd_eq
- TwoHiggsDoublet.gaugeGroupI_smul_fst_gramVector
- TwoHiggsDoublet.gaugeGroupI_smul_gramMatrix
- TwoHiggsDoublet.gramMatrix_det_eq
- TwoHiggsDoublet.gramMatrix_det_eq_gramVector
- TwoHiggsDoublet.gramMatrix_det_eq_real
- TwoHiggsDoublet.gramMatrix_det_nonneg
- TwoHiggsDoublet.gramMatrix_eq_component_gramVector
- TwoHiggsDoublet.gramMatrix_eq_gramVector_sum_pauliMatrix
- TwoHiggsDoublet.gramMatrix_selfAdjoint
- TwoHiggsDoublet.gramMatrix_surjective_det_tr
- TwoHiggsDoublet.gramMatrix_tr_nonneg
- TwoHiggsDoublet.gramVector_eq
- TwoHiggsDoublet.gramVector_inl_eq_trace_gramMatrix
- TwoHiggsDoublet.gramVector_inl_nonneg
- TwoHiggsDoublet.gramVector_inl_zero_eq
- TwoHiggsDoublet.gramVector_inl_zero_eq_gramMatrix
- TwoHiggsDoublet.gramVector_inr_one_eq
- TwoHiggsDoublet.gramVector_inr_one_eq_gramMatrix
- TwoHiggsDoublet.gramVector_inr_sum_sq_le_inl
- TwoHiggsDoublet.gramVector_inr_two_eq
- TwoHiggsDoublet.gramVector_inr_two_eq_gramMatrix
- TwoHiggsDoublet.gramVector_inr_zero_eq
- TwoHiggsDoublet.gramVector_inr_zero_eq_gramMatrix
- TwoHiggsDoublet.gramVector_surjective
- TwoHiggsDoublet.mem_orbit_gaugeGroupI_iff_gramMatrix
- TwoHiggsDoublet.mem_orbit_gaugeGroupI_iff_gramVector
- TwoHiggsDoublet.normSq_Φ1_eq_gramVector
- TwoHiggsDoublet.normSq_Φ2_eq_gramVector
- TwoHiggsDoublet.Φ1_inner_Φ2_eq_gramVector
- TwoHiggsDoublet.Φ1_inner_Φ2_normSq_eq_gramVector
- TwoHiggsDoublet.Φ2_inner_Φ1_eq_gramVector
- UnitChoices.dimScale_SIPrimed_SI
- UnitChoices.dimScale_SI_SIPrimed
- UnitChoices.dimScale_coe_mul_symm
- UnitChoices.dimScale_mul_symm
- UnitChoices.dimScale_ne_zero
- UnitChoices.dimScale_of_inv_eq_swap
- UnitChoices.dimScale_one
- UnitChoices.dimScale_pos
- UnitChoices.dimScale_self
- UnitChoices.dimScale_symm
- UnitChoices.dimScale_transitive
- UnitChoices.hasDimension_iff
- UnitChoices.smul_dimScale_injective
- WickContraction.card_congr
- WickContraction.card_zero_iff_empty
- WickContraction.congrLiftInv_rfl
- WickContraction.congrLift_bijective
- WickContraction.congrLift_injective
- WickContraction.congrLift_rfl
- WickContraction.congrLift_surjective
- WickContraction.congr_contractions
- WickContraction.congr_trans
- WickContraction.congr_trans_apply
- WickContraction.eq_filter_mem_self
- WickContraction.eq_fstFieldOfContract_of_mem
- WickContraction.eq_sndFieldOfContract_of_mem
- WickContraction.exists_pair_of_not_eq_empty
- WickContraction.finset_eq_fstFieldOfContract_sndFieldOfContract
- WickContraction.fstFieldOfContract_congr
- WickContraction.fstFieldOfContract_getDual?
- WickContraction.fstFieldOfContract_getDual?_isSome
- WickContraction.fstFieldOfContract_le_sndFieldOfContract
- WickContraction.fstFieldOfContract_lt_sndFieldOfContract
- WickContraction.fstFieldOfContract_mem
- WickContraction.fstFieldOfContract_ne_sndFieldOfContract
- WickContraction.getDual?_congr
- WickContraction.getDual?_congr_get
- WickContraction.getDual?_eq_some_iff_mem
- WickContraction.getDual?_eq_some_neq
- WickContraction.getDual?_getDual?_get_get
- WickContraction.getDual?_getDual?_get_isSome
- WickContraction.getDual?_getDual?_get_not_none
- WickContraction.getDual?_get_self_mem
- WickContraction.getDual?_get_self_neq
- WickContraction.getDual?_isSome_iff
- WickContraction.getDual?_isSome_of_mem
- WickContraction.getDual?_one_eq_none
- WickContraction.gradingCompliant_congr
- WickContraction.mem_congr_iff
- WickContraction.mem_signFinset
- WickContraction.mem_singleton
- WickContraction.mem_singleton_iff
- WickContraction.of_singleton_eq
- WickContraction.prod_finset_eq_mul_fst_snd
- WickContraction.self_getDual?_get_mem
- WickContraction.self_ne_getDual?_get
- WickContraction.singleton_fstFieldOfContract
- WickContraction.singleton_getDual?_eq_none_iff_neq
- WickContraction.singleton_prod
- WickContraction.singleton_sign_expand
- WickContraction.singleton_sndFieldOfContract
- WickContraction.singleton_staticContract
- WickContraction.singleton_timeContract
- WickContraction.singleton_uncontractedEmd_ne_left
- WickContraction.singleton_uncontractedEmd_ne_right
- WickContraction.sndFieldOfContract_congr
- WickContraction.sndFieldOfContract_getDual?
- WickContraction.sndFieldOfContract_getDual?_isSome
- WickContraction.sndFieldOfContract_mem
- WickContraction.subContraction_singleton_eq_singleton
- complexLorentzTensor.altLeftMetric_antisymm
- complexLorentzTensor.altLeftMetric_contr_leftMetric
- complexLorentzTensor.altRightMetric_antisymm
- complexLorentzTensor.altRightMetric_contr_rightMetric
- complexLorentzTensor.coMetric_contr_contrMetric
- complexLorentzTensor.coMetric_symm
- complexLorentzTensor.contrMetric_contr_coMetric
- complexLorentzTensor.contrMetric_symm
- complexLorentzTensor.leftMetric_antisymm
- complexLorentzTensor.leftMetric_contr_altLeftMetric
- complexLorentzTensor.rightMetric_antisymm
- complexLorentzTensor.rightMetric_contr_altRightMetric
- contDiff_tanh
- contDiff_top_tanh
- deriv_tanh
- diagPhaseShift_coe_matrix
- diagPhase_mul
- diagPhase_star
- diagPhase_zero
- iteratedDeriv_tanh_bounded
- iteratedDeriv_tanh_const_mul
- iteratedDeriv_tanh_differentiable
- iteratedDeriv_tanh_is_polynomial_of_tanh
- minkowskiMatrix.as_block
- minkowskiMatrix.as_diagonal
- minkowskiMatrix.det_dual
- minkowskiMatrix.det_eq_neg_one_pow_d
- minkowskiMatrix.dual_apply
- minkowskiMatrix.dual_apply_minkowskiMatrix
- minkowskiMatrix.dual_dual
- minkowskiMatrix.dual_eta
- minkowskiMatrix.dual_id
- minkowskiMatrix.dual_mul
- minkowskiMatrix.dual_transpose
- minkowskiMatrix.eq_transpose
- minkowskiMatrix.inr_i_inr_i
- minkowskiMatrix.mulVec_inl_0
- minkowskiMatrix.mulVec_inr_i
- minkowskiMatrix.mul_η_diag_eq_iff
- minkowskiMatrix.off_diag_zero
- minkowskiMatrix.sq
- minkowskiMatrix.η_apply_mul_η_apply_diag
- minkowskiMatrix.η_apply_sq_eq_one
- minkowskiMatrix.η_diag_ne_zero
- polynomial_bounded_on_interval
- polynomial_tanh_bounded
- tanh_const_mul_hasTemperateGrowth
- tanh_const_mul_iteratedDeriv_norm_eq_iteratedFDeriv_norm
- tanh_hasTemperateGrowth
