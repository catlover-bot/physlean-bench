import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Typing
import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.WellFormed

open Cslib.LambdaCalculus.LocallyNameless.Fsub

lemma cslib_nonlocal_candidate_v2_0008
    {Var : Type} [DecidableEq Var]
    {Γ : Env Var} {t : Term Var} {τ σ : Ty Var} {X : Var}
    (der : Typing Γ t τ)
    (bind : Binding.ty σ ∈ Γ.dlookup X) :
    σ.Wf Γ ∧ τ.Wf Γ :=
by
  -- From typing we get well-formed environment and result type
  have h := Typing.wf der
  rcases h with ⟨hΓ, _htLC, hτ⟩
  -- From a type binding in a well-formed environment we get a well-formed type
  have hσ : σ.Wf Γ := Ty.Wf.of_bind_ty hΓ bind
  exact ⟨hσ, hτ⟩
