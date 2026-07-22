import Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.FullEta
import Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Congruence

open LambdaCalculus.LocallyNameless.Untyped

@[scoped grind →]
lemma Xi_fullEta_step_lc_r
    {M N : Term}
    (hR : ∀ {M' N'}, (· ⭢ηᶠ ·) M' N' → LC N')
    (hXi : Xi (· ⭢ηᶠ ·) M N) :
    LC N :=
by
  refine Term.Xi.step_lc_r (R := (· ⭢ηᶠ ·)) ?hR hXi
  intro M' N' hStep
  exact Cslib.LambdaCalculus.LocallyNameless.Untyped.Term.FullEta.step_lc_r (M := M') (M' := N') hStep
