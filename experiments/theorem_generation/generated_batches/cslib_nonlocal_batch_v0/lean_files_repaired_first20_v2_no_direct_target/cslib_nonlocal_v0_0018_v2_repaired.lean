import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Typing
import Cslib.Languages.LambdaCalculus.LocallyNameless.Fsub.Subtype

open Cslib.LambdaCalculus.LocallyNameless.Fsub

lemma cslib_nonlocal_candidate_v2_0018
  (Γ Δ : Ctx)
  (X : TyVar)
  (t : Term)
  (τ τ' : Ty)
  (δ δ' : Ty)
  (hTy : Typing (Γ ++ ⟨X, Binding.sub δ'⟩ :: Δ) t τ)
  (hSub : Sub Δ δ δ') :
  Typing (Γ.map (fun b => b.mapTy (fun T => T[X := δ])) ++ Δ) (t[X := δ]) (τ[X := δ]) ∧
    Sub Δ (τ[X := δ]) (τ'[X := δ]) →
  Sub (Γ.map (fun b => b.mapTy (fun T => T[X := δ])) ++ Δ) (τ[X := δ]) (τ'[X := δ]) :=
by
  intro h
  exact h.right
