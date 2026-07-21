import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Typing
import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.WellFormed

lemma Cslib.LambdaCalculus.LocallyNameless.Fsub.Typing.wf_result_open_ty
  {Γ : Env Var} {t : Term Var} {σ τ δ : Ty Var}
  (ok_Γ : Γ✓)
  (der : Typing Γ t (Ty.all σ τ))
  (wf_δ : δ.Wf Γ) :
  (τ ^ᵞ δ).Wf Γ :=
by
  -- From typing derivation, obtain well-formedness of the result type
  have h := Cslib.LambdaCalculus.LocallyNameless.Fsub.Typing.wf der
  rcases h with ⟨_, _, wf_all⟩
  -- Use well-formedness lemma for opening the body of an ∀-type
  exact Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Wf.open_lc ok_Γ wf_all wf_δ
