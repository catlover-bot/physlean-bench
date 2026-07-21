import Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Syntax

open LambdaCalculus

lemma cslib_nonlocal_candidate_0009
  {Var : Type} [DecidableEq Var]
  (x : Var) (M E : Untyped.Term Var)
  (hfv : x ∉ E.fv) (hLC : Untyped.LC M) :
  E ^ M = (E ^ Untyped.fvar x) [x := M] :=
Untyped.subst_intro x M E hfv hLC
