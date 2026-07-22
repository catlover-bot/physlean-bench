import Cslib.Languages.CCS.BehaviouralTheory
import Cslib.Foundations.Semantics.FLTS.LTSToFLTS
import Cslib.Foundations.Semantics.FLTS.Basic

namespace Cslib

namespace CCS

theorem graphDerived_bisimilarity_par_nil_nil_par
    {Name : Type u} {Constant : Type v}
    {defs : Constant → Process Name Constant → Prop}
    {p : Process Name Constant} :
    (lts (defs := defs)).HomBisimilarity
      (p.par Process.nil) (Process.nil.par p) := by
  exact LTS.Bisimilarity.trans
    (bisimilarity_par_nil (defs := defs) (p := p))
    (LTS.Bisimilarity.symm
      (bisimilarity_nil_par (defs := defs) (p := p)))

end CCS

namespace LTS

theorem graphDerived_mem_setImageMultistep_iff
    {State : Type u} {Label : Type v}
    {lts : LTS State Label} {S : Set State}
    {s' : State} {μs : List Label} :
    s' ∈ lts.setImageMultistep S μs ↔
      ∃ s ∈ S, lts.MTr s μs s' := by
  rw [← lts.toFLTS_mtr_setImageMultistep]
  exact toFLTS_mem_mtr

end LTS

namespace FLTS

theorem graphDerived_mtr_singleton_eq_tr
    {State : Type u} {Label : Type v}
    {flts : FLTS State Label} {s : State} {μ : Label} :
    flts.mtr s [μ] = flts.tr s μ := by
  simpa [mtr_nil_eq] using
    (mtr_concat_eq
      (flts := flts)
      (s := s)
      (μs := [])
      (μ := μ))

end FLTS

end Cslib
