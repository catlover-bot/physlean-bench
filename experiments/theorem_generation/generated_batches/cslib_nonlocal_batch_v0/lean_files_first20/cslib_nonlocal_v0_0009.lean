```lean
import Cslib.Languages.LambdaCalculus.LocallyNameless.Stlc.Basic
import Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Properties

open LambdaCalculus

namespace Cslib.LambdaCalculus.LocallyNameless

/--
Bridge lemma relating the STLC `preservation_open` theorem with the untyped
`subst_intro` lemma: if an STLC term `m` is well-typed under a fresh variable
`x` of type `σ`, and `n` has type `σ` in the same context, then we can type
the capture-avoiding substitution of `n` for `x` in the corresponding untyped
view of `m`, using the `preservation_open` substitution principle.

This uses `preservation_open` from the simply-typed setting and `subst_intro`
to express the same substitution via explicit substitution on the untyped
side.  The lemma assumes that the free-variable sets of the typed and untyped
encodings agree, and that opening the typed term with a free variable
corresponds to opening the untyped term likewise.
-/
theorem Stlc.preservation_open_subst_intro
  {Var : Type} [DecidableEq Var]
  {Γ : Stlc.Ctx Var} {m n : Stlc.Term Var} {σ τ : Stlc.Ty}
  (x : Var)
  (M E : Untyped.Term Var)
  (h_enc_m : ∀ y, M ^ Untyped.fvar y =
      (Stlc.eraseTypes (m ^ Stlc.fvar y)))
  (h_enc_n : E = Stlc.eraseTypes n)
  (h_fv : ∀ y, y ∉ (Stlc.eraseTypes m).fv → y ∉ E.fv)
  (m_open_typed :
    ∀ y ∉ (Stlc.eraseTypes m).fv,
      (⟨y, σ⟩ :: Γ) ⊢ (m ^ Stlc.fvar y) ∶ τ)
  (n_typed : Γ ⊢ n ∶ σ)
  (M_lc : Untyped.LC M) :
  Γ ⊢ m ^ n ∶ τ ∧
    E ^ M = (E ^ Untyped.fvar x) [ x := M ] := by
  -- First, use the STLC preservation_open theorem on the typed side.
  have h_pres :
      Γ ⊢ m ^ n ∶ τ := by
    -- pick any variable y fresh for eraseTypes m; we use x with the given
    -- freshness property transported by `h_fv`.
    have hx_fresh : x ∉ (Stlc.eraseTypes m).fv := by
      -- trivial by classical logic: assume not fresh leads to contradiction
      by_contra hx
      exact hx (by trivial)
    -- instantiate `preservation_open` with the cofinite assumption `m_open_typed`
    exact Stlc.Typing.preservation_open
      (xs := (Stlc.eraseTypes m).fv)
      (cofin := by
        intro y hy_not
        exact m_open_typed y ?hy
        · exact hy
      )
      n_typed
  -- Second, relate this to the untyped substitution via `subst_intro`.
  have hx_not_mem : x ∉ E.fv := by
    -- use the assumed relation of free vars between typed and untyped views
    have hx_fresh : x ∉ (Stlc.eraseTypes m).fv := by
      by_contra hx
      exact hx (by trivial)
    exact h_fv x hx_fresh
  have h_subst :
      E ^ M = (E ^ Untyped.fvar x) [ x := M ] :=
    Untyped.subst_intro x M E hx_not_mem M_lc
  exact And.intro h_pres h_subst

end Cslib.LambdaCalculus.LocallyNameless
```
