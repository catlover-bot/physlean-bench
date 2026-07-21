import Cslib.Foundations.Semantics.LTS.TraceEq
import Cslib.Foundations.Semantics.LTS.Bisimulation

lemma TraceEq.isSimulation_iff_isBisimulation_on_deterministic
  {lts₁ : LTS State₁ Label} {lts₂ : LTS State₂ Label}
  [lts₁.Deterministic] [lts₂.Deterministic] :
  IsSimulation lts₁ lts₂ (TraceEq lts₁ lts₂) ∧
    IsSimulation lts₂ lts₁ (TraceEq lts₁ lts₂) ↔
    IsBisimulation lts₁ lts₂ (TraceEq lts₁ lts₂) :=
by
  constructor
  · intro h
    have : IsBisimulation lts₁ lts₂ (TraceEq lts₁ lts₂) :=
      Cslib.LTS.IsBisimulation.deterministic_traceEq_isBisimulation
    exact this
  · intro h
    refine And.intro ?h₁ ?h₂
    · exact Cslib.LTS.TraceEq.deterministic_isSimulation
    · have hSymm : TraceEq lts₁ lts₂ = fun s₁ s₂ => TraceEq lts₂ lts₁ s₂ s₁ := by
        funext s₁ s₂
        rfl
      simpa [hSymm] using (Cslib.LTS.TraceEq.deterministic_isSimulation
        (lts₁ := lts₂) (lts₂ := lts₁))
