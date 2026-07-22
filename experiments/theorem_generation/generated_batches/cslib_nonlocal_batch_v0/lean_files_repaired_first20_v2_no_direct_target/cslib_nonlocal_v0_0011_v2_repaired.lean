import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Typing
import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.WellFormed

lemma cslib_nonlocal_candidate_v2_0011
  {Var : Type} [DecidableEq Var]
  {Γ : Env Var} {t : Term Var} {σ τ δ : Ty Var}
  (ok_Γ : Γ✓)
  (ht : Typing Γ t (Ty.all σ τ))
  (wf_δ : δ.Wf Γ) :
  (τ ^ᵞ δ).Wf Γ :=
by
  -- From the typing derivation, obtain well-formedness of the resulting ∀-type
  have hwf_all : (Ty.all σ τ).Wf Γ :=
    (Cslib.LambdaCalculus.LocallyNameless.Fsub.Typing.wf ht).2
  -- Decompose the well-formedness of the ∀-type into its components
  rcases hwf_all with ⟨wf_σ, wf_body⟩
  -- Use local-closure of the body together with a well-formed argument
  -- to obtain well-formedness after opening.
  exact
    Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Wf.open_lc
      ok_Γ
      wf_body
      wf_δ
