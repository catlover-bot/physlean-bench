import Cslib.Foundations.Semantics.LTS.TraceEq
import Cslib.Foundations.Semantics.LTS.Bisimulation

theorem Bisimilarity.deterministic_isSimulation
  {State₁ State₂ Label : Type _}
  {lts₁ : LTS State₁ Label} {lts₂ : LTS State₂ Label}
  [hdet₁ : lts₁.Deterministic] [hdet₂ : lts₂.Deterministic] :
  IsSimulation lts₁ lts₂ (Bisimilarity lts₁ lts₂) := by
  have h := TraceEq.deterministic_isSimulation
    (lts₁ := lts₁) (lts₂ := lts₂)
  simpa [Bisimilarity.deterministic_bisim_eq_traceEq] using h
