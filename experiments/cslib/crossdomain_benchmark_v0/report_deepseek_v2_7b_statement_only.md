# CSLibBench v0: DeepSeek-Prover-V2-7B Baseline

## Overall result

| item | value |
|---|---:|
| n | 415 |
| passed | 71 |
| failed | 344 |
| pass@1 | 0.1711 |
| timeouts | 0 |

## Error types

| type | count |
|---|---:|
| tactic_failed | 118 |
| unknown_identifier | 79 |
| passed | 71 |
| other | 69 |
| syntax_or_parser | 43 |
| unsolved_goals | 34 |
| typeclass | 1 |

## By file

| file | passed | n | pass_rate |
|---|---:|---:|---:|
| `Cslib/Computability/Automata/DA/Congr.lean` | 0 | 2 | 0.000 |
| `Cslib/Computability/Automata/NA/BuchiInter.lean` | 0 | 3 | 0.000 |
| `Cslib/Computability/Automata/NA/Hist.lean` | 0 | 2 | 0.000 |
| `Cslib/Computability/Languages/OmegaLanguage.lean` | 1 | 62 | 0.016 |
| `Cslib/Computability/URM/Basic.lean` | 12 | 19 | 0.632 |
| `Cslib/Foundations/Data/OmegaSequence/Flatten.lean` | 3 | 17 | 0.176 |
| `Cslib/Foundations/Data/OmegaSequence/Init.lean` | 30 | 107 | 0.280 |
| `Cslib/Foundations/Semantics/FLTS/LTSToFLTS.lean` | 0 | 3 | 0.000 |
| `Cslib/Languages/CombinatoryLogic/List.lean` | 2 | 23 | 0.087 |
| `Cslib/Languages/LambdaCalculus/LocallyNameless/Fsub/Opening.lean` | 6 | 43 | 0.140 |
| `Cslib/Languages/LambdaCalculus/LocallyNameless/Fsub/Subtype.lean` | 0 | 9 | 0.000 |
| `Cslib/Languages/LambdaCalculus/LocallyNameless/Stlc/Safety.lean` | 0 | 4 | 0.000 |
| `Cslib/Languages/LambdaCalculus/LocallyNameless/Untyped/LcAt.lean` | 0 | 8 | 0.000 |
| `Cslib/Languages/LambdaCalculus/LocallyNameless/Untyped/MultiSubst.lean` | 0 | 6 | 0.000 |
| `Cslib/Logics/LinearLogic/CLL/PhaseSemantics/Basic.lean` | 17 | 107 | 0.159 |

## Passed theorems

- `Cslib.ωLanguage.flatten_mem_omegaPow`
- `Cslib.URM.Regs.write_read_self`
- `Cslib.URM.Regs.write_read_of_ne`
- `Cslib.URM.Regs.State.Instr.Z_nonJump`
- `Cslib.URM.Regs.State.Instr.S_nonJump`
- `Cslib.URM.Regs.State.Instr.J_IsJump`
- `Cslib.URM.Regs.State.Instr.shiftJumps_of_nonJump`
- `Cslib.URM.Regs.State.Instr.jumpsBoundedBy_of_nonJump`
- `Cslib.URM.Regs.State.Instr.capJump_Z`
- `Cslib.URM.Regs.State.Instr.capJump_S`
- `Cslib.URM.Regs.State.Instr.capJump_T`
- `Cslib.URM.Regs.State.Instr.capJump_J`
- `Cslib.URM.Regs.State.Instr.capJump_idempotent`
- `Cslib.ωSequence.get_fun`
- `Cslib.ωSequence.get_zero_cons`
- `Cslib.ωSequence.head_cons`
- `Cslib.ωSequence.tail_cons`
- `Cslib.ωSequence.tail_eq_drop`
- `Cslib.ωSequence.get_tail`
- `Cslib.ωSequence.drop_tail'`
- `Cslib.ωSequence.get_succ`
- `Cslib.ωSequence.get_succ_cons`
- `Cslib.ωSequence.append_eq_cons`
- `Cslib.ωSequence.drop_succ`
- `Cslib.ωSequence.cons_injective_left`
- `Cslib.ωSequence.get_map`
- `Cslib.ωSequence.head_map`
- `Cslib.ωSequence.map_id`
- `Cslib.ωSequence.map_map`
- `Cslib.ωSequence.get_zip`
- `Cslib.ωSequence.tail_zip`
- `Cslib.ωSequence.tail_const`
- `Cslib.ωSequence.map_const`
- `Cslib.ωSequence.get_const`
- `Cslib.ωSequence.drop_const`
- `Cslib.ωSequence.get_zero_iterate`
- `Cslib.ωSequence.nil_append_ωSequence`
- `Cslib.ωSequence.get_append_right`
- `Cslib.ωSequence.take_zero`
- `Cslib.ωSequence.take_succ`
- `Cslib.ωSequence.take_succ_cons`
- `Cslib.ωSequence.extract_eq_drop_take`
- `Cslib.ωSequence.extract_eq_take`
- `Cslib.ωSequence.cumLen_zero`
- `Cslib.ωSequence.flatten_def`
- `Cslib.ωSequence.toSegs_def`
- `Cslib.SKI.List.toChurch_nil`
- `Cslib.SKI.List.toChurch_cons`
- `Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.subst_def`
- `Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.nmem_fv_open`
- `Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.subst_ty_def`
- `Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.subst_tm_def`
- `Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.Binding.subst_sub`
- `Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.Binding.subst_ty`
- `Cslib.Logic.CLL.PhaseSpace.orthogonal_def`
- `Cslib.Logic.CLL.PhaseSpace.orth_antitone`
- `Cslib.Logic.CLL.PhaseSpace.mem_dual`
- `Cslib.Logic.CLL.PhaseSpace.mem_carrier`
- `Cslib.Logic.CLL.PhaseSpace.dual_subset_dual`
- `Cslib.Logic.CLL.PhaseSpace.orth_one_eq_bot`
- `Cslib.Logic.CLL.PhaseSpace.coe_one`
- `Cslib.Logic.CLL.PhaseSpace.one_mem_one`
- `Cslib.Logic.CLL.PhaseSpace.coe_top`
- `Cslib.Logic.CLL.PhaseSpace.dual_empty`
- `Cslib.Logic.CLL.PhaseSpace.dualFact_empty`
- `Cslib.Logic.CLL.PhaseSpace.coe_min`
- `Cslib.Logic.CLL.PhaseSpace.Fact.coe_neg`
- `Cslib.Logic.CLL.PhaseSpace.Fact.neg_surjective`
- `Cslib.Logic.CLL.PhaseSpace.Fact.par_of_linImpl`
- `Cslib.Logic.CLL.PhaseSpace.Fact.neg_par`
- `Cslib.Logic.CLL.PhaseSpace.Fact.mul_subset_tensor`