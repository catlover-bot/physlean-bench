import Cslib.Languages.LambdaCalculus.LocallyNameless.Stlc.Safety

open LambdaCalculus.LocallyNameless.Stlc
open LambdaCalculus.LocallyNameless.Stlc.Typing
open LambdaCalculus.LocallyNameless.Stlc.FullBeta

lemma cslib_nonlocal_candidate_v2_0016
    {t : Term Var} {τ : Ty Base}
    (ht : [] ⊢ t ∶ τ) :
    t.LC ∧ (t.Value ∨ ∃ t', t ⭢βᶠ t') :=
by
  have h_lc : t.LC := lc ht
  have h_prog : t.Value ∨ ∃ t', t ⭢βᶠ t' := progress ht
  exact ⟨h_lc, h_prog⟩
