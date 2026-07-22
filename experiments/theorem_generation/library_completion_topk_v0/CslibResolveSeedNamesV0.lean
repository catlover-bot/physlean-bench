import Cslib.Computability.Automata.NA.BuchiEquiv
import Cslib.Computability.Automata.NA.BuchiInter
import Cslib.Computability.Automata.NA.Hist
import Cslib.Computability.Automata.NA.Loop
import Cslib.Computability.Automata.NA.Sum
import Cslib.Computability.URM.Basic
import Cslib.Computability.URM.Execution
import Cslib.Computability.URM.StandardForm
import Cslib.Computability.URM.StraightLine
import Cslib.Foundations.Data.Nat.Segment
import Cslib.Foundations.Data.OmegaSequence.Flatten
import Cslib.Foundations.Data.OmegaSequence.InfOcc
import Cslib.Foundations.Data.OmegaSequence.Init
import Cslib.Foundations.Data.RelatesInSteps
import Cslib.Foundations.Data.Relation
import Cslib.Foundations.Data.StackTape
import Cslib.Foundations.Semantics.FLTS.Basic
import Cslib.Foundations.Semantics.FLTS.LTSToFLTS
import Cslib.Foundations.Semantics.LTS.Basic
import Cslib.Foundations.Semantics.LTS.Execution
import Cslib.Foundations.Semantics.LTS.HasTau
import Cslib.Foundations.Semantics.LTS.Total
import Cslib.Languages.CCS.Basic
import Cslib.Languages.CCS.BehaviouralTheory
import Cslib.Logics.HML.Basic
import Cslib.Logics.HML.LogicalEquivalence

set_option autoImplicit false

/- guessed: Cslib.URM.Instr.capJump_S -/
#check Cslib.URM.Instr.capJump_S
#check capJump_Z
#check Cslib.URM.capJump_Z
#check Cslib.URM.Program.capJump_Z
#check Cslib.URM.Instr.capJump_Z
#check Cslib.URM.Steps.capJump_Z
#check URM.Instr.capJump_S

/- guessed: Cslib.URM.Instr.capJump_T -/
#check Cslib.URM.Instr.capJump_T
#check capJump_S
#check Cslib.URM.capJump_S
#check Cslib.URM.Program.capJump_S
#check Cslib.URM.Instr.capJump_S
#check Cslib.URM.Steps.capJump_S
#check URM.Instr.capJump_T

/- guessed: Cslib.CCS.bisimilarity_par_nil -/
#check Cslib.CCS.bisimilarity_par_nil
#check bisimilarity_par_nil
#check CCS.bisimilarity_par_nil

/- guessed: Cslib.CCS.bisimilarity_nil_par -/
#check Cslib.CCS.bisimilarity_nil_par
#check bisimilarity_nil_par
#check CCS.bisimilarity_nil_par

/- guessed: Cslib.URM.straightLine_finalState_spec -/
#check Cslib.URM.straightLine_finalState_spec
#check straightLine_finalState_spec
#check Cslib.URM.Program.straightLine_finalState_spec
#check Cslib.URM.Instr.straightLine_finalState_spec
#check Cslib.URM.Steps.straightLine_finalState_spec
#check URM.straightLine_finalState_spec

/- guessed: Cslib.URM.straightLine_finalRegs_eq_of_halted -/
#check Cslib.URM.straightLine_finalRegs_eq_of_halted
#check straightLine_finalRegs_eq_of_halted
#check Cslib.URM.Program.straightLine_finalRegs_eq_of_halted
#check Cslib.URM.Instr.straightLine_finalRegs_eq_of_halted
#check Cslib.URM.Steps.straightLine_finalRegs_eq_of_halted
#check URM.straightLine_finalRegs_eq_of_halted

/- guessed: Cslib.frequently_iff_strictMono -/
#check Cslib.frequently_iff_strictMono
#check frequently_iff_strictMono
#check Cslib.ωSequence.frequently_iff_strictMono

/- guessed: Cslib.frequently_in_strictMono -/
#check Cslib.frequently_in_strictMono
#check frequently_in_strictMono
#check Cslib.ωSequence.frequently_in_strictMono

/- guessed: Cslib.theoryEq_isBisimulation -/
#check Cslib.theoryEq_isBisimulation
#check theoryEq_isBisimulation
#check Cslib.Logic.HML.theoryEq_isBisimulation

