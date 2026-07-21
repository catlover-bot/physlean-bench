import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Typing
import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.WellFormed

open Cslib.LambdaCalculus.LocallyNameless.Fsub

lemma cslib_nonlocal_candidate_v2_0007
  {Var : Type} [DecidableEq Var]
  {Γ Δ : Env Var} {X : Var} {τ σ : Ty Var} {t : Term Var}
  (ht : Typing (Γ ++ ⟨X, Binding.ty τ⟩ :: Δ) t σ)
  (hτ : τ.Wf (Γ ++ Δ)) :
  σ.Wf (Γ ++ Δ) :=
by
  -- From typing we obtain that the result type is well-formed in the larger environment
  obtain ⟨_, _, hσ⟩ := Typing.wf ht
  -- Now we strengthen the well-formedness to the smaller environment
  exact Ty.Wf.strengthen hσ
