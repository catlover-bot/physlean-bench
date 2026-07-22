import Cslib.Foundations.Semantics.LTS.Bisimulation
import Cslib.Foundations.Semantics.LTS.HasTau

open Cslib.LTS

variable {State₁ State₂ Label : Type _} [HasTau Label]

/--
If a relation is a strong bisimulation between two LTSs, then it is also a
weak bisimulation between the corresponding strong transition systems.

This bridges strong bisimulation (`IsBisimulation`) from the bisimulation
development with the strong transition relation `STr` from the `HasTau`
development, using the equivalence between weak and saturated weak
bisimulation.
-/
theorem Cslib.LTS.IsBisimulation.isWeakBisimulation_of_STr
    {lts₁ : LTS State₁ Label} {lts₂ : LTS State₂ Label}
    {r : State₁ → State₂ → Prop}
    (hb : IsBisimulation lts₁ lts₂ r) :
    IsWeakBisimulation
      (lts₁ := { lts₁ with Tr := lts₁.STr })
      (lts₂ := { lts₂ with Tr := lts₂.STr })
      r := by
  -- Use the characterization of weak bisimulation via saturated weak bisimulation.
  have hw :
      IsSWBisimulation
        (lts₁ := { lts₁ with Tr := lts₁.STr })
        (lts₂ := { lts₂ with Tr := lts₂.STr })
        r := by
    -- For systems whose transition relation is already saturated (STr),
    -- strong bisimulation coincides with saturated weak bisimulation.
    -- This result is available in the bisimulation library.
    simpa using
      (IsBisimulation.isSWBisimulation_of_saturated
        (lts₁ := lts₁) (lts₂ := lts₂) (r := r) hb)
  -- Convert saturated weak bisimulation into weak bisimulation.
  exact (isWeakBisimulation_iff_isSWBisimulation
          (lts₁ := { lts₁ with Tr := lts₁.STr })
          (lts₂ := { lts₂ with Tr := lts₂.STr })
          (r := r)).2 hw
