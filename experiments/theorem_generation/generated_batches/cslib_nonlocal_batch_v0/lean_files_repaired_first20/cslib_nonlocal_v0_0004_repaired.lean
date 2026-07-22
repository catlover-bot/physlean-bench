import Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.FullEta
import Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Congruence

lemma cslib_nonlocal_candidate_0004
    {M N : Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Term}
    (hXi : Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Term.Xi
      (· Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Term.FullEta.⭢ηᶠ ·) M N) :
    Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Term.LC N :=
by
  refine
    Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Term.Xi.step_lc_r
      (R := (· Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Term.FullEta.⭢ηᶠ ·))
      ?hR
      hXi
  intro M' N' hStep
  exact
    Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Term.FullEta.step_lc_r
      (M := M') (M' := N') hStep
