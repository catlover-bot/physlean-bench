import Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Basic
import Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Properties

open LambdaCalculus

theorem cslib_nonlocal_candidate_v2_0009
  {Var : Type} [DecidableEq Var]
  (x : Var) (M E : Untyped.Term Var)
  (h_fresh : x ∉ M.fv)
  (h_lcM : Untyped.LC M) :
  (E ^ Untyped.fvar x) [x := M] = E ^ M := by
  symm
  exact Untyped.Term.subst_intro x M E h_fresh h_lcM
