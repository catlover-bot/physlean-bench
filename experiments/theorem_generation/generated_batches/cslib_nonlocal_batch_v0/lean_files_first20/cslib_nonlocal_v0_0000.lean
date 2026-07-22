import Cslib.Foundations.Semantics.LTS.Bisimulation
import Cslib.Foundations.Semantics.LTS.TraceEq

open LTS

namespace Cslib.LTS

variable {State₁ State₂ Label : Type}

/--
From a deterministic trace-equivalence simulation we can extract, for each pair of
trace-equivalent states, a matching transition in the second LTS witnessing simulation
in the forward direction of the bisimulation.

This theorem bridges the bisimulation and simulation viewpoints on trace equivalence
under determinism assumptions.
-/
theorem TraceEq.step_of_deterministic_isSimulation
    {lts₁ : LTS State₁ Label} {lts₂ : LTS State₂ Label}
    [lts₁.Deterministic] [lts₂.Deterministic]
    {s₁ s₁' : State₁} {s₂ : State₂} {a : Label}
    (hR : TraceEq lts₁ lts₂ s₁ s₂)
    (hstep : Step lts₁ s₁ a s₁') :
    ∃ s₂', Step lts₂ s₂ a s₂' ∧ TraceEq lts₁ lts₂ s₁' s₂' := by
  -- Use the global simulation result based on trace equivalence under determinism
  have hSim :
      IsSimulation lts₁ lts₂ (TraceEq lts₁ lts₂) :=
    TraceEq.deterministic_isSimulation (lts₁ := lts₁) (lts₂ := lts₂)
  -- Unfold the simulation condition at the chosen pair of states
  rcases hSim hR a s₁' hstep with ⟨s₂', hstep₂, hR'⟩
  refine ⟨s₂', hstep₂, hR'⟩

end Cslib.LTS
