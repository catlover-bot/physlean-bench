import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Typing
import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.WellFormed

open Cslib.LambdaCalculus.LocallyNameless.Fsub

lemma cslib_nonlocal_candidate_0007
  [DecidableEq Var]
  {Γ Δ : Env Var} {X : Var} {τ σ : Ty Var} {t : Term Var}
  (ht : Typing (Γ ++ ⟨X, Binding.ty τ⟩ :: Δ) t σ) :
  σ.Wf (Γ ++ Δ) :=
by
  obtain ⟨_hΓwf, _htLC, hσwf⟩ := Typing.wf ht
  exact Ty.Wf.strengthen hσwf
