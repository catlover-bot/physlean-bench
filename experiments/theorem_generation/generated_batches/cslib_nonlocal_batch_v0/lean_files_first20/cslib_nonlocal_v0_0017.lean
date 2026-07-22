import Cslib.Languages.CombinatoryLogic.Evaluation
import Cslib.Languages.CombinatoryLogic.Defs

theorem Cslib.SKI.redexFree_of_mred_irrefl {x : SKI}
    (h : ∀ ⦃y : SKI⦄, (x ↠ y) → x = y) :
    x.RedexFree := by
  -- Use the characterization of `RedexFree` via multi-step reduction
  refine (Cslib.SKI.redexFree_iff_mred_eq).2 ?_
  intro y
  constructor
  · intro hxy
    have := h hxy
    simpa using this
  · intro hxy
    -- From `x = y` obtain a multi-step reduction `x ↠ y`
    simpa [hxy] using Cslib.SKI.mred_refl x
