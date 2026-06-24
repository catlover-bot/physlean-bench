# CSLib test 83

| category | count |
|---|---:|
| both_pass | 2 |
| base_only | 4 |
| lora_only | 1 |
| both_fail | 76 |

## Area counts

| category | area | count |
|---|---|---:|
| both_pass | Cslib.SKI.List | 1 |
| both_pass | Cslib.ωSequence | 1 |
| base_only | Cslib.ωSequence | 2 |
| base_only | Cslib.LambdaCalculus.LocallyNameless | 1 |
| base_only | Cslib.Logic.CLL | 1 |
| lora_only | Cslib.ωSequence | 1 |
| both_fail | Cslib.ωSequence | 27 |
| both_fail | Cslib.LambdaCalculus.LocallyNameless | 12 |
| both_fail | Cslib.ωLanguage | 12 |
| both_fail | Cslib.Logic.CLL | 11 |
| both_fail | Cslib.SKI.List | 8 |
| both_fail | Cslib.URM.Regs | 5 |
| both_fail | Cslib.Automata | 1 |

## Theorem lists

### both_pass
- Cslib.SKI.List.toChurch_nil
- Cslib.ωSequence.tail_cons

### base_only
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.subst_tm_def
- Cslib.Logic.CLL.PhaseSpace.Fact.par_of_linImpl
- Cslib.ωSequence.tail_const
- Cslib.ωSequence.tail_iterate

### lora_only
- Cslib.ωSequence.drop_zero

### both_fail
- Cslib.Automata.NA.hist_run_exists
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.openRec_tm_subst_tm_intro
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.openRec_ty_lc
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.open_tm_subst_ty_var
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.open_ty_subst_ty_intro
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.subst_tm_fresh
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.nmem_fv_open
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.nmem_fv_openRec
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.openRec_lc
- Cslib.LambdaCalculus.LocallyNameless.Stlc.FullBeta.progress
- Cslib.LambdaCalculus.LocallyNameless.Stlc.confluence_preservesTyping
- Cslib.LambdaCalculus.LocallyNameless.Untyped.Term.depth_open_fvar_eq_depth
- Cslib.LambdaCalculus.LocallyNameless.Untyped.Term.multiSubst_app
- Cslib.Logic.CLL.PhaseSpace.Fact.entails_top
- Cslib.Logic.CLL.PhaseSpace.Fact.entails_with
- Cslib.Logic.CLL.PhaseSpace.Fact.le_plus_right
- Cslib.Logic.CLL.PhaseSpace.Fact.par_bot
- Cslib.Logic.CLL.PhaseSpace.Fact.plus_eq_with_dual
- Cslib.Logic.CLL.PhaseSpace.Fact.plus_tensor_distrib
- Cslib.Logic.CLL.PhaseSpace.Fact.tensor_of_linImpl
- Cslib.Logic.CLL.PhaseSpace.Fact.tensor_semi_distrib_with
- Cslib.Logic.CLL.PhaseSpace.isFact_iff_closed
- Cslib.Logic.CLL.PhaseSpace.mem_top
- Cslib.Logic.CLL.PhaseSpace.of_Fact
- Cslib.SKI.List.headD_def
- Cslib.SKI.List.nil_correct
- Cslib.SKI.List.nil_def
- Cslib.SKI.List.succHead_correct
- Cslib.SKI.List.tailFold_correct
- Cslib.SKI.List.tailStep_correct
- Cslib.SKI.List.tail_correct
- Cslib.SKI.List.toChurch_correct
- Cslib.URM.Regs.State.Instr.Program.mem_maxRegister
- Cslib.URM.Regs.State.Instr.capJump_T
- Cslib.URM.Regs.State.Instr.capJump_idempotent
- Cslib.URM.Regs.State.isHalted_iff
- Cslib.URM.Regs.write_read_self
- Cslib.ωLanguage.append_mem_hmul
- Cslib.ωLanguage.hmul_bot
- Cslib.ωLanguage.hmul_def
- Cslib.ωLanguage.hmul_iSup
- Cslib.ωLanguage.hmul_omegaPow_le_omegaPow
- Cslib.ωLanguage.hmul_sup
- Cslib.ωLanguage.iSup_def
- Cslib.ωLanguage.kstar_omegaPow_le_omegaPow
- Cslib.ωLanguage.le_omegaPow_congr
- Cslib.ωLanguage.mem_iInf
- Cslib.ωLanguage.omegaPow_coind
- Cslib.ωLanguage.one_omegaPow
- Cslib.ωSequence.append_ωSequence_head_tail
- Cslib.ωSequence.const_eq
- Cslib.ωSequence.dropLast_take
- Cslib.ωSequence.drop_append_of_le_length
- Cslib.ωSequence.drop_drop
- Cslib.ωSequence.drop_extract
- Cslib.ωSequence.drop_succ
- Cslib.ωSequence.drop_zip
- Cslib.ωSequence.ext
- Cslib.ωSequence.extract_0u_extract_lu
- Cslib.ωSequence.extract_eq_nil_iff
- Cslib.ωSequence.extract_eq_ofFn
- Cslib.ωSequence.flatten_def
- Cslib.ωSequence.flatten_drop
- Cslib.ωSequence.get_append_length
- Cslib.ωSequence.get_append_right'
- Cslib.ωSequence.head_zip
- Cslib.ωSequence.iterate_eq
- Cslib.ωSequence.length_extract
- Cslib.ωSequence.map_cons
- Cslib.ωSequence.map_map
- Cslib.ωSequence.nil_append_ωSequence
- Cslib.ωSequence.tail_zip
- Cslib.ωSequence.take_append_of_le_length
- Cslib.ωSequence.take_drop
- Cslib.ωSequence.take_prefix
- Cslib.ωSequence.take_succ'
