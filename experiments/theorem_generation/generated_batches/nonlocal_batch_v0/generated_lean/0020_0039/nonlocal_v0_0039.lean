import Cslib.Languages.LambdaCalculus.LocallyNameless.Stlc.Basic
import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Opening

lemma Cslib.LambdaCalculus.LocallyNameless.Stlc.Typing.openRec_ty_lc_of_derivation
  {Var TyCtx : Type}
  {Γ : List TyCtx} {t : Cslib.LambdaCalculus.LocallyNameless.Stlc.Term Var}
  {τ : Cslib.LambdaCalculus.LocallyNameless.Stlc.Ty}
  {X : Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Var}
  {σ : Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty}
  (der : Γ ⊢ t ∶ τ) :
  (Cslib.LambdaCalculus.LocallyNameless.Fsub.Term.openRec_ty t X σ).LC :=
by
  have ht : t.LC :=
    Cslib.LambdaCalculus.LocallyNameless.Stlc.Typing.lc der
  have hEq :
    (t : Cslib.LambdaCalculus.LocallyNameless.Fsub.Term Var)
      = (t : Cslib.LambdaCalculus.LocallyNameless.Fsub.Term Var)⟦X ↝ σ⟧ᵗᵞ :=
    Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Term.openRec_ty_lc ht
  simpa [Cslib.LambdaCalculus.LocallyNameless.Fsub.Term.openRec_ty] using
    congrArg (fun t => t.LC) hEq
