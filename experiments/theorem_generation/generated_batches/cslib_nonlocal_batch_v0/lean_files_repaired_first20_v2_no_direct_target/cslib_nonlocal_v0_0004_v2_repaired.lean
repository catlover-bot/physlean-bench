import Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.FullEta
import Cslib.Languages.LambdaCalculus.LocallyNameless.Untyped.Congruence

open Cslib.LambdaCalculus.LocallyNameless.Untyped

lemma cslib_nonlocal_candidate_v2_0004
    {R : Term → Term → Prop} {M N : Term}
    (hXi : Xi R M N)
    (hR_step_lc : ∀ {M' N'}, R M' N' → LC N')
    (hEta_closed : ∀ {M' N'}, (· ⭢ηᶠ ·) M' N' → LC N') :
    LC N :=
by
  -- From local closure of R-steps and a Xi-context step, obtain LC N using Xi.step_lc_r
  have h₁ : LC N :=
    Term.Xi.step_lc_r (R := R)
      (by
        intro M' N' hR
        exact hR_step_lc hR)
      hXi
  -- hEta_closed is unused in the derivation of LC N but shows compatibility
  exact h₁
