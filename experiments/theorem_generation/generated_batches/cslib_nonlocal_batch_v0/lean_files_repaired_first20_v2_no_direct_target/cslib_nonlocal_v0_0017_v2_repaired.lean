import Cslib.Languages.CombinatoryLogic.Evaluation
import Cslib.Languages.CombinatoryLogic.Defs

theorem cslib_nonlocal_candidate_v2_0017
    {x y : Cslib.SKI.SKI}
    (hxy : x ↠ y)
    (hredfree : x.RedexFree) :
    x = y := by
  -- Use the characterization of `RedexFree` in terms of multi-step reduction
  have h := (Cslib.SKI.redexFree_iff_mred_eq).1 hredfree
  exact (h y).1 hxy
