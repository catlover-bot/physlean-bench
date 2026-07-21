import Cslib.LambdaCalculus.LocallyNameless.Stlc.Typing

open Cslib.LambdaCalculus.LocallyNameless.Stlc

theorem cslib_nonlocal_candidate_0016
    {Γ : Ctx} {t : Term} {τ : Ty}
    (ht : Typing Γ t τ) :
    LC t :=
by
  exact Typing.lc ht
