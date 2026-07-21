import Cslib.Languages.CCS.BehaviouralTheory
import Cslib.Languages.CCS.Basic
import Cslib.Foundations.Data.OmegaSequence.InfOcc
import Cslib.Foundations.Data.OmegaSequence.Init
import Cslib.Foundations.Data.OmegaSequence.Flatten
import Cslib.Foundations.Semantics.FLTS.LTSToFLTS
import Cslib.Foundations.Semantics.FLTS.Basic

-- CCS
#check Cslib.CCS.bisimilarity_par_nil
#check Cslib.CCS.bisimilarity_nil_par

#check Cslib.CCS.Act.Co.symm
#check Cslib.CCS.Act.co_isVisible

-- Omega Sequence
#check Cslib.ωSequence.frequently_iff_strictMono
#check Cslib.ωSequence.frequently_in_strictMono

#check Cslib.ωSequence.take_succ_cons
#check Cslib.ωSequence.take_succ'

#check Cslib.ωSequence.cumLen_one_add_drop
#check Cslib.ωSequence.cumLen_segment_one_add

#check Cslib.ωSequence.extract_eq_nil
#check Cslib.ωSequence.extract_eq_nil_iff

-- FLTS
#check Cslib.LTS.toFLTS_mem_mtr
#check Cslib.LTS.toFLTS_mtr_setImageMultistep

#check Cslib.FLTS.mtr_concat_eq
#check Cslib.FLTS.mtr_nil_eq
