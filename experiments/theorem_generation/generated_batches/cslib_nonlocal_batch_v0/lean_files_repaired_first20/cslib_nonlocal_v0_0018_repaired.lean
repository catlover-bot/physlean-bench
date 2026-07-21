import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Subtype

open Cslib.LambdaCalculus.LocallyNameless.Fsub

lemma cslib_nonlocal_candidate_0018
  (Γ Δ : Ctx)
  (X : TyVar)
  (τ σ τ' δ δ' : Ty)
  (sub₁ : Sub (Γ ++ ⟨X, Binding.sub δ'⟩ :: Δ) σ τ')
  (sub₂ : Sub Δ δ δ') :
  Sub (Γ.map_val (·[X := δ]) ++ Δ) (σ[X := δ]) (τ'[X := δ]) :=
by
  simpa using Sub.map_subst sub₁ sub₂
