import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Typing
import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.WellFormed

lemma cslib_nonlocal_candidate_0011
  {Γ : Env Var} {t : Term Var} {σ τ δ : Ty Var}
  (ok_Γ : Γ✓)
  (der : Typing Γ t (Ty.all σ τ))
  (wf_δ : δ.Wf Γ) :
  (τ ^ᵞ δ).Wf Γ :=
by
  have h := Cslib.LambdaCalculus.LocallyNameless.Fsub.Typing.wf der
  rcases h with ⟨_, _, wf_all⟩
  exact Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Wf.open_lc ok_Γ wf_all wf_δ