/- guessed: Cslib.theoryEq_eq_bisimilarity -/
#check Cslib.theoryEq_eq_bisimilarity
#check theoryEq_eq_bisimilarity
#check Cslib.Logic.HML.theoryEq_eq_bisimilarity

/- guessed: Cslib.URM.Steps.toStandardForm_halts -/
#check Cslib.URM.Steps.toStandardForm_halts
#check Steps.toStandardForm_halts
#check Cslib.URM.Program.Steps.toStandardForm_halts
#check Cslib.URM.Instr.Steps.toStandardForm_halts
#check Cslib.URM.Steps.Steps.toStandardForm_halts
#check URM.Steps.toStandardForm_halts

/- guessed: Cslib.URM.Steps.from_toStandardForm_halts -/
#check Cslib.URM.Steps.from_toStandardForm_halts
#check Steps.from_toStandardForm_halts
#check Cslib.URM.Program.Steps.from_toStandardForm_halts
#check Cslib.URM.Instr.Steps.from_toStandardForm_halts
#check Cslib.URM.Steps.Steps.from_toStandardForm_halts
#check URM.Steps.from_toStandardForm_halts

/- guessed: Cslib.Relation.RelatesWithinSteps.zero -/
#check Cslib.Relation.RelatesWithinSteps.zero
#check RelatesWithinSteps.single
#check Relation.RelatesWithinSteps.single
#check Relation.RelatesWithinSteps.zero

/- guessed: Cslib.Relation.RelatesWithinSteps.zero_iff -/
#check Cslib.Relation.RelatesWithinSteps.zero_iff
#check RelatesWithinSteps.zero_iff
#check Relation.RelatesWithinSteps.zero_iff

/- guessed: Cslib.Automata.NA.Buchi.reindex_run_iff -/
#check Cslib.Automata.NA.Buchi.reindex_run_iff
#check reindex_run_iff
#check Automata.NA.Buchi.reindex_run_iff

/- guessed: Cslib.Automata.NA.Buchi.reindex_run_iff' -/
#check Cslib.Automata.NA.Buchi.reindex_run_iff'
#check reindex_run_iff'
#check Automata.NA.Buchi.reindex_run_iff'

/- guessed: Cslib.take_succ_cons -/
#check Cslib.take_succ_cons
#check take_succ_cons
#check Cslib.ωSequence.take_succ_cons

/- guessed: Cslib.take_succ' -/
#check Cslib.take_succ'
#check take_succ_cons
#check Cslib.ωSequence.take_succ_cons
#check Cslib.take_succ_cons
#check take_succ'

/- guessed: Cslib.LTS.totalize.nonsink_tr_iff -/
#check Cslib.LTS.totalize.nonsink_tr_iff
#check totalize.nonsink_tr_iff
#check LTS.totalize.nonsink_tr_iff

/- guessed: Cslib.LTS.totalize.nonsink_mtr_iff -/
#check Cslib.LTS.totalize.nonsink_mtr_iff
#check totalize.nonsink_mtr_iff
#check LTS.totalize.nonsink_mtr_iff

/- guessed: Cslib.Automata.NA.iSum_run_iff -/
#check Cslib.Automata.NA.iSum_run_iff
#check iSum_run_iff
#check Cslib.Automata.NA.Buchi.iSum_run_iff
#check Automata.NA.iSum_run_iff

/- guessed: Cslib.Automata.NA.Buchi.iSum_language_eq -/
#check Cslib.Automata.NA.Buchi.iSum_language_eq
#check iSum_language_eq
#check Cslib.Automata.NA.iSum_language_eq
#check Automata.NA.Buchi.iSum_language_eq

/- guessed: Cslib.Nat.strictMono_infinite -/
#check Cslib.Nat.strictMono_infinite
#check strictMono_infinite
#check Nat.strictMono_infinite

/- guessed: Cslib.Nat.infinite_strictMono -/
#check Cslib.Nat.infinite_strictMono
#check infinite_strictMono
#check Nat.infinite_strictMono

/- guessed: Cslib.Automata.NA.hist_run_proj -/
#check Cslib.Automata.NA.hist_run_proj
#check hist_run_proj
#check Cslib.Automata.NA.Buchi.hist_run_proj
#check Automata.NA.hist_run_proj

