import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Typing
import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.WellFormed

open Cslib.LambdaCalculus.LocallyNameless.Fsub

lemma Typing.ty_wf_strengthen
  {Γ Δ : Env Var} {X : Var} {τ σ : Ty Var} {t : Term Var}
  (ht : Typing (Γ ++ ⟨X, Binding.ty τ⟩ :: Δ) t σ) :
  σ.Wf (Γ ++ Δ) :=
by
  -- From typing we get well-formed environment, locally-closed term, and well-formed type
  obtain ⟨hΓwf, _htLC, hσwf⟩ := Typing.wf ht
  -- Strengthen the well-formedness of the result type by removing the binding
  exact Ty.Wf.strengthen hσwf
