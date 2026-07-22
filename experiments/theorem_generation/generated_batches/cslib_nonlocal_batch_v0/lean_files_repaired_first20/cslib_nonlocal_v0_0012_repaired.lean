import Cslib.Foundations.Semantics.LTS.Bisimulation
import Cslib.Foundations.Semantics.LTS.Basic

open Cslib.LTS

variable {State Label : Type} (lts : LTS State Label)

theorem cslib_nonlocal_candidate_0012
  {s₁ s₂ : State} {μ : Label}
  (htr : lts.Tr s₁ μ s₂) :
  lts.MTr s₁ [μ] s₂ :=
by
  simpa using (MTr.single (lts := lts) htr)