/- guessed: Cslib.Automata.NA.hist_run_exists -/
#check Cslib.Automata.NA.hist_run_exists
#check hist_run_exists
#check Cslib.Automata.NA.Buchi.hist_run_exists
#check Automata.NA.hist_run_exists

/- guessed: Cslib.LTS.MTr.single -/
#check Cslib.LTS.MTr.single
#check MTr.single
#check LTS.MTr.single

/- guessed: Cslib.LTS.MTr.single_invert -/
#check Cslib.LTS.MTr.single_invert
#check MTr.single_invert
#check LTS.MTr.single_invert

/- guessed: Cslib.Turing.StackTape.nil_toList -/
#check Cslib.Turing.StackTape.nil_toList
#check empty_eq_nil
#check Cslib.empty_eq_nil
#check Turing.StackTape.nil_toList

/- guessed: Cslib.Turing.StackTape.empty_eq_nil -/
#check Cslib.Turing.StackTape.empty_eq_nil
#check empty_eq_nil
#check Cslib.empty_eq_nil
#check Turing.StackTape.empty_eq_nil

/- guessed: Cslib.cumLen_one_add_drop -/
#check Cslib.cumLen_one_add_drop
#check cumLen_one_add_drop
#check Cslib.ωSequence.cumLen_one_add_drop

/- guessed: Cslib.cumLen_segment_one_add -/
#check Cslib.cumLen_segment_one_add
#check cumLen_segment_one_add
#check Cslib.ωSequence.cumLen_segment_one_add

/- guessed: Cslib.LTS.toFLTS_mem_mtr -/
#check Cslib.LTS.toFLTS_mem_mtr
#check toFLTS_mem_mtr
#check Cslib.FLTS.toFLTS_mem_mtr
#check LTS.toFLTS_mem_mtr

/- guessed: Cslib.LTS.toFLTS_mtr_setImageMultistep -/
#check Cslib.LTS.toFLTS_mtr_setImageMultistep
#check toFLTS_mtr_setImageMultistep
#check Cslib.FLTS.toFLTS_mtr_setImageMultistep
#check LTS.toFLTS_mtr_setImageMultistep

/- guessed: Cslib.Automata.NA.Buchi.inter_freq_acc_freq_acc -/
#check Cslib.Automata.NA.Buchi.inter_freq_acc_freq_acc
#check inter_freq_acc_freq_acc
#check Automata.NA.Buchi.inter_freq_acc_freq_acc

/- guessed: Cslib.Automata.NA.Buchi.inter_freq_comp_acc_freq_acc -/
#check Cslib.Automata.NA.Buchi.inter_freq_comp_acc_freq_acc
#check inter_freq_comp_acc_freq_acc
#check Automata.NA.Buchi.inter_freq_comp_acc_freq_acc

/- guessed: Cslib.Relation.Confluent.toChurchRosser -/
#check Cslib.Relation.Confluent.toChurchRosser
#check Confluent.toChurchRosser
#check Relation.Confluent.toChurchRosser

/- guessed: Cslib.Relation.Confluent_iff_ChurchRosser -/
#check Cslib.Relation.Confluent_iff_ChurchRosser
#check SemiConfluent_iff_ChurchRosser
#check Relation.SemiConfluent_iff_ChurchRosser
#check Relation.Confluent_iff_ChurchRosser

/- guessed: Cslib.URM.Steps.preserves_register -/
#check Cslib.URM.Steps.preserves_register
#check preserves_register
#check Cslib.URM.preserves_register
#check Cslib.URM.Program.preserves_register
#check Cslib.URM.Instr.preserves_register
#check URM.Steps.preserves_register

/- guessed: Cslib.URM.Steps.eq_of_halts -/
#check Cslib.URM.Steps.eq_of_halts
#check eq_of_halts
#check Cslib.URM.eq_of_halts
#check Cslib.URM.Program.eq_of_halts
#check Cslib.URM.Instr.eq_of_halts
#check URM.Steps.eq_of_halts

/- guessed: Cslib.Automata.NA.loop_run_left_left -/
#check Cslib.Automata.NA.loop_run_left_left
#check loop_run_left_left
#check Cslib.Automata.NA.Buchi.loop_run_left_left
#check Automata.NA.loop_run_left_left

/- guessed: Cslib.Automata.NA.loop_run_left_right_left -/
#check Cslib.Automata.NA.loop_run_left_right_left
#check loop_run_left_right_left
#check Cslib.Automata.NA.Buchi.loop_run_left_right_left
#check Automata.NA.loop_run_left_right_left

