import Cslib.Foundations.Semantics.LTS.Basic
import Cslib.Foundations.Semantics.LTS.Trace

open Cslib.LTS

variable {State Label : Type} (lts : LTS State Label)

theorem cslib_nonlocal_candidate_v2_0012
  {s t u : State} {μ : Label}
  (h₁ : lts.Tr s μ t) (h₂ : lts.MTr t [] u) :
  lts.MTr s [μ] u :=
by
  -- build the single-step multi-trace from the one-step transition
  have hsingle : lts.MTr s [μ] t := by
    simpa using (MTr.single (lts := lts) h₁)
  -- concatenate with the empty trace from t to u
  simpa using (MTr.append (lts := lts) hsingle h₂)
