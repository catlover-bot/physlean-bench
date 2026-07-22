import Cslib.Computability.URM.Basic
import Cslib.Computability.URM.StraightLine
import Cslib.Computability.URM.StandardForm
import Cslib.Computability.URM.Execution
import Cslib.Foundations.Data.RelatesInSteps
import Cslib.Foundations.Data.Relation
import Cslib.Foundations.Data.Nat.Segment
import Cslib.Foundations.Data.StackTape
import Cslib.Foundations.Semantics.LTS.Basic
import Cslib.Foundations.Semantics.LTS.Total
import Cslib.Foundations.Semantics.LTS.HasTau
import Cslib.Foundations.Semantics.LTS.Execution
import Cslib.Logics.HML.Basic
import Cslib.Logics.HML.LogicalEquivalence

#check Cslib.URM.Instr.capJump_S
#check Cslib.URM.Instr.capJump_T

#check Cslib.URM.straightLine_finalState_spec
#check Cslib.URM.straightLine_finalRegs_eq_of_halted

#check Cslib.Logic.HML.theoryEq_isBisimulation
#check Cslib.Logic.HML.theoryEq_eq_bisimilarity

#check Cslib.URM.Steps.toStandardForm_halts
#check Cslib.URM.Steps.from_toStandardForm_halts

#check Relation.RelatesWithinSteps.zero
#check Relation.RelatesWithinSteps.zero_iff

#check Cslib.LTS.totalize.nonsink_tr_iff
#check Cslib.LTS.totalize.nonsink_mtr_iff

#check Nat.strictMono_infinite
#check Nat.infinite_strictMono

#check Cslib.LTS.MTr.single
#check Cslib.LTS.MTr.single_invert

#check Turing.StackTape.nil_toList
#check Turing.StackTape.empty_eq_nil

#check Relation.Confluent.toChurchRosser
#check Relation.Confluent_iff_ChurchRosser

#check Cslib.URM.Steps.preserves_register
#check Cslib.URM.Steps.eq_of_halts

#check Cslib.Logic.HML.Proposition.equiv_def
#check Cslib.Logic.HML.Satisfies.bundled_char

#check Cslib.LTS.sTr_τSTr
#check Cslib.LTS.STr.single

#check Cslib.Logic.HML.satisfies_finiteAnd
#check Cslib.Logic.HML.satisfies_finiteOr

#check Cslib.URM.Program.toStandardForm_isStandardForm
#check Cslib.URM.toStandardForm_equiv

#check Cslib.LTS.Execution.of_mTr
#check Cslib.LTS.mTr_iff_execution

#check Relation.RelatesInSteps.zero
#check Relation.RelatesInSteps.zero_iff