/- guessed: Cslib.Logic.HML.Proposition.equiv_def -/
#check Cslib.Logic.HML.Proposition.equiv_def
#check Proposition.equiv_def
#check Logic.HML.Proposition.equiv_def

/- guessed: Cslib.Logic.HML.Satisfies.bundled_char -/
#check Cslib.Logic.HML.Satisfies.bundled_char
#check Satisfies.Bundled
#check Cslib.Logic.HML.Satisfies.Bundled
#check Logic.HML.Satisfies.bundled_char

/- guessed: Cslib.LTS.sTr_ -/
#check Cslib.LTS.sTr_
#check sTr_
#check LTS.sTr_

/- guessed: Cslib.LTS.STr.single -/
#check Cslib.LTS.STr.single
#check STr.single
#check LTS.STr.single

/- guessed: Cslib.Logic.HML.satisfies_finiteAnd -/
#check Cslib.Logic.HML.satisfies_finiteAnd
#check satisfies_finiteAnd
#check Logic.HML.satisfies_finiteAnd

/- guessed: Cslib.Logic.HML.satisfies_finiteOr -/
#check Cslib.Logic.HML.satisfies_finiteOr
#check satisfies_finiteOr
#check Logic.HML.satisfies_finiteOr

/- guessed: Cslib.FLTS.mtr_concat_eq -/
#check Cslib.FLTS.mtr_concat_eq
#check mtr_nil_eq
#check Cslib.FLTS.mtr_nil_eq
#check FLTS.mtr_concat_eq

/- guessed: Cslib.FLTS.mtr_nil_eq -/
#check Cslib.FLTS.mtr_nil_eq
#check mtr
#check Cslib.FLTS.mtr
#check FLTS.mtr_nil_eq

/- guessed: Cslib.URM.Program.toStandardForm_isStandardForm -/
#check Cslib.URM.Program.toStandardForm_isStandardForm
#check toStandardForm_isStandardForm
#check Cslib.URM.toStandardForm_isStandardForm
#check Cslib.URM.Instr.toStandardForm_isStandardForm
#check Cslib.URM.Steps.toStandardForm_isStandardForm
#check URM.Program.toStandardForm_isStandardForm

/- guessed: Cslib.URM.toStandardForm_equiv -/
#check Cslib.URM.toStandardForm_equiv
#check toStandardForm_equiv
#check Cslib.URM.Program.toStandardForm_equiv
#check Cslib.URM.Instr.toStandardForm_equiv
#check Cslib.URM.Steps.toStandardForm_equiv
#check URM.toStandardForm_equiv

/- guessed: Cslib.LTS.Execution.of_mTr -/
#check Cslib.LTS.Execution.of_mTr
#check Execution.of_mTr
#check LTS.Execution.of_mTr

/- guessed: Cslib.LTS.mTr_iff_execution -/
#check Cslib.LTS.mTr_iff_execution
#check mTr_iff_execution
#check LTS.mTr_iff_execution

/- guessed: Cslib.CCS.Act.Co.symm -/
#check Cslib.CCS.Act.Co.symm
#check Co.symm
#check Cslib.CCS.Co.symm
#check CCS.Act.Co.symm

/- guessed: Cslib.CCS.Act.co_isVisible -/
#check Cslib.CCS.Act.co_isVisible
#check co_isVisible
#check Cslib.CCS.co_isVisible
#check CCS.Act.co_isVisible

/- guessed: Cslib.extract_eq_nil -/
#check Cslib.extract_eq_nil
#check extract_eq_nil
#check Cslib.ωSequence.extract_eq_nil

/- guessed: Cslib.extract_eq_nil_iff -/
#check Cslib.extract_eq_nil_iff
#check extract_eq_nil_iff
#check Cslib.ωSequence.extract_eq_nil_iff

/- guessed: Cslib.Relation.RelatesInSteps.zero -/
#check Cslib.Relation.RelatesInSteps.zero
#check RelatesInSteps.zero
#check Relation.RelatesInSteps.zero

/- guessed: Cslib.Relation.RelatesInSteps.zero_iff -/
#check Cslib.Relation.RelatesInSteps.zero_iff
#check RelatesInSteps.zero_iff
#check Relation.RelatesInSteps.zero_iff
