import Cslib.Languages.LambdaCalculus.LocallyNameless.Stlc.Basic
import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Opening

lemma Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.openRec_tm_lc_of_typing
  {Γ : Cslib.LambdaCalculus.LocallyNameless.Stlc.Context}
  {t s : Cslib.LambdaCalculus.LocallyNameless.Stlc.Term}
  {τ : Cslib.LambdaCalculus.LocallyNameless.Stlc.Ty}
  {x : Cslib.LambdaCalculus.LocallyNameless.Fsub.TmVar} :
  (Γ ⊢ t ∶ τ) → t = t⟦x ↝ s⟧ᵗᵗ :=
by
  intro h
  have ht : t.LC :=
    Cslib.LambdaCalculus.LocallyNameless.Stlc.Typing.lc h
  exact Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.openRec_tm_lc ht
