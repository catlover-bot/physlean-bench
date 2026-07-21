import Cslib.Computability.Automata.NA.Hist

namespace Cslib.Automata.NA

open Prod ωSequence
open scoped LTS

theorem graphDerived_run_iff_exists_addHist_run
    {Symbol : Type u} {State : Type v} {Hist : Type w}
    {na : NA State Symbol}
    {start' : State → Hist}
    {tr' : State × Hist → Symbol → State → Hist}
    {xs : ωSequence Symbol}
    {ss : ωSequence State} :
    na.Run xs ss ↔
      ∃ ss', (na.addHist start' tr').Run xs ss' ∧
        ss'.map Prod.fst = ss := by
  constructor
  · intro h
    exact hist_run_exists h
  · rintro ⟨ss', hRun, hProj⟩
    rw [← hProj]
    exact hist_run_proj hRun

end Cslib.Automata.NA
