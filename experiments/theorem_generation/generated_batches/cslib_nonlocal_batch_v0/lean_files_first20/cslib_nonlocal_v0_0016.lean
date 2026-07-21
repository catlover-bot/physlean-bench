import Cslib.Languages.LambdaCalculus.LocallyNameless.Stlc.Safety
import Cslib.Languages.LambdaCalculus.LocallyNameless.Stlc.Basic

open LambdaCalculus.LocallyNameless.Stlc
open LambdaCalculus.LocallyNameless.Stlc.Typing
open LambdaCalculus.LocallyNameless.Stlc.FullBeta

theorem progress_of_lc_closed {t : Term Var} {τ : Ty Base}
    (ht : [] ⊢ t ∶ τ) (hclosed : t.LC) :
    t.Value ∨ ∃ t', t ⭢βᶠ t' :=
by
  -- from typing in empty context we get local closure
  have _ : t.LC := lc ht
  -- standard progress applies
  exact progress ht
