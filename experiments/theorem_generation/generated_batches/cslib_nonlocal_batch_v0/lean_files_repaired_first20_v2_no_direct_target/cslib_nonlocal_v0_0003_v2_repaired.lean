import Cslib.Foundations.Semantics.LTS.Bisimulation
import Cslib.Foundations.Semantics.LTS.HasTau

open Cslib.LTS

variable {State : Type _} {Label : Type _} [HasTau Label]

/-- A concrete, nonempty witness of the reflexive–transitive closure `STr`:
every state can perform a trivial silent path (of length zero) to itself. -/
theorem cslib_nonlocal_candidate_v2_0003
    (lts : LTS State Label) (s : State) :
    STr lts s tau s :=
by
  -- By definition, `STr` is the reflexive–transitive closure of `Tr` along `tau`.
  -- The zero-length path is always available.
  exact STr.refl _ _
