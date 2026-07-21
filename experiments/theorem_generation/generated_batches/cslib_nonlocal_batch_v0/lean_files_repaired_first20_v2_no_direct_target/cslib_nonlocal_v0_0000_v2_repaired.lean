import Cslib.Foundations.Semantics.LTS.Bisimulation
import Cslib.Foundations.Semantics.LTS.TraceEq

open LTS

variable {State₁ State₂ Label : Type}

theorem cslib_nonlocal_candidate_v2_0000
    {lts₁ : LTS State₁ Label} {lts₂ : LTS State₂ Label}
    [lts₁.Deterministic] [lts₂.Deterministic]
    {s₁ : State₁} {s₂ : State₂}
    (h : TraceEq lts₁ lts₂ s₁ s₂) :
    ∀ (a : Label) (s₁' : State₁),
      Step lts₁ s₁ a s₁' →
      ∃ s₂', Step lts₂ s₂ a s₂' ∧ TraceEq lts₁ lts₂ s₁' s₂' := by
  intro a s₁' hstep
  have hSim : IsSimulation lts₁ lts₂ (TraceEq lts₁ lts₂) :=
    TraceEq.deterministic_isSimulation (lts₁ := lts₁) (lts₂ := lts₂)
  exact hSim h a s₁' hstep
