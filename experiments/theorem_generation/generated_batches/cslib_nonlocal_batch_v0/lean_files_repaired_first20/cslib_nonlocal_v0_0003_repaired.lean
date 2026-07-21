import Cslib.Foundations.Semantics.LTS.HasTau

open Cslib.LTS

variable {State Label : Type _} [HasTau Label] {lts : LTS State Label}

/--
If there is a single transition in the underlying transition relation `Tr` of an LTS,
then there is a corresponding one-step transition in its strong transition relation `STr`.
-/
theorem cslib_nonlocal_candidate_0003
    {s s' : State} {ℓ : Label}
    (h : lts.Tr s ℓ s') :
    lts.STr s ℓ s' :=
by
  -- `STr.single` states exactly that any single `Tr`-step is an `STr`-step.
  simpa using (LTS.STr.single (lts := lts) (s := s) (s' := s') (ℓ := ℓ) h)
