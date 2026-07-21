import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Typing
import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Subtype

open Cslib.LambdaCalculus.LocallyNameless.Fsub

lemma subst_ty_and_sub
  (Γ Δ : Ctx)
  (X : TyVar)
  (t : Term)
  (τ σ τ' δ δ' : Ty)
  (der : Typing (Γ ++ ⟨X, Binding.sub δ'⟩ :: Δ) t τ)
  (sub₁ : Sub (Γ ++ ⟨X, Binding.sub δ'⟩ :: Δ) σ τ')
  (sub₂ : Sub Δ δ δ') :
  Typing (Γ.map_val (·[X := δ]) ++ Δ) (t[X := δ]) (τ[X := δ]) ∧
    Sub (Γ.map_val (·[X := δ]) ++ Δ) (σ[X := δ]) (τ'[X := δ]) :=
by
  refine And.intro ?h₁ ?h₂
  · -- typing part via `subst_ty`
    exact Typing.subst_ty der sub₂
  · -- subtyping part via `map_subst`
    exact Sub.map_subst sub₁ sub₂
