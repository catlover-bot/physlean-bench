import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Typing
import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.WellFormed

open Cslib.LambdaCalculus.LocallyNameless.Fsub

lemma cslib_nonlocal_candidate_0008
    {Var : Type} [DecidableEq Var]
    {Γ : Env Var} {t : Term Var} {τ σ : Ty Var} {X : Var}
    (der : Typing Γ t τ)
    (bind : Binding.ty σ ∈ Γ.dlookup X) :
    σ.Wf Γ ∧ τ.Wf Γ :=
by
  have h := Typing.wf der
  rcases h with ⟨hΓ, _htLC, hτ⟩
  have hσ : σ.Wf Γ := Ty.Wf.of_bind_ty hΓ bind
  exact ⟨hσ, hτ⟩
