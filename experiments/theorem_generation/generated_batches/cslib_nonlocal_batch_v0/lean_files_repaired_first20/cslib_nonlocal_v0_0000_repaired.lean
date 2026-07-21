import Cslib.Foundations.Semantics.LTS.Bisimulation
import Cslib.Foundations.Semantics.LTS.TraceEq

open LTS

theorem cslib_nonlocal_candidate_0000
    {State₁ State₂ Label : Type}
    {lts₁ : LTS State₁ Label} {lts₂ : LTS State₂ Label}
    [lts₁.Deterministic] [lts₂.Deterministic]
    {s₁ s₁' : State₁} {s₂ : State₂} {a : Label}
    (hR : TraceEq lts₁ lts₂ s₁ s₂)
    (hstep : Step lts₁ s₁ a s₁') :
    ∃ s₂', Step lts₂ s₂ a s₂' ∧ TraceEq lts₁ lts₂ s₁' s₂' := by
  -- obtain the simulation from determinism and trace equivalence
  have hSim :
      IsSimulation lts₁ lts₂ (TraceEq lts₁ lts₂) :=
    TraceEq.deterministic_isSimulation (lts₁ := lts₁) (lts₂ := lts₂)
  -- apply the simulation property at the given step
  rcases hSim hR a s₁' hstep with ⟨s₂', hstep₂, hR'⟩
  exact ⟨s₂', hstep₂, hR'⟩
