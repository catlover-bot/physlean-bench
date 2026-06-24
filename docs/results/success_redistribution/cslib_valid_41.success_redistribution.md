# CSLib valid 41

| category | count |
|---|---:|
| both_pass | 1 |
| base_only | 2 |
| lora_only | 6 |
| both_fail | 32 |

## Area counts

| category | area | count |
|---|---|---:|
| both_pass | Cslib.ωLanguage | 1 |
| base_only | Cslib.Logic.CLL | 1 |
| base_only | Cslib.ωSequence | 1 |
| lora_only | Cslib.LambdaCalculus.LocallyNameless | 2 |
| lora_only | Cslib.Logic.CLL | 2 |
| lora_only | Cslib.URM.Regs | 1 |
| lora_only | Cslib.ωLanguage | 1 |
| both_fail | Cslib.Logic.CLL | 12 |
| both_fail | Cslib.ωSequence | 6 |
| both_fail | Cslib.LambdaCalculus.LocallyNameless | 5 |
| both_fail | Cslib.ωLanguage | 5 |
| both_fail | Cslib.SKI.List | 3 |
| both_fail | Cslib.URM.Regs | 1 |

## Theorem lists

### both_pass
- Cslib.ωLanguage.toSet_ofSet

### base_only
- Cslib.Logic.CLL.PhaseSpace.orth_iUnion
- Cslib.ωSequence.drop_const

### lora_only
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.Binding.subst_sub
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.open_subst_intro
- Cslib.Logic.CLL.PhaseSpace.Fact.par_comm
- Cslib.Logic.CLL.PhaseSpace.coe_min
- Cslib.URM.Regs.State.Instr.JumpsBoundedBy.capJump
- Cslib.ωLanguage.compl_def

### both_fail
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.openRec_ty_subst_tm
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.open_ty_subst_tm
- Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.subst_ty_fresh
- Cslib.LambdaCalculus.LocallyNameless.Untyped.Term.lcAt_open_fvar_iff_lcAt
- Cslib.LambdaCalculus.LocallyNameless.Untyped.Term.multiSubst_open_var
- Cslib.Logic.CLL.PhaseSpace.Fact.bot_par
- Cslib.Logic.CLL.PhaseSpace.Fact.le_plus_left
- Cslib.Logic.CLL.PhaseSpace.Fact.neg_eq_iff
- Cslib.Logic.CLL.PhaseSpace.Fact.neg_with
- Cslib.Logic.CLL.PhaseSpace.Fact.tensor_distrib_plus
- Cslib.Logic.CLL.PhaseSpace.Fact.tensor_one
- Cslib.Logic.CLL.PhaseSpace.Fact.with_assoc
- Cslib.Logic.CLL.PhaseSpace.Fact.with_eq_plus_dual
- Cslib.Logic.CLL.PhaseSpace.Fact.with_top
- Cslib.Logic.CLL.PhaseSpace.mem_zero
- Cslib.Logic.CLL.PhaseSpace.mul_mem_one
- Cslib.Logic.CLL.PhaseSpace.sInf_isFact
- Cslib.SKI.List.prependZero_correct
- Cslib.SKI.List.singleton_correct
- Cslib.SKI.List.toChurch_cons
- Cslib.URM.Regs.State.Instr.Z_nonJump
- Cslib.ωLanguage.add_hmul
- Cslib.ωLanguage.mem_def
- Cslib.ωLanguage.mem_iSup
- Cslib.ωLanguage.mem_top
- Cslib.ωLanguage.zero_omegaPow
- Cslib.ωSequence.append_append_ωSequence
- Cslib.ωSequence.cons_flatten
- Cslib.ωSequence.extract_succ_right
- Cslib.ωSequence.get_extract
- Cslib.ωSequence.map_tail
- Cslib.ωSequence.take_add
