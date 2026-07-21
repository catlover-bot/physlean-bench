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
import Cslib.Foundations.Semantics.LTS.Execution
import Cslib.Logics.HML.Basic
import Cslib.Logics.HML.LogicalEquivalence

namespace Cslib

namespace URM

theorem graphDerived_straightLine_finalState_regs_eq
    {p : Program} (hsl : p.IsStraightLine) (r : Regs) :
    (straightLine_finalState hsl r).regs = straightLine_finalRegs hsl r := by
  rcases straightLine_finalState_spec hsl r with ⟨hsteps, hhalted, _hpc⟩
  exact straightLine_finalRegs_eq_of_halted hsl r (straightLine_finalState hsl r) hsteps hhalted

theorem graphDerived_halts_iff_toStandardForm_halts
    {p : Program} {s : State} :
    (∃ s', Steps p s s' ∧ s'.isHalted p) ↔
      (∃ s', Steps p.toStandardForm s s' ∧ s'.isHalted p.toStandardForm) := by
  constructor
  · rintro ⟨s', hsteps, hhalted⟩
    rcases Steps.toStandardForm_halts hsteps hhalted with ⟨s₂, hsteps₂, hhalted₂, _hregs⟩
    exact ⟨s₂, hsteps₂, hhalted₂⟩
  · rintro ⟨s', hsteps, hhalted⟩
    rcases Steps.from_toStandardForm_halts hsteps hhalted with ⟨s₂, hsteps₂, hhalted₂, _hregs⟩
    exact ⟨s₂, hsteps₂, hhalted₂⟩

end URM

namespace LTS

theorem graphDerived_totalize_nonsink_single_mtr_iff_tr
    {State : Type u} {Label : Type v} {lts : LTS State Label}
    {μ : Label} {s t : State} :
    lts.totalize.MTr (Sum.inl s) [μ] (Sum.inl t) ↔ lts.Tr s μ t := by
  constructor
  · intro h
    have hm : lts.MTr s [μ] t := (totalize.nonsink_mtr_iff).mp h
    exact MTr.single_invert lts s μ t hm
  · intro h
    exact (totalize.nonsink_mtr_iff).mpr (MTr.single lts h)

theorem graphDerived_execution_of_tr_single
    {State : Type u} {Label : Type v} {lts : LTS State Label}
    {s t : State} {μ : Label}
    (h : lts.Tr s μ t) :
    ∃ ss, lts.Execution s [μ] t ss := by
  exact Execution.of_mTr (MTr.single lts h)

theorem graphDerived_mtr_of_execution
    {State : Type u} {Label : Type v} {lts : LTS State Label}
    {s1 s2 : State} {μs : List Label} :
    (∃ ss, lts.Execution s1 μs s2 ss) → lts.MTr s1 μs s2 := by
  intro h
  exact (mTr_iff_execution).mpr h

end LTS

namespace Logic.HML

theorem graphDerived_theoryEq_homBisimilarity_isBisimulation
    {State : Type u} {Label : Type v}
    (lts : LTS State Label)
    [∀ (s : State) (μ : Label), Finite ↑(lts.image s μ)] :
    lts.IsHomBisimulation lts.HomBisimilarity := by
  have h := theoryEq_isBisimulation lts
  have heq := theoryEq_eq_bisimilarity lts
  simpa [heq] using h

end Logic.HML

end Cslib

namespace Turing.StackTape

theorem graphDerived_empty_toList {Symbol : Type} :
    ((∅ : Turing.StackTape Symbol).toList = []) := by
  simpa [Turing.StackTape.empty_eq_nil] using
    (Turing.StackTape.nil_toList (Symbol := Symbol))

end Turing.StackTape

namespace Nat

theorem graphDerived_strictMono_range_has_strictMono
    {f : ℕ → ℕ} (hm : StrictMono f) :
    ∃ g : ℕ → ℕ, StrictMono g ∧ Set.range g = Set.range f := by
  exact Nat.infinite_strictMono (Nat.strictMono_infinite hm)

end Nat
